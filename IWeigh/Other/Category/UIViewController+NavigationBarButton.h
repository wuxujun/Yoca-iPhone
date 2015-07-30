//
//  UIViewController+NavigationBarButton.h
//
//
//  Created by wuxujun on 13-8-20.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBarButton)
- (void)setCenterTitle:(NSString*)title;
- (void)addCenterSearchBar:(SEL)action;
- (void)removeCenterSearchBar;
- (void)addBackBarButton;
- (void)addLeftTitleButton:(NSString* ) title action:(SEL)action;
- (void)addRightTitleButton:(NSString* )title action:(SEL)action;
- (void)addRightSearchButton:(SEL)action;
- (void)addRightFavoriteButton:(BOOL)isCollected action:(SEL)action;
- (void)addRightSettingButton:(SEL)action;
- (void)addRightButtonWithTitle:(NSString *)title withSel:(SEL)action;
- (void)addWritePostBarButton:(SEL)action;
- (BOOL)viewWillDisappearDueToPushing:(UIViewController *)viewController;
- (BOOL)viewWillDisappearDueToPopping;

@end
