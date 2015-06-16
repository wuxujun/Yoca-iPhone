//
//  VerticallyAlignedLabel.h
//  GrpCust
//  UILabel 文字排列 置顶
//  Created by 吴旭俊 on 11-10-7.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum VerticalAlignment{
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
}VerticalAlignment;

@interface VerticallyAlignedLabel : UILabel {
    @private
    VerticalAlignment   _verticalAlignment;
}
@property (nonatomic, assign) VerticalAlignment verticalAlignment;


@end
