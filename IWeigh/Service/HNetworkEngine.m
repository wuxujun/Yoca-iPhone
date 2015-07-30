//
//  HNetworkEngine.m
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "HNetworkEngine.h"
#import "HNetworkOperation.h"

@implementation HNetworkEngine

@synthesize workingOperations;

-(MKNetworkOperation *)getOperationWithURLString:(NSString *)urlString params:(NSMutableDictionary *)params success:(OperationSuccessBlock)successBlock error:(MKNKErrorBlock)errorBlock{
    return [self hOperationWithURLString:urlString params:params method:@"GET" success:successBlock error:errorBlock];
}

-(MKNetworkOperation *)postOperationWithURLString:(NSString *)urlString params:(NSMutableDictionary *)params success:(OperationSuccessBlock)successBlock error:(MKNKErrorBlock)errorBlock{
    return [self hOperationWithURLString:urlString params:params method:@"POST" success:successBlock error:errorBlock];
}

-(MKNetworkOperation *)postDatasWithURLString:(NSString *)urlString datas:(NSMutableDictionary *)dataAndKey process:(MKNKProgressBlock)processBlock success:(OperationSuccessBlock)successBlock error:(MKNKErrorBlock)errorBlock
{
    MKNetworkOperation *operation = [self operationWithURLString:urlString params:[dataAndKey objectForKey:@"content"] httpMethod:@"POST"];
    [dataAndKey enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        DLog(@"%@  %@",obj,key);
        if ([key isEqualToString:@"content"]) {
            NSDictionary* dc=[obj objectForKey:@"images"];
            if ([dc objectForKey:@"image"]) {
                [operation addFile:[dc objectForKey:@"image"] forKey:@"image" mimeType:@"image/jpeg"];
            }
        }
//        [operation addData:obj forKey:key];
    }];
    [operation onUploadProgressChanged:processBlock];
    
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *json = [completedOperation responseJSON];
        id status = [json objectForKey:@"status"];
        if (status!=nil && [status intValue]!=1) {//
            NSString *message = [json objectForKey:@"errorMsg"];
            DLog(@"%@",message);
            NSError *error = [[NSError alloc] initWithDomain:message? : @"请求服务器发生错误。" code:-1 userInfo:nil];
            errorBlock(error);
        }else {
            //DLog(@"result json:%@", json);
            successBlock(completedOperation,json);
        }
    } onError:^(NSError *error) {
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            error = [NSError errorWithDomain:@"网络错误，请检查网络配置。" code:-1 userInfo:0];
        }
        errorBlock(error);
    }];
    
    [self enqueueOperation:operation];
    
    return operation;
}


-(MKNetworkOperation *)hOperationWithURLString:(NSString *)urlString params:(NSMutableDictionary *)params method:(NSString *)method success:(OperationSuccessBlock)successBlock error:(MKNKErrorBlock)errorBlock{
    
    MKNetworkOperation *operation = [self operationWithURLString:urlString params:params httpMethod:method];
    
    [operation onCompletion:^(MKNetworkOperation *completedOperation) {
        NSDictionary *json = [completedOperation responseJSON];
        id status = [json objectForKey:@"success"];
        if (status!=nil && [status intValue]!=1) {//
            NSString *message = [json objectForKey:@"errorMsg"];
            DLog(@"%@",message);
            NSError *error = [[NSError alloc] initWithDomain:message? : @"请求服务器发生错误。" code:-1 userInfo:nil];
            errorBlock(error);
        }else {
            //DLog(@"result json:%@", json);
            //            NSAssert(json, @"no data....");
            successBlock(completedOperation,json);
        }
    } onError:^(NSError *error) {
        if ([error.domain isEqualToString:@"NSURLErrorDomain"]) {
            error = [NSError errorWithDomain:@"网络错误，请检查网络配置。" code:-1 userInfo:0];
        }
        errorBlock(error);
    }];
    
    [self enqueueOperation:operation];
    
    return operation;
}



- (void)canelAllOperations {
    [workingOperations makeObjectsPerformSelector:@selector(cancel)];
    [workingOperations removeAllObjects];
}

- (id) initWithHostName:(NSString*) hostName customHeaderFields:(NSDictionary*) headers{
    self = [super initWithHostName:hostName customHeaderFields:headers];
    if (self) {
        [self registerOperationSubclass:[HNetworkOperation class]];
        self.workingOperations = [NSMutableArray array];
        return self;
    }
    return nil;
}


-(void)enqueueOperation:(MKNetworkOperation *)operation forceReload:(BOOL)forceReload{
    [super enqueueOperation:operation forceReload:forceReload];
    
    if (![workingOperations containsObject:operation]) {
        [workingOperations addObject:operation];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkOperationFinished:) name:NetworkOperationFinishedNotification object:operation];
    }
}

-(void)networkOperationFinished:(NSNotification *)notification{
    HNetworkOperation *operation = notification.object;
    if (operation!=nil) {
        [workingOperations removeObject:operation];
    }
}

-(int)cacheMemoryCost {
    return 1;
}

-(void)dealloc{
    [self canelAllOperations];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
