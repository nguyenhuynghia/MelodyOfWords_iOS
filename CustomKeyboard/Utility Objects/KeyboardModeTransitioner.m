//
//  KeyboardModeTransitioner.m
//  SoundBoard
//
//  Created by Gregory Klein on 2/8/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyboardModeTransitioner.h"
#import "KeyboardModeManager.h"

static KeyboardModeTransitioner* s_transitioner;
static NSString* const s_spacebarInput = @"SPACE";

@interface KeyboardModeTransitioner ()
@property (nonatomic) BOOL readyToTransition;
@property (nonatomic) KeyboardMode nextMode;
@property (nonatomic) KeyboardMode disabledRequestsMode;
@property (nonatomic) NSString* transitionTriggerInput;
@property (nonatomic) NSArray* immediateTransitionCharacters;
@property (nonatomic) KeyboardMode immediateTransitionMode;
@end

@implementation KeyboardModeTransitioner

#pragma mark - Public Class Methods
+ (KeyboardModeTransitioner*)transitioner
{
   if (s_transitioner == nil)
   {
      s_transitioner = [KeyboardModeTransitioner new];
   }
   return s_transitioner;
}

+ (void)giveTextInput:(NSString*)input
{
   KeyboardModeTransitioner* transitioner = [[self class] transitioner];
   [transitioner processInput:input];
}

+ (void)giveSpacebarInput
{
   [[self class] giveTextInput:s_spacebarInput];
}

+ (void)disableRequestsWhileInMode:(KeyboardMode)mode
{
   [[self class] transitioner].disabledRequestsMode = mode;
}

+ (void)setCharacterArray:(NSArray*)array forImmediateTransitionToMode:(KeyboardMode)mode
{
   [[self class] transitioner].immediateTransitionCharacters = array;
   [[self class] transitioner].immediateTransitionMode = mode;
}

+ (void)requestTransitionToMode:(KeyboardMode)mode afterNextInput:(NSString*)input
{
   KeyboardModeTransitioner* transitioner = [[self class] transitioner];
   if ([KeyboardModeManager currentMode] != transitioner.disabledRequestsMode)
   {
      transitioner.readyToTransition = YES;
      transitioner.nextMode = mode;
      transitioner.transitionTriggerInput = input;
   }
}

+ (void)requestTransitionToModeAfterNextSpacebarInput:(KeyboardMode)mode
{
   [[self class] requestTransitionToMode:mode afterNextInput:s_spacebarInput];
}

+ (void)resetPreviousRequest
{
   [[self class] transitioner].readyToTransition = NO;
   [[self class] transitioner].transitionTriggerInput = nil;
}

#pragma mark - Helper
- (void)processInput:(NSString*)input
{
   if ([self.immediateTransitionCharacters containsObject:input])
   {
      [KeyboardModeManager updateKeyboardMode:self.immediateTransitionMode];
   }
   else if (self.readyToTransition && [input isEqualToString:self.transitionTriggerInput])
   {
      [KeyboardModeManager updateKeyboardMode:self.nextMode];
      self.readyToTransition = NO;
   }
}

@end
