//
//  LetterView.m
//  SoundBoard
//
//  Created by Gregory Klein on 1/21/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyView.h"
#import "KeyBackgroundLayer.h"
#import "KeyboardKeyLayer.h"
#import "ThemeAttributesProvider.h"

@interface KeyView ()
@property (nonatomic) BOOL hasFocus;
@property (nonatomic) KeyboardKeyType type;
@property (nonatomic) KeyboardKeyLayer* keyLayer;
@property (nonatomic) KeyBackgroundLayer* backgroundLayer;
@property (nonatomic, copy) keyActionBlock actionBlock;
@end

@implementation KeyView

#pragma mark - Init
- (instancetype)initWithText:(NSString*)text fontSize:(CGFloat)fontSize frame:(CGRect)frame
{
   if (self = [self initWithFrame:CGRectZero])
   {
      self.displayText = text;
      [self setupBackgroundLayerWithKeyType:KeyTypeDefault];
      [self setupLetterLayerWithText:text keyType:KeyTypeDefault];
   }
   return self;
}

- (instancetype)initWithText:(NSString *)text keyType:(KeyboardKeyType)type
{
   if (self = [super init])
   {
      self.type = type;
      self.displayText = text;
      [self setupBackgroundLayerWithKeyType:type];
      [self setupLetterLayerWithText:text keyType:type];
   }
   return self;
}

#pragma mark - Class Init
+ (instancetype)viewWithText:(NSString *)text fontSize:(CGFloat)fontSize frame:(CGRect)frame
{
   return [[[self class] alloc] initWithText:text fontSize:fontSize frame:frame];
}

+ (instancetype)viewWithText:(NSString*)text keyType:(KeyboardKeyType)type
{
   return [[[self class] alloc] initWithText:text keyType:type];
}

#pragma mark - Setup
- (void)setupLetterLayerWithText:(NSString*)text keyType:(KeyboardKeyType)type
{
   self.keyLayer = [KeyboardKeyLayer layerWithText:text keyType:type];
   self.keyLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

   [self.layer addSublayer:self.keyLayer];
}

- (void)setupBackgroundLayerWithKeyType:(KeyboardKeyType)type
{
   self.backgroundLayer = [KeyBackgroundLayer layerWithKeyType:type];
   [self.layer addSublayer:self.backgroundLayer];
}

#pragma mark - Update
- (void)updateKeyLayers
{
   UIEdgeInsets edgeInsets = [ThemeAttributesProvider backgroundEdgeInsetsForKeyType:self.type];
   self.backgroundLayer.frame = CGRectInset(self.bounds, edgeInsets.left, edgeInsets.top);
   self.keyLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

#pragma mark - Public
- (void)updateFrame:(CGRect)frame
{
   self.frame = frame;
   [self updateKeyLayers];
}

- (void)setActionBlock:(keyActionBlock)block
{
   _actionBlock = block;
}

- (void)executeActionBlock:(NSInteger)repeatCount
{
   if (self.actionBlock != nil)
   {
      self.actionBlock(repeatCount);
   }
}

- (void)handleTouchEvent:(UITouch*)touch
{
}

- (void)giveFocus
{
   self.hasFocus = YES;
   [self.backgroundLayer applyHighlight];
   [self.keyLayer applyHighlight];
}

- (void)removeFocus
{
   self.hasFocus = NO;
   [self.backgroundLayer removeHighlight];
   [self.keyLayer removeHighlight];
}

- (void)updateDisplayText:(NSString*)text
{
   if (![self.displayText isEqualToString:text])
   {
      self.displayText = text;
      [self.keyLayer updateText:text];
   }
}

#pragma mark - Property Overrides
- (BOOL)wantsToHandleTouchEvents
{
   return NO;
}

@end
