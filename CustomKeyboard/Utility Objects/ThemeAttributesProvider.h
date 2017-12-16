//
//  ThemeAttributesProvider.h
//  SoundBoard
//
//  Created by Klein, Greg on 2/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardTypedefs.h"

@interface ThemeAttributesProvider : NSObject

+ (NSDictionary*)attributesForKeyType:(KeyboardKeyType)type;

+ (NSString*)fontNameForKeyType:(KeyboardKeyType)type;
+ (CGFloat)fontSizeForKeyType:(KeyboardKeyType)type;
+ (UIColor*)fontColorForKeyType:(KeyboardKeyType)type;
+ (UIColor*)highlightedFontColorForKeyType:(KeyboardKeyType)type;
+ (UIColor*)backgroundColorForKeyType:(KeyboardKeyType)type;
+ (UIColor*)highlightedBackgroundColorForKeyType:(KeyboardKeyType)type;
+ (CGFloat)cornerRadiusForKeyType:(KeyboardKeyType)type;
+ (UIColor*)shadowColorForKeyType:(KeyboardKeyType)type;
+ (CGSize)shadowOffsetForKeyType:(KeyboardKeyType)type;
+ (CGFloat)shadowOpacityForKeyType:(KeyboardKeyType)type;
+ (CGFloat)shadowRadiusForKeyType:(KeyboardKeyType)type;
+ (UIEdgeInsets)backgroundEdgeInsetsForKeyType:(KeyboardKeyType)type;
+ (UIColor*)borderColorForKeyType:(KeyboardKeyType)type;
+ (CGFloat)borderWidthForKeyType:(KeyboardKeyType)type;

@end

extern NSString* const kThemeAttributesFontName;
extern NSString* const kThemeAttributesFontSize;
extern NSString* const kThemeAttributesFontColor;
extern NSString* const kThemeAttributesHighlightedFontColor;
extern NSString* const kThemeAttributesBackgroundColor;
extern NSString* const kThemeAttributesHighlightedBackgroundColor;
extern NSString* const kThemeAttributesBackgroundEdgeInsets;
extern NSString* const kThemeAttributesCornerRadius;
extern NSString* const kThemeAttributesShadowColor;
extern NSString* const kThemeAttributesShadowOffset;
extern NSString* const kThemeAttributesShadowOpacity;
extern NSString* const kThemeAttributesShadowRadius;
extern NSString* const kThemeAttributesBorderColor;
extern NSString* const kThemeAttributesBorderWidth;

