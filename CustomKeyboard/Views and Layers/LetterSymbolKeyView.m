//
//  LetterSymbolKeyView.m
//  SoundBoard
//
//  Created by Klein, Greg on 1/31/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "LetterSymbolKeyView.h"
#import "TextDocumentProxyManager.h"
#import "KeyboardModeTransitioner.h"
#import "KeyboardModeManager.h"
#import "EnlargedKeyView.h"
#import "KeyboardTimer.h"
#import "AlternateKeysView.h"
#import "KeyboardKeysUtility.h"
#import "KeyboardKeyLayer.h"

static NSString* const s_leftEdgeLetterKeys = @"Q1-[_";
static NSString* const s_rightEdgeLetterKeys = @"P0\"=•";

@interface LetterSymbolKeyView ()
@property (nonatomic) EnlargedKeyView* enlargedKeyView;
@property (nonatomic) AlternateKeysView* alternateKeysView;
@property (nonatomic) KeyboardTimer* alternateKeysTimer;
@property (nonatomic) BOOL isShowingAlternateKeys;
@property (nonatomic) NSString* alternateKeyText;
@end

@implementation LetterSymbolKeyView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
{
   if (self = [super initWithFrame:frame])
   {
      self.shouldShowEnlargedKeyOnTouchDown = YES;
   }
   return self;
}

- (void)dealloc
{
   [self.alternateKeysTimer stopTimer];
}

#pragma mark - Class Init
+ (instancetype)viewWithText:(NSString *)text keyType:(KeyboardKeyType)type
{
   LetterSymbolKeyView* letterSymbolView = [super viewWithText:text keyType:type];
   
   [letterSymbolView setupEnlargedKeyView];
   
   __weak LetterSymbolKeyView* weakLetterView = letterSymbolView;
   [letterSymbolView setActionBlock:^(NSInteger repeatCount)
    {
       NSString* text = [weakLetterView stringForShiftMode:[KeyboardModeManager currentShiftMode]];
       [TextDocumentProxyManager insertText:text];
       [KeyboardModeTransitioner giveTextInput:text];
       [KeyboardModeTransitioner requestTransitionToModeAfterNextSpacebarInput:KeyboardModeLetters];

       weakLetterView.alternateKeyText = nil;
    }];
   
   return letterSymbolView;
}

#pragma mark - Setup
- (void)setupEnlargedKeyView
{
   self.enlargedKeyView = [EnlargedKeyView viewWithKeyView:self];
   self.enlargedKeyView.hidden = YES;
   self.enlargedKeyView.keyType = [self enlargedKeyTypeForString:self.displayText];

   [self addSubview:self.enlargedKeyView];
}

- (void)initializeAlternateKeysView
{
   if ([KeyboardKeysUtility altCharactersForCharacter:self.displayText].count)
   {
      self.alternateKeysView = [AlternateKeysView viewWithKeyView:self];
      [self.alternateKeysView hide];
      
      [self addSubview:self.alternateKeysView];
   }
}

#pragma mark - Helper
- (EnlargedKeyType)enlargedKeyTypeForString:(NSString*)string
{
   EnlargedKeyType type = EnlargedKeyTypeDefault;
   if ([s_leftEdgeLetterKeys containsString:string])
   {
      type = EnlargedKeyTypeLeft;
   }
   else if ([s_rightEdgeLetterKeys containsString:string])
   {
      type = EnlargedKeyTypeRight;
   }
   return type;
}

- (void)fireAlterKeyTimerIfNeeded
{
   if (self.alternateKeysTimer == nil && self.alternateKeysView)
   {
      self.alternateKeysTimer = [KeyboardTimer startOneShotTimerWithBlock:^{
         dispatch_async(dispatch_get_main_queue(), ^{

            self.alternateKeyText = nil;
            self.enlargedKeyView.hidden = YES;
            [self.alternateKeysView show];
            self.isShowingAlternateKeys = YES;
         });
      } andDelay:.9f];
   }
}

- (void)killAlternateKeyTimer
{
   if (self.alternateKeysTimer && self.alternateKeysView)
   {
      self.alternateKeyText = self.alternateKeysView.selectedKeyView.displayText;
      [self.alternateKeysView hide];
      self.isShowingAlternateKeys = NO;
      [self.alternateKeysTimer stopTimer];
      self.alternateKeysTimer = nil;
   }
}

#pragma mark - Public
- (void)updateFrame:(CGRect)frame
{
   [super updateFrame:frame];
   
   [self.alternateKeysView updateFrame:self.bounds];
   [self.enlargedKeyView updateFrame:self.bounds];
}

- (void)handleTouchEvent:(UITouch*)touch
{
   [self.alternateKeysView handleTouchEvent:touch];
}

- (void)giveFocus
{
   [super giveFocus];
   if (self.shouldShowEnlargedKeyOnTouchDown)
   {
      self.enlargedKeyView.hidden = NO;
   }
   [self fireAlterKeyTimerIfNeeded];
}

- (void)removeFocus
{
   [super removeFocus];
   if (self.shouldShowEnlargedKeyOnTouchDown)
   {
      self.enlargedKeyView.hidden = YES;
   }
   [self killAlternateKeyTimer];
}

- (void)updateForShiftMode:(KeyboardShiftMode)shiftMode
{
   BOOL capitalized = NO;
   switch (shiftMode)
   {
      case ShiftModeNotApplied:
         break;
         
      case ShiftModeApplied:
      case ShiftModeCapsLock:
         capitalized = YES;
         break;
         
      default:
         break;
   }
   
   if (capitalized)
   {
      [self.keyLayer makeTextUppercase];
      self.displayText = self.displayText.capitalizedString;
   }
   else
   {
      [self.keyLayer makeTextLowercase];
      self.displayText = self.displayText.lowercaseString;
   }
   
   [self.alternateKeysView updateForShiftMode:shiftMode];
   [self.enlargedKeyView updateForShiftMode:shiftMode];
}

- (NSString*)stringForShiftMode:(KeyboardShiftMode)mode
{
   BOOL capitalized = NO;
   switch (mode)
   {
      case ShiftModeNotApplied:
         break;
         
      case ShiftModeApplied:
      case ShiftModeCapsLock:
         capitalized = YES;
         break;
         
      default:
         break;
   }

   NSString* text = self.alternateKeyText ?: self.displayText;
   return capitalized ? text.capitalizedString : text.lowercaseString;
}

#pragma mark - Property Overrides
- (BOOL)wantsToHandleTouchEvents
{
   return self.isShowingAlternateKeys;
}

@end
