//
//  UITextField+Padding.m
//  HocVetApp
//
//  Created by NghiaNH on 4/22/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "UITextField+Padding.h"

@implementation UITextField (Padding)
- (void)setPaddingLeft:(CGFloat)paddingLeft{
    UIImageView *paddingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, paddingLeft, self.bounds.size.height)];
    paddingView.backgroundColor = [UIColor clearColor ];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
- (void)setPaddingRight:(CGFloat)paddingRight {
    UIImageView *paddingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, paddingRight, self.bounds.size.height)];
    paddingView.backgroundColor = [UIColor clearColor ];
    self.rightView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
- (void)setPaddingWithEdgeInsets:(UIEdgeInsets)inset {
    [self setPaddingLeft: inset.left];
    [self setPaddingRight:inset.right];
}
@end
