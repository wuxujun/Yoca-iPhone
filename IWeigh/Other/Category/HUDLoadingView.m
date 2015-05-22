//
//  HUDLoadingView.m
//  
//
//  Created by wuxujun on 11-5-13.
//  Copyright 2011 ___xujun___. All rights reserved.
//

#import "HUDLoadingView.h"


@implementation HUDLoadingView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        CGSize size = frame.size;
        
        blackView = [[UIView alloc] initWithFrame:CGRectMake(floor((size.width-80)/2.0), floor((size.height-80)/2.0), 80, 80)];
        blackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        blackView.layer.cornerRadius = 6.0;
        blackView.clipsToBounds = YES;
        blackView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:blackView];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [indicator sizeToFit];
        indicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        indicator.frame = CGRectMake(floor((frame.size.width-indicator.bounds.size.width)/2.0),
                                     floor((frame.size.height-indicator.bounds.size.height)/2.0),
                                     indicator.bounds.size.width,
                                     indicator.bounds.size.height);
        [indicator startAnimating];
        [self addSubview:indicator];
    }
    
    return self;
}



@end
