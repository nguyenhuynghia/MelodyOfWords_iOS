//
//  AlternateKeysView.m
//  SoundBoard
//
//  Created by Klein, Greg on 2/21/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "AlternateKeysView.h"
#import "KeyboardKeyLayer.h"
#import "CALayer+DisableAnimations.h"
#import "KeyboardKeyLayer.h"
#import "LetterSymbolKeyView.h"
#import "KeyViewCollection.h"
#import "KeyboardKeysUtility.h"
#import "KeyBackgroundLayer.h"
#import "KeyboardKeyFrameTextMap.h"

CGPathRef _centerAlternateKeysBackgroundPath(CGRect bottomFrame, CGRect alternateKeysFrame)
{
   CGFloat minX = CGRectGetMinX(bottomFrame);
   CGFloat minY = CGRectGetMinY(bottomFrame);
   CGFloat maxX = CGRectGetMaxX(bottomFrame);
   CGFloat maxY = CGRectGetMaxY(bottomFrame);
   
   CGMutablePathRef keyPath = CGPathCreateMutable();
   
   CGPathMoveToPoint(keyPath, nil, minX, minY);
   CGPathAddLineToPoint(keyPath, nil, minX - 8, minY - 8);
   CGPathAddLineToPoint(keyPath, nil, CGRectGetMinX(alternateKeysFrame), minY - 8);
   CGPathAddLineToPoint(keyPath, nil, CGRectGetMinX(alternateKeysFrame), CGRectGetMinY(alternateKeysFrame) + 2);
   CGPathAddLineToPoint(keyPath, nil, CGRectGetMaxX(alternateKeysFrame), CGRectGetMinY(alternateKeysFrame) + 2);
   CGPathAddLineToPoint(keyPath, nil, CGRectGetMaxX(alternateKeysFrame), minY - 8);
   
   CGPathAddLineToPoint(keyPath, nil, maxX + 8, minY - 8);
   CGPathAddLineToPoint(keyPath, nil, maxX, minY);
   CGPathAddLineToPoint(keyPath, nil, maxX, maxY);
   CGPathAddLineToPoint(keyPath, nil, minX, maxY);
   CGPathCloseSubpath(keyPath);
   
   return keyPath;
}

CGPathRef _leftAlternateKeysBackgroundPath(CGRect bottomFrame, CGRect alternateKeysFrame)
{
   CGFloat minX = CGRectGetMinX(bottomFrame);
   CGFloat minY = CGRectGetMinY(bottomFrame);
   CGFloat maxX = CGRectGetMaxX(bottomFrame);
   CGFloat maxY = CGRectGetMaxY(bottomFrame);
   
   CGMutablePathRef keyPath = CGPathCreateMutable();
   
   CGPathMoveToPoint(keyPath, nil, minX, minY);
   CGPathAddLineToPoint(keyPath, nil, minX - 8, minY - 8);
   CGPathAddLineToPoint(keyPath, nil, CGRectGetMinX(alternateKeysFrame) - 4, minY - 8);
   CGPathAddLineToPoint(keyPath, nil, CGRectGetMinX(alternateKeysFrame) - 4, CGRectGetMinY(alternateKeysFrame) + 2);
   CGPathAddLineToPoint(keyPath, nil, maxX + 8, CGRectGetMinY(alternateKeysFrame) + 2);
   CGPathAddLineToPoint(keyPath, nil, maxX + 8, minY - 8);
   
   CGPathAddLineToPoint(keyPath, nil, maxX + 8, minY - 8);
   CGPathAddLineToPoint(keyPath, nil, maxX, minY);
   CGPathAddLineToPoint(keyPath, nil, maxX, maxY);
   CGPathAddLineToPoint(keyPath, nil, minX, maxY);
   CGPathCloseSubpath(keyPath);
   
   return keyPath;
}

CGPathRef _rightAlternateKeysBackgroundPath(CGRect bottomFrame, CGRect alternateKeysFrame)
{
   CGFloat minX = CGRectGetMinX(bottomFrame);
   CGFloat minY = CGRectGetMinY(bottomFrame);
   CGFloat maxX = CGRectGetMaxX(bottomFrame);
   CGFloat maxY = CGRectGetMaxY(bottomFrame);
   
   CGMutablePathRef keyPath = CGPathCreateMutable();
   
   CGPathMoveToPoint(keyPath, nil, minX, minY);
   CGPathAddLineToPoint(keyPath, nil, minX - 8, minY - 8);
   CGPathAddLineToPoint(keyPath, nil, minX - 8, minY - 8);
   CGPathAddLineToPoint(keyPath, nil, minX - 8, CGRectGetMinY(alternateKeysFrame) + 2);
   CGPathAddLineToPoint(keyPath, nil, CGRectGetMaxX(alternateKeysFrame) + 4, CGRectGetMinY(alternateKeysFrame) + 2);
   CGPathAddLineToPoint(keyPath, nil, CGRectGetMaxX(alternateKeysFrame) + 4, minY - 8);
   
   CGPathAddLineToPoint(keyPath, nil, maxX + 8, minY - 8);
   CGPathAddLineToPoint(keyPath, nil, maxX, minY);
   CGPathAddLineToPoint(keyPath, nil, maxX, maxY);
   CGPathAddLineToPoint(keyPath, nil, minX, maxY);
   CGPathCloseSubpath(keyPath);
   
   return keyPath;
}

CGPathRef _alternateKeysBackgroundPath(CGRect bottomFrame, CGRect alternateKeysFrame, AltKeysViewDirection direction)
{
   CGPathRef backgroundPath = nil;
   switch (direction)
   {
      case AltKeysViewDirectionCenter:
         backgroundPath = _centerAlternateKeysBackgroundPath(bottomFrame, alternateKeysFrame);
         break;
         
      case AltKeysViewDirectionLeft:
         backgroundPath = _leftAlternateKeysBackgroundPath(bottomFrame, alternateKeysFrame);
         break;
         
      case AltKeysViewDirectionRight:
         backgroundPath = _rightAlternateKeysBackgroundPath(bottomFrame, alternateKeysFrame);
         break;
         
      default:
         break;
   }

   return backgroundPath;
}

@interface AlternateKeysView ()
@property (nonatomic) KeyBackgroundLayer* alternateKeysViewBackgroundLayer;
@property (nonatomic) CALayer* shadowContainerLayer;
@property (nonatomic) NSArray* altCharacters;
@property (nonatomic) KeyViewCollection* alternateKeysCollection;
@property (nonatomic) AltKeysViewDirection direction;
@property (nonatomic) KeyboardKeyFrameTextMap* keyFrameMap;
@property (nonatomic) KeyView* currentSelectedAltKeyView;
@property (nonatomic) KeyView* mainKeyView;
@end

@implementation AlternateKeysView

#pragma mark - Init
- (instancetype)initWithKeyView:(KeyView*)keyView
{
   if (self = [super initWithFrame:keyView.bounds])
   {
      [self setupShadowLayer];
      
      self.alternateKeysViewBackgroundLayer = [KeyBackgroundLayer layerWithKeyType:KeyTypeEnlarged];
      [self.layer addSublayer:self.shadowContainerLayer];
      [self.shadowContainerLayer addSublayer:self.alternateKeysViewBackgroundLayer];
      
      self.direction = [KeyboardKeysUtility directionForCharacter:keyView.displayText];
      [self setupAltCharactersCollectionWithCharacter:keyView.displayText direction:self.direction];

      self.keyFrameMap = [KeyboardKeyFrameTextMap map];
      [self.keyFrameMap addFramesForKeyViewCollection:self.alternateKeysCollection];
   }
   return self;
}

#pragma mark - Class Init
+ (instancetype)viewWithKeyView:(KeyView*)keyView
{
   return [[self alloc] initWithKeyView:keyView];
}

#pragma mark - Setup
- (void)setupShadowLayer
{
   self.shadowContainerLayer = [CALayer layer];
   self.shadowContainerLayer.shadowOpacity = .25f;
   self.shadowContainerLayer.shadowRadius = 1.5f;
   self.shadowContainerLayer.shadowOffset = CGSizeMake(0, .5f);
}

- (void)setupAltCharactersCollectionWithCharacter:(NSString*)character direction:(AltKeysViewDirection)direction
{
   self.altCharacters = [KeyboardKeysUtility altCharactersForCharacter:character direction:direction];
   self.alternateKeysCollection = [KeyViewCollection collectionWithCharacters:self.altCharacters forKeyType:KeyTypeAlternate];
   for (KeyView* keyView in self.alternateKeysCollection.keyViews)
   {
      keyView.shouldShowEnlargedKeyOnTouchDown = NO;
      if ([keyView.displayText isEqualToString:character])
      {
         self.mainKeyView = keyView;
      }
   }
   
   [self addSubview:self.alternateKeysCollection];
}

#pragma mark - Private
- (void)updateAlternateKeysBackgroundPath
{
   CGFloat width = CGRectGetWidth(self.frame) * self.altCharacters.count;
   CGFloat height = CGRectGetHeight(self.frame);
   
   CGFloat x = 0;
   switch (self.direction)
   {
      case AltKeysViewDirectionCenter:
         x = width * -.5 + CGRectGetWidth(self.frame)*.5;
         break;
         
      case AltKeysViewDirectionLeft:
         x = -width + CGRectGetWidth(self.frame);
         break;
         
      default:
         break;
   }
   
   CGRect keyViewFrame = CGRectInset(self.bounds, 4, 4);
   CGRect alternateKeysBackgroundFrame = CGRectMake(x, -56, width, height);
   
   [self.alternateKeysCollection updateFrame:alternateKeysBackgroundFrame];
   [self.keyFrameMap reset];
   [self.keyFrameMap addFramesForKeyViewCollection:self.alternateKeysCollection];
   
   CGPathRef backgroundPath = _alternateKeysBackgroundPath(keyViewFrame, alternateKeysBackgroundFrame, self.direction);
   self.alternateKeysViewBackgroundLayer.path = backgroundPath;
   CGPathRelease(backgroundPath);
}

- (KeyView*)hitTestKeyViewWithTouchEvent:(UITouch*)touch
{
   CGPoint location = [touch locationInView:nil];
   return [self.keyFrameMap keyViewAtPointX:location];
}

- (void)updateCurrentSelectedKeyViewIfNecessary:(KeyView*)keyView
{
   if (self.currentSelectedAltKeyView != keyView && keyView != nil)
   {
      [self.currentSelectedAltKeyView removeFocus];
      self.currentSelectedAltKeyView = keyView;
      [self.currentSelectedAltKeyView giveFocus];
   }
}

#pragma mark - Public
- (void)show
{
   self.currentSelectedAltKeyView = self.mainKeyView;
   [self.currentSelectedAltKeyView giveFocus];
   self.hidden = NO;
}

- (void)hide
{
   self.hidden = YES;
   [self.currentSelectedAltKeyView removeFocus];
   self.currentSelectedAltKeyView = nil;
}

- (void)updateFrame:(CGRect)frame
{
   self.frame = frame;

   [self updateAlternateKeysBackgroundPath];
}

- (void)updateForShiftMode:(KeyboardShiftMode)mode
{
   for (LetterSymbolKeyView* keyView in self.alternateKeysCollection.keyViews)
   {
      [keyView updateForShiftMode:mode];
   }
}

- (void)handleTouchEvent:(UITouch*)touch
{
   KeyView* targetKeyView = [self hitTestKeyViewWithTouchEvent:touch];
   [self updateCurrentSelectedKeyViewIfNecessary:targetKeyView];
}

#pragma mark - Property Overrides
- (NSArray*)alternateKeyViews
{
   return self.alternateKeysCollection.keyViews;
}

- (KeyView*)selectedKeyView
{
   return self.currentSelectedAltKeyView;
}

@end
