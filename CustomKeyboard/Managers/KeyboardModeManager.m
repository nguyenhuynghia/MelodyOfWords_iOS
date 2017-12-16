//
//  KeyboardModeManager.m
//  SoundBoard
//
//  Created by Klein, Greg on 1/31/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyboardModeManager.h"

@interface KeyboardModeManager ()
@property (weak, nonatomic) NSObject<KeyboardModeUpdater>* updater;
@property (nonatomic) KeyboardMode currentMode;
@property (nonatomic) KeyboardShiftMode currentShiftMode;
@end

@implementation KeyboardModeManager

#pragma mark - Helper
+ (KeyboardModeManager*)sharedManager
{
   static KeyboardModeManager* manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      manager = [KeyboardModeManager new];
   });
   return manager;
}

#pragma mark - Class Methods
+ (void)setKeyboardModeUpdater:(NSObject<KeyboardModeUpdater>*)updater
{
   [[self class] sharedManager].updater = updater;
}

+ (void)updateKeyboardMode:(KeyboardMode)mode
{
   [[self class] sharedManager].currentMode = mode;
   dispatch_async(dispatch_get_main_queue(), ^{
      [[[self class] sharedManager].updater updateKeyboardMode:mode];
   });
}

+ (KeyboardMode)currentMode
{
   return [[self class] sharedManager].currentMode;
}

+ (void)updateKeyboardShiftMode:(KeyboardShiftMode)shiftMode
{
   [[self class] sharedManager].currentShiftMode = shiftMode;
   dispatch_async(dispatch_get_main_queue(), ^{
      [[[self class] sharedManager].updater updateKeyboardShiftMode:shiftMode];
   });
}

+ (KeyboardShiftMode)currentShiftMode
{
   return [[self class] sharedManager].currentShiftMode;
}

+ (void)advanceToNextKeyboard
{
   [[[self class] sharedManager].updater advanceToNextKeyboard];
}

@end
