//
//  UIImage+scale.m
//  App
//
//  Created by Nguyen Duong The Anh on 4/3/17.
//  Copyright © 2017 HBLab. All rights reserved.
//

#import "UIImage+scale.h"
#import <math.h>

@implementation UIImage (scale)

- (UIImage *)scale:(NSInteger)maxWidth maxHeight:(NSInteger)maxHeight {
    CGSize size = self.size;
    CGFloat ratio = MAX(size.width / maxWidth, size.height / maxHeight);
    CGSize newSize = CGSizeMake(size.width / ratio, size.height / ratio);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
