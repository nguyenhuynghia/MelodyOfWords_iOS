//
//  UITabBarItem+CustomBadge.m
//  Kixyo
//
//  Created by Joseph Gentry on 12/5/15.
//  Copyright © 2015 kixyo. All rights reserved.
//

#import "UITabBarItem+CustomBadge.h"
#import <objc/runtime.h>

@implementation UITabBarItem (CustomBadge)

- (NSString *)customBadgeValue
{
    UILabel *customBadgeLabel = objc_getAssociatedObject(self, @selector(customBadgeValue));
    return customBadgeLabel.text;
}

- (void)setCustomBadgeValue:(NSString *)value
{
    UILabel *customBadgeLabel = objc_getAssociatedObject(self, @selector(customBadgeValue));
    
    if (!value || [value isEqualToString:@""]) {
        customBadgeLabel.hidden = YES;
        return;
    } else {
        customBadgeLabel.hidden = NO;
    }
    
    [self setBadgeValue:value];
    
    UIView *view = [self valueForKey:@"view"];
    UIView *badgeView = [view.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", NSClassFromString(@"_UIBadgeView")]].firstObject;
    badgeView.hidden = YES;
    
    if (!customBadgeLabel) {
        customBadgeLabel = [[UILabel alloc] initWithFrame:badgeView.frame];
        customBadgeLabel.layer.zPosition = MAXFLOAT;
        [badgeView.superview addSubview:customBadgeLabel];
        [badgeView.superview layoutIfNeeded];
        
        objc_setAssociatedObject(self, @selector(customBadgeValue), customBadgeLabel, OBJC_ASSOCIATION_RETAIN);
    }
    
    CGVector offset = self.customBadgeOffset;
    CGFloat diameter = self.customBadgeDiameter;
    customBadgeLabel.frame = CGRectMake(badgeView.frame.origin.x + offset.dx, badgeView.frame.origin.y + offset.dy, diameter, diameter);
    customBadgeLabel.text = value;
    customBadgeLabel.font = self.customBadgeFont;
    customBadgeLabel.backgroundColor = self.customBadgeBackgroundColor;
    customBadgeLabel.textColor = self.customBadgeTextColor;
    customBadgeLabel.textAlignment = NSTextAlignmentCenter;
    customBadgeLabel.layer.cornerRadius = customBadgeLabel.frame.size.height / 2;
    customBadgeLabel.layer.masksToBounds = YES;
}

- (UIFont *)customBadgeFont
{
    UIFont *customBadgeFont = objc_getAssociatedObject(self, @selector(customBadgeFont));
    if (!customBadgeFont) {
        return [UIFont systemFontOfSize:13.0];
    } else {
        return customBadgeFont;
    }
}

- (void)setCustomBadgeFont:(UIFont *)customBadgeFont
{
    objc_setAssociatedObject(self, @selector(customBadgeFont), customBadgeFont, OBJC_ASSOCIATION_RETAIN);
    
    UILabel *customBadgeLabel = objc_getAssociatedObject(self, @selector(customBadgeValue));
    customBadgeLabel.font = customBadgeFont;
}

- (UIColor *)customBadgeTextColor
{
    UIColor *customBadgeTextColor = objc_getAssociatedObject(self, @selector(customBadgeTextColor));
    if (!customBadgeTextColor) {
        return [UIColor whiteColor];
    } else {
        return customBadgeTextColor;
    }
}

- (void)setCustomBadgeTextColor:(UIColor *)customBadgeTextColor
{
    objc_setAssociatedObject(self, @selector(customBadgeTextColor), customBadgeTextColor, OBJC_ASSOCIATION_RETAIN);
    
    UILabel *customBadgeLabel = objc_getAssociatedObject(self, @selector(customBadgeValue));
    customBadgeLabel.textColor = customBadgeTextColor;
}

- (UIColor *)customBadgeBackgroundColor
{
    UIColor *customBadgeBackgroundColor = objc_getAssociatedObject(self, @selector(customBadgeBackgroundColor));
    if (!customBadgeBackgroundColor) {
        return [UIColor redColor];
    } else {
        return customBadgeBackgroundColor;
    }
}

- (void)setCustomBadgeBackgroundColor:(UIColor *)customBadgeBackgroundColor
{
    objc_setAssociatedObject(self, @selector(customBadgeBackgroundColor), customBadgeBackgroundColor, OBJC_ASSOCIATION_RETAIN);
    
    UILabel *customBadgeLabel = objc_getAssociatedObject(self, @selector(customBadgeValue));
    customBadgeLabel.backgroundColor = customBadgeBackgroundColor;
}

- (CGFloat)customBadgeDiameter
{
    NSNumber *diameter = objc_getAssociatedObject(self, @selector(customBadgeDiameter));
    if (!diameter) {
        return 18.0;
    } else {
        return [diameter floatValue];
    }
}

- (void)setCustomBadgeDiameter:(CGFloat)customBadgeDiameter
{
    objc_setAssociatedObject(self, @selector(customBadgeDiameter), @(customBadgeDiameter), OBJC_ASSOCIATION_RETAIN);
    
    UILabel *customBadgeLabel = objc_getAssociatedObject(self, @selector(customBadgeValue));
    customBadgeLabel.frame  = CGRectMake(customBadgeLabel.frame.origin.x, customBadgeLabel.frame.origin.y, customBadgeDiameter, customBadgeDiameter);
    customBadgeLabel.layer.cornerRadius = customBadgeLabel.frame.size.height / 2;
}

- (CGVector)customBadgeOffset
{
    NSValue *offset = objc_getAssociatedObject(self, @selector(customBadgeOffset));
    if (!offset) {
        return CGVectorMake(0, 0);
    } else {
        CGVector offsetVector;
        [offset getValue:&offsetVector];
        return offsetVector;
    }
}

- (void)setCustomBadgeOffset:(CGVector)customBadgeOffset
{
    objc_setAssociatedObject(self, @selector(customBadgeOffset), [NSValue value:&customBadgeOffset withObjCType:@encode(CGVector)], OBJC_ASSOCIATION_RETAIN);
    
    UIView *view = [self valueForKey:@"view"];
    UIView *badgeView = [view.subviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self isKindOfClass: %@", NSClassFromString(@"_UIBadgeView")]].firstObject;
    badgeView.hidden = YES;
    
    UILabel *customBadgeLabel = objc_getAssociatedObject(self, @selector(customBadgeValue));
    customBadgeLabel.frame  = CGRectMake(badgeView.frame.origin.x + customBadgeOffset.dx,
                                         badgeView.frame.origin.y + customBadgeOffset.dy,
                                         customBadgeLabel.frame.size.width,
                                         customBadgeLabel.frame.size.height);
}

@end
