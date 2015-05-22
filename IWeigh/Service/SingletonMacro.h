//
//  SingletonMacro.h
//  Youhui
//
//  Created by xujunwu on 15/2/4.
//  Copyright (c) 2015年 ___xujun___. All rights reserved.
//

#ifndef Youhui_SingletonMacro_h
#define Youhui_SingletonMacro_h

#define SINGLETON_FOR_CLASS(classname) \
\
\
static classname *shared##classname = nil;\
+(classname *)sharedInstance{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
shared##classname = [[self alloc] init];\
});\
return shared##classname;\
}\
\
-(id)init{\
if(shared##classname != nil){\
[NSException raise:NSInternalInconsistencyException\
format:@"[%@ %@] cannot be called; use +[%@ %@] instead"],NSStringFromClass([self class]), \
NSStringFromSelector(_cmd), \
NSStringFromClass([self class]),\
NSStringFromSelector(@selector(shared##classname));\
}else if(self=[super init]){\
shared##classname = self;\
if ([self respondsToSelector:@selector(instanceDidCreated)])\
[shared##classname performSelector:@selector(instanceDidCreated)];\
if ([self respondsToSelector:@selector(willTerminate)])\
[[NSNotificationCenter defaultCenter] addObserver:shared##classname selector:@selector(willTerminate) name:UIApplicationWillTerminateNotification object:nil];\
if ([self respondsToSelector:@selector(didReceiveMemoryWarning)])\
[[NSNotificationCenter defaultCenter] addObserver:shared##classname selector:@selector(didReceiveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];\
}\
return shared##classname;\
}\
\
-(void)dealloc{\
[[NSNotificationCenter defaultCenter] removeObserver:self];\
}


#endif
