//
//  HNetworkEngine.h
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "JSONKit.h"

typedef void (^OperationSuccessBlock)(MKNetworkOperation* completedOperation,id result);

@interface HNetworkEngine : MKNetworkEngine

@property(nonatomic, strong) NSMutableArray *workingOperations;


-(MKNetworkOperation *)getOperationWithURLString:(NSString *)urlString params:(NSMutableDictionary *)params success:(OperationSuccessBlock)successBlock error:(MKNKErrorBlock)errorBlock;

-(MKNetworkOperation *)postOperationWithURLString:(NSString *)urlString params:(NSMutableDictionary *)params success:(OperationSuccessBlock)successBlock error:(MKNKErrorBlock)errorBlock;

-(MKNetworkOperation *)postDatasWithURLString:(NSString *)urlString datas:(NSMutableDictionary *)dataAndKey process:(MKNKProgressBlock)processBlock success:(OperationSuccessBlock)successBlock error:(MKNKErrorBlock)errorBlock;

- (void)canelAllOperations;


@end
