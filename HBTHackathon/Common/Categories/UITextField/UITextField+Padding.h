//
//  UITextField+Padding.h
//  HocVetApp
//
//  Created by NghiaNH on 4/22/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Padding)
- (void)setPaddingLeft:(CGFloat)paddingLeft;
- (void)setPaddingRight:(CGFloat)paddingRight;
- (void)setPaddingWithEdgeInsets:(UIEdgeInsets)inset;
@end
