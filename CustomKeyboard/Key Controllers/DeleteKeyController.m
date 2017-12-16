//
//  DeleteKeyController.m
//  SoundBoard
//
//  Created by Klein, Greg on 1/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "DeleteKeyController.h"
#import "TextDocumentProxyManager.h"
#import "KeyView.h"
#import "KeyboardKeyLayer.h"
#import "KeyboardModeTransitioner.h"
#import "KeyboardModeManager.h"
#import "KeyboardTimer.h"

// @class DeleteKeyView - this is the only view that the DeleteKeyController has
@interface DeleteKeyView : KeyView
{
   KeyboardTimer * _keyboardTimer;
}

@end

@implementation DeleteKeyView

- (instancetype)initWithText:(NSString *)text keyType:(KeyboardKeyType)type
{
   if (self = [super initWithText:text keyType:type])
   {
      self.shouldTriggerActionOnTouchDown = YES;
      [self setActionBlock:^(NSInteger repeatCount)
       {
          BOOL deletedUppercaseChar = [TextDocumentProxyManager deleteBackward:repeatCount];
          [KeyboardModeManager updateKeyboardShiftMode:(deletedUppercaseChar? ShiftModeApplied :
                                                        ShiftModeNotApplied)];
          [KeyboardModeTransitioner requestTransitionToModeAfterNextSpacebarInput:KeyboardModeLetters];
       }];
   }
   return self;
}

- (void)dealloc
{
   [self killKeyTimer];
}

- (void)fireKeyTimerIfNeeded
{
   if (_keyboardTimer == nil)
      _keyboardTimer = [KeyboardTimer startKeyTimer:self];
}

- (void)killKeyTimer
{
   [_keyboardTimer stopTimer];
   _keyboardTimer = nil;
}

- (void)giveFocus
{
   [super giveFocus];
   [self fireKeyTimerIfNeeded];
}

- (void)removeFocus
{
   [super removeFocus];
   [self killKeyTimer];
}

@end


@interface DeleteKeyController ()
@property (nonatomic) KeyView* deleteView;
@end

@implementation DeleteKeyController

#pragma mark - Setup
- (void)setupKeyViews
{
   self.deleteView = [DeleteKeyView viewWithText:@"del" keyType:KeyTypeFunctional];
   self.keyViewArray = @[self.deleteView];
   
   [self.view addSubview:self.deleteView];
}

#pragma mark - Public
- (KeyView*)keyViewForMode:(KeyboardMode)mode
{
   return self.deleteView;
}

@end
