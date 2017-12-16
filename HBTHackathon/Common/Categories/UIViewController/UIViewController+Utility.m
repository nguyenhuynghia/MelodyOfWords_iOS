//
//  UIViewController+Utility.m
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "UIViewController+Utility.h"
#import "objc/runtime.h"
@implementation UIViewController (Utility)
@dynamic selfHandleBackNavi;
@dynamic supportDefaultLeft;
@dynamic supportNaviButton;
@dynamic supportDefaultRight;
@dynamic selfHideNavi;

- (void)setSelfHandleBackNavi:(BOOL)selfHandleBackNavi {
    objc_setAssociatedObject(self, @"UIViewController_selfHandleBackNavi", [NSNumber numberWithBool:selfHandleBackNavi], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)selfHandleBackNavi {
    return [objc_getAssociatedObject(self, @"UIViewController_selfHandleBackNavi") boolValue];
}

- (void)setSelfHideNavi:(BOOL)selfHideNavi {
    objc_setAssociatedObject(self, @"UIViewController_selfHideNavi", [NSNumber numberWithBool:selfHideNavi], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)selfHideNavi {
    return [objc_getAssociatedObject(self, @"UIViewController_selfHideNavi") boolValue];
}

- (void)setSupportDefaultLeft:(BOOL)supportDefaultLeft {
    objc_setAssociatedObject(self, @"UIViewController_supportDefaultLeft", [NSNumber numberWithBool:supportDefaultLeft], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)supportDefaultLeft {
    return [objc_getAssociatedObject(self, @"UIViewController_supportDefaultLeft") boolValue];
}

- (void)setSupportDefaultRight:(BOOL)supportDefaultRight {
    objc_setAssociatedObject(self, @"UIViewController_supportDefaultRight", [NSNumber numberWithBool:supportDefaultRight], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)supportDefaultRight {
    return [objc_getAssociatedObject(self, @"UIViewController_supportDefaultRight") boolValue];
}

- (void)setSupportNaviButton:(BOOL)supportNaviButton{
    objc_setAssociatedObject(self, @"UIViewController_supportNaviButton", [NSNumber numberWithBool:supportNaviButton], OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)supportNaviButton{
    return [objc_getAssociatedObject(self, @"UIViewController_supportNaviButton") boolValue];
}

- (void)exclusiveTouch:(BOOL)exclusiveTouch allBtnsInView:(UIView*)v {
    for (id obj in [v subviews]) {
        if ([obj isKindOfClass:[UIButton class]]) {
            ((UIButton*)obj).exclusiveTouch = exclusiveTouch;
        } else if ([obj isKindOfClass:[UIView class]]) {
            [self exclusiveTouch:exclusiveTouch allBtnsInView:obj];
        }
    }
}

- (void)backNaviBtnTouched {
    
}
// Don't allow touch multi-button one time
- (void)exclusiveTouchAllBtns:(BOOL)exclusiveTouch {
    [self exclusiveTouch:exclusiveTouch allBtnsInView:self.view];
}
@end
