//
//  ShiftSymbolsKeyController.m
//  SoundBoard
//
//  Created by Klein, Greg on 1/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "ShiftSymbolsKeyController.h"
#import "KeyboardModeManager.h"
#import "KeyboardKeyLayer.h"
#import "KeyView.h"

@interface ShiftKeyView : KeyView
@property (nonatomic) BOOL didTriggerOnKeyDown;
@end

@implementation ShiftKeyView

- (BOOL)shouldTriggerActionOnTouchDown
{
   BOOL triggerOnTouchDown = NO;
   switch ([KeyboardModeManager currentShiftMode])
   {
      case ShiftModeNotApplied:
         triggerOnTouchDown = YES;
         self.didTriggerOnKeyDown = YES;
         break;

      case ShiftModeApplied:
         triggerOnTouchDown = self.didTriggerOnKeyDown;
         self.didTriggerOnKeyDown = NO;
         break;

      case ShiftModeCapsLock:
         triggerOnTouchDown = YES;
         self.didTriggerOnKeyDown = NO;
         break;

      default:
         triggerOnTouchDown = YES;
         break;
   }
   return triggerOnTouchDown;
}

- (void)removeFocus
{
   [super removeFocus];
   self.didTriggerOnKeyDown = NO;
}

@end

@interface ShiftSymbolsKeyController ()
@property (nonatomic) KeyView* shiftKeyView;
@property (nonatomic) KeyView* symbolsKeyView;
@property (nonatomic) KeyView* numbersKeyView;
@end

@implementation ShiftSymbolsKeyController

#pragma mark - Setup
- (void)setupKeyViews
{
   [self setupShiftLetterView];
   [self setupSymbolsLetterView];
   [self setupNumbersLetterView];
   
   self.keyViewArray = @[self.shiftKeyView, self.symbolsKeyView, self.numbersKeyView];
   for (KeyView* letterView in self.keyViewArray)
   {
      [self.view addSubview:letterView];
   }

   self.shiftKeyView.hidden = NO;
}

- (void)setupShiftLetterView
{
   self.shiftKeyView = [ShiftKeyView viewWithText:@"shift" keyType:KeyTypeFunctional];
   self.shiftKeyView.shouldTriggerActionOnTouchDown = YES;
   self.shiftKeyView.hidden = YES;
   
   __weak typeof(self) weakSelf = self;
   [self.shiftKeyView setActionBlock:^(NSInteger repeatCount)
   {
      KeyboardShiftMode currentShiftMode = [KeyboardModeManager currentShiftMode];
      KeyboardShiftMode nextMode = [weakSelf nextShiftModeForCurrentShiftMode:currentShiftMode];
      
      [KeyboardModeManager updateKeyboardShiftMode:nextMode];
      [weakSelf updateKeyLayerForShiftMode:nextMode];
   }];
}

- (void)setupSymbolsLetterView
{
   self.symbolsKeyView = [KeyView viewWithText:@"#+=" keyType:KeyTypeFunctional];
   self.symbolsKeyView.hidden = YES;
   self.symbolsKeyView.shouldTriggerActionOnTouchDown = YES;
   
   [self.symbolsKeyView setActionBlock:^(NSInteger repeatCount)
   {
      [KeyboardModeManager updateKeyboardMode:KeyboardModeSymbols];
   }];
}

- (void)setupNumbersLetterView
{
   self.numbersKeyView = [KeyView viewWithText:@"123" keyType:KeyTypeFunctional];
   self.numbersKeyView.hidden = YES;
   self.numbersKeyView.shouldTriggerActionOnTouchDown = YES;
   
   [self.numbersKeyView setActionBlock:^(NSInteger repeatCount)
   {
      [KeyboardModeManager updateKeyboardMode:KeyboardModeNumbers];
   }];
}

#pragma mark - Helper
- (void)updateShiftMode:(KeyboardShiftMode)shiftMode
{
   [self updateKeyLayerForShiftMode:shiftMode];
}

- (KeyboardShiftMode)nextShiftModeForCurrentShiftMode:(KeyboardShiftMode)mode
{
   KeyboardShiftMode nextMode = ShiftModeNotApplied;
   switch (mode)
   {
      case ShiftModeNotApplied:
         nextMode = ShiftModeApplied;
         break;
         
      case ShiftModeApplied:
         nextMode = ShiftModeNotApplied;
         break;
         
      case ShiftModeCapsLock:
         nextMode = ShiftModeApplied;
         break;
         
      default:
         break;
   }
   return nextMode;
}

- (void)updateKeyLayerForShiftMode:(KeyboardShiftMode)mode
{
   KeyboardKeyLayer* keyLayer = self.shiftKeyView.keyLayer;
   switch (mode)
   {
      case ShiftModeNotApplied:
         [keyLayer makeTextRegular];
         break;
         
      case ShiftModeApplied:
         [keyLayer makeTextBold];
         break;
         
      case ShiftModeCapsLock:
         [keyLayer makeTextUnderlined];
         break;
         
      default:
         break;
   }
}

#pragma mark - Public
- (KeyView*)keyViewForMode:(KeyboardMode)mode
{
   KeyView* keyView;
   switch (mode)
   {
      case KeyboardModeLetters:
         keyView = self.shiftKeyView;
         break;
         
      case KeyboardModeNumbers:
         keyView = self.symbolsKeyView;
         break;
         
      case KeyboardModeSymbols:
         keyView = self.numbersKeyView;
         break;
         
      default:
         break;
   }
   return keyView;
}

- (void)updateMode:(KeyboardMode)mode
{
   switch (mode)
   {
      case KeyboardModeLetters:
         self.shiftKeyView.hidden = NO;
         self.numbersKeyView.hidden = YES;
         self.symbolsKeyView.hidden = YES;
         break;
         
      case KeyboardModeNumbers:
         self.shiftKeyView.hidden = YES;
         self.numbersKeyView.hidden = YES;
         self.symbolsKeyView.hidden = NO;
         break;
         
      case KeyboardModeSymbols:
         self.shiftKeyView.hidden = YES;
         self.numbersKeyView.hidden = NO;
         self.symbolsKeyView.hidden = YES;
         break;
         
      default:
         break;
   }
}

@end
