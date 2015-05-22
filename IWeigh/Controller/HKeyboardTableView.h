//
//  HKeyboardTableView.h
//  BaseApp
//
//  Created by xujun wu on 13-7-13.
//  Copyright (c) 2013年 xujun wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HKeyboardTableView : UITableView
{
    UIEdgeInsets    _priorInset;
    BOOL            _priorInsetSaved;
    BOOL            _keyboardVisible;
    CGRect          _keyboardRect;
}

- (void)adjustOffsetToIdealIfNeeded;

@end
