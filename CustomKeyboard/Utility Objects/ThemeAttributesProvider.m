//
//  ThemeAttributesProvider.m
//  SoundBoard
//
//  Created by Klein, Greg on 2/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "ThemeAttributesProvider.h"

NSString* const kThemeAttributesFontName = @"kThemeAttributesFontName";
NSString* const kThemeAttributesFontSize = @"kThemeAttributesFontSize";
NSString* const kThemeAttributesFontColor = @"kThemeAttributesFontColor";
NSString* const kThemeAttributesHighlightedFontColor = @"kThemeAttributesHighlightedFontColor";
NSString* const kThemeAttributesBackgroundColor = @"kThemeAttributesBackgroundColor";
NSString* const kThemeAttributesBackgroundEdgeInsets = @"kThemeAttributesbackgroundEdgeInsets";
NSString* const kThemeAttributesHighlightedBackgroundColor = @"kThemeAttributesHighlightedBackgroundColor";
NSString* const kThemeAttributesCornerRadius = @"kThemeAttributesCornerRadius";
NSString* const kThemeAttributesShadowColor = @"kThemeAttributesShadowColor";
NSString* const kThemeAttributesShadowOffset = @"kThemeAttributesShadowOffset";
NSString* const kThemeAttributesShadowOpacity = @"kThemeAttributesShadowOpacity";
NSString* const kThemeAttributesShadowRadius = @"kThemeAttributesShadowRadius";
NSString* const kThemeAttributesBorderColor = @"kThemeAttributesBorderColor";
NSString* const kThemeAttributesBorderWidth = @"kThemeAttributesBorderWidth";

CGFloat _floatValueFromDictionary(NSDictionary* dictionary, NSString* key)
{
   NSNumber* value = [dictionary objectForKey:key];
   return value.floatValue;
}

CGSize _sizeValueFromDictionary(NSDictionary* dictionary, NSString* key)
{
   NSValue* value = [dictionary objectForKey:key];
   return value.CGSizeValue;
}

UIEdgeInsets _edgeInsetsValueFromDictionary(NSDictionary* dictionary, NSString* key)
{
   NSValue* value = [dictionary objectForKey:key];
   return value.UIEdgeInsetsValue;
}

NSString* _stringValueFromDictionary(NSDictionary* dictionary, NSString* key)
{
   NSString* value = [dictionary objectForKey:key];
   return value;
}

UIColor* _colorValueFromDictionary(NSDictionary* dictionary, NSString* key)
{
   UIColor* value = [dictionary objectForKey:key];
   return value;
}

static NSDictionary* _defaultKeyAttributes()
{
   return @{kThemeAttributesFontName : @"HelveticaNeue",
            kThemeAttributesFontSize : @20,
            kThemeAttributesFontColor : [UIColor whiteColor],
            kThemeAttributesHighlightedFontColor : [UIColor whiteColor],
            kThemeAttributesBackgroundColor : [UIColor colorWithRed:31/255.f green:32/255.f blue:34/255.f alpha:1],
            kThemeAttributesHighlightedBackgroundColor : [UIColor colorWithRed:31/255.f green:32/255.f blue:34/255.f alpha:1],
            kThemeAttributesBackgroundEdgeInsets : [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(2, 1.5, 1, 1)],
            kThemeAttributesCornerRadius : @2.f,
            kThemeAttributesShadowColor : [UIColor blackColor],
            kThemeAttributesShadowOpacity : @.25f,
            kThemeAttributesShadowRadius : @1.5f,
            kThemeAttributesShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, .5f)],
            kThemeAttributesBorderColor : [UIColor clearColor],
            kThemeAttributesBorderWidth : @0
            };
}

static NSDictionary* _functionalKeyAttributes()
{
   return @{kThemeAttributesFontName : @"HelveticaNeue",
            kThemeAttributesFontSize : @14,
            kThemeAttributesFontColor : [UIColor whiteColor],
            kThemeAttributesHighlightedFontColor : [UIColor whiteColor],
            kThemeAttributesBackgroundColor : [UIColor colorWithRed:31/255.f green:32/255.f blue:34/255.f alpha:.4],
            kThemeAttributesHighlightedBackgroundColor : [UIColor colorWithRed:31/255.f green:32/255.f blue:34/255.f alpha:.9],
            kThemeAttributesBackgroundEdgeInsets : [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(2, 1.5, 1, 1)],
            kThemeAttributesCornerRadius : @6.f,
            kThemeAttributesShadowColor : [UIColor blackColor],
            kThemeAttributesShadowOpacity : @.25f,
            kThemeAttributesShadowRadius : @1.5f,
            kThemeAttributesShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, .5f)],
            kThemeAttributesBorderColor : [UIColor clearColor],
            kThemeAttributesBorderWidth : @0
            };
}

static NSDictionary* _enlargedKeyAttributes()
{
   return @{kThemeAttributesFontName : @"HelveticaNeue",
            kThemeAttributesFontSize : @24,
            kThemeAttributesFontColor : [UIColor colorWithRed:31/255.f green:32/255.f blue:34/255.f alpha:1],
            kThemeAttributesHighlightedFontColor : [UIColor colorWithRed:31/255.f green:32/255.f blue:34/255.f alpha:1],
            kThemeAttributesBackgroundColor : [UIColor colorWithWhite:1 alpha:.9],
            kThemeAttributesBackgroundEdgeInsets : [NSValue valueWithUIEdgeInsets:UIEdgeInsetsZero],
            kThemeAttributesHighlightedBackgroundColor : [UIColor colorWithWhite:1 alpha:.9],
            kThemeAttributesCornerRadius : @0,
            kThemeAttributesShadowColor : [UIColor blackColor],
            kThemeAttributesShadowOpacity : @.25f,
            kThemeAttributesShadowRadius : @1.5f,
            kThemeAttributesShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, .5f)],
            kThemeAttributesBorderColor : [UIColor colorWithWhite:.2 alpha:1],
            kThemeAttributesBorderWidth : @2
            };
}

static NSDictionary* _alternateKeyAttributes()
{
   return @{kThemeAttributesFontName : @"HelveticaNeue",
            kThemeAttributesFontSize : @20,
            kThemeAttributesFontColor : [UIColor colorWithRed:31/255.f green:32/255.f blue:34/255.f alpha:1],
            kThemeAttributesHighlightedFontColor : [UIColor whiteColor],
            kThemeAttributesBackgroundColor : [UIColor clearColor],
            kThemeAttributesBackgroundEdgeInsets : [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(8, 4, 4, 4)],
            kThemeAttributesHighlightedBackgroundColor : [UIColor colorWithRed:31/255.f green:32/255.f blue:34/255.f alpha:1],
            kThemeAttributesCornerRadius : @6.f,
            kThemeAttributesShadowColor : [UIColor clearColor],
            kThemeAttributesShadowOpacity : @0,
            kThemeAttributesShadowRadius : @0,
            kThemeAttributesShadowOffset : [NSValue valueWithCGSize:CGSizeZero],
            kThemeAttributesBorderColor : [UIColor clearColor],
            kThemeAttributesBorderWidth : @0
            };
}

@implementation ThemeAttributesProvider

#pragma mark - Public Class Methods
+ (NSDictionary*)attributesForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = nil;
   switch (type)
   {
      case KeyTypeDefault:
         attributes = _defaultKeyAttributes();
         break;
         
      case KeyTypeFunctional:
         attributes = _functionalKeyAttributes();
         break;
         
      case KeyTypeEnlarged:
         attributes = _enlargedKeyAttributes();
         break;
         
      case KeyTypeAlternate:
         attributes = _alternateKeyAttributes();
         break;
         
      default:
         break;
   }
   return attributes;
}

+ (NSString*)fontNameForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _stringValueFromDictionary(attributes, kThemeAttributesFontName);
}

+ (CGFloat)fontSizeForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _floatValueFromDictionary(attributes, kThemeAttributesFontSize);
}

+ (UIColor*)fontColorForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _colorValueFromDictionary(attributes, kThemeAttributesFontColor);
}

+ (UIColor*)highlightedFontColorForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _colorValueFromDictionary(attributes, kThemeAttributesHighlightedFontColor);
}

+ (UIColor*)backgroundColorForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _colorValueFromDictionary(attributes, kThemeAttributesBackgroundColor);
}

+ (UIColor*)highlightedBackgroundColorForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _colorValueFromDictionary(attributes, kThemeAttributesHighlightedBackgroundColor);
}

+ (CGFloat)cornerRadiusForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _floatValueFromDictionary(attributes, kThemeAttributesCornerRadius);
}

+ (UIColor*)shadowColorForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _colorValueFromDictionary(attributes, kThemeAttributesShadowColor);
}

+ (CGSize)shadowOffsetForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _sizeValueFromDictionary(attributes, kThemeAttributesShadowOffset);
}

+ (CGFloat)shadowOpacityForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _floatValueFromDictionary(attributes, kThemeAttributesShadowOpacity);
}

+ (CGFloat)shadowRadiusForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _floatValueFromDictionary(attributes, kThemeAttributesShadowRadius);
}

+ (UIEdgeInsets)backgroundEdgeInsetsForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _edgeInsetsValueFromDictionary(attributes, kThemeAttributesBackgroundEdgeInsets);
}

+ (UIColor*)borderColorForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _colorValueFromDictionary(attributes, kThemeAttributesBorderColor);
}

+ (CGFloat)borderWidthForKeyType:(KeyboardKeyType)type
{
   NSDictionary* attributes = [self attributesForKeyType:type];
   return _floatValueFromDictionary(attributes, kThemeAttributesBorderWidth);
}

@end
