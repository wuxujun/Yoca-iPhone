//
//  UIView+LoadingView.m
//
//
//  Created by wuxujun on 11-5-16.
//  Copyright 2011 ___xujun___. All rights reserved.
//

#import "UIView+LoadingView.h"

#import "HUDLoadingView.h"

#define kLoadingViewTag     100099


@implementation UIView (LoadingView)

- (void)showHUDLoadingView:(BOOL)shows {
    HUDLoadingView *loadingView = (HUDLoadingView *)[self viewWithTag:kLoadingViewTag];
    if (shows) {
        if (loadingView == nil) {
            loadingView = [[HUDLoadingView alloc] initWithFrame:self.bounds];
            loadingView.tag = kLoadingViewTag;
        }
        loadingView.frame = self.bounds;
        [self addSubview:loadingView];
        self.userInteractionEnabled = NO;
    } else {
        [loadingView removeFromSuperview];
        self.userInteractionEnabled = YES;
    }
}

- (void)showHUDLoadingViewAT:(CGRect)rect {
    HUDLoadingView *loadingView = (HUDLoadingView *)[self viewWithTag:kLoadingViewTag];

    if (loadingView == nil) {
        loadingView = [[HUDLoadingView alloc] initWithFrame:self.bounds];
        loadingView.tag = kLoadingViewTag;
    }
    loadingView.frame = rect;
    [self addSubview:loadingView];
}

@end
