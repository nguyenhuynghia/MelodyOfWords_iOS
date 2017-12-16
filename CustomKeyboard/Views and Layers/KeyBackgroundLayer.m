//
//  KeyLayer.m
//  SoundBoard
//
//  Created by Klein, Greg on 2/24/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyBackgroundLayer.h"
#import "ThemeAttributesProvider.h"
#import "CALayer+DisableAnimations.h"

@interface KeyBackgroundLayer ()
@property (nonatomic) KeyboardKeyType type;
@end

@implementation KeyBackgroundLayer

#pragma mark - Class Init
+ (instancetype)layerWithKeyType:(KeyboardKeyType)type
{
   KeyBackgroundLayer* layer = [self layer];
   layer.type = type;
   
   layer.backgroundColor = [ThemeAttributesProvider backgroundColorForKeyType:type].CGColor;
   layer.strokeColor = [ThemeAttributesProvider borderColorForKeyType:type].CGColor;
   layer.fillColor = [ThemeAttributesProvider backgroundColorForKeyType:type].CGColor;
   layer.cornerRadius = [ThemeAttributesProvider cornerRadiusForKeyType:type];
   layer.shadowOpacity = [ThemeAttributesProvider shadowOpacityForKeyType:type];
   layer.shadowRadius = [ThemeAttributesProvider shadowRadiusForKeyType:type];
   layer.shadowOffset = [ThemeAttributesProvider shadowOffsetForKeyType:type];
   layer.borderWidth = [ThemeAttributesProvider borderWidthForKeyType:type];
   
   [layer disableAnimations];
   
   return layer;
}

#pragma mark - Public
- (void)applyHighlight
{
   self.backgroundColor = [ThemeAttributesProvider highlightedBackgroundColorForKeyType:self.type].CGColor;
}

- (void)removeHighlight
{
   self.backgroundColor = [ThemeAttributesProvider backgroundColorForKeyType:self.type].CGColor;
}

@end
