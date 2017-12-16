//
//  UITabBarItem+CustomBadge.h
//  Kixyo
//
//  Created by Joseph Gentry on 12/5/15.
//  Copyright © 2015 kixyo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (CustomBadge)

@property (nonatomic, assign) NSString *customBadgeValue;
@property (nonatomic, assign) UIFont *customBadgeFont;// UI_APPEARANCE_SELECTOR; Doesn't work
@property (nonatomic, assign) UIColor *customBadgeTextColor; // UI_APPEARANCE_SELECTOR; Doesn't work
@property (nonatomic, assign) UIColor *customBadgeBackgroundColor; // UI_APPEARANCE_SELECTOR; Doesn't work
@property (nonatomic, assign) CGFloat customBadgeDiameter; // UI_APPEARANCE_SELECTOR; Doesn't work
@property (nonatomic, assign) CGVector customBadgeOffset; // UI_APPEARANCE_SELECTOR; Doesn't work

@end
