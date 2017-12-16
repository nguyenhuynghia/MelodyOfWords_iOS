//
//  UIViewController+Utility.h
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utility)
@property (nonatomic, assign) BOOL selfHandleBackNavi;
@property (nonatomic, assign) BOOL supportDefaultLeft;
@property (nonatomic, assign) BOOL supportDefaultRight;
@property (nonatomic, assign) BOOL supportNaviButton;
@property (nonatomic, assign) BOOL selfHideNavi;

- (void)backNaviBtnTouched;
- (void)exclusiveTouchAllBtns:(BOOL)exclusiveTouch;
@end
