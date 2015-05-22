//
//  blocktypedef.h
//  Youhui
//
//  Created by xujun on 13-8-13.
//
//

#ifndef Youhui_blocktypedef_h
#define Youhui_blocktypedef_h

typedef void(^HBlock)(void);
typedef void(^HBlockBlock)(HBlock block);
typedef void(^HObjectBlock)(id obj);
typedef void(^HArrayBlock)(NSArray *array);
typedef void(^HMutableArrayBlock)(NSMutableArray *array);
typedef void(^HDictionaryBlock)(NSDictionary *dic);
typedef void(^HErrorBlock)(NSError *error);
typedef void(^HIndexBlock)(NSInteger index);
typedef void(^HFloatBlock)(CGFloat afloat);
typedef void(^HBOOLBlock)(BOOL success);

#endif
