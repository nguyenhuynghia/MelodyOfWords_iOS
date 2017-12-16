//
//  KeyboardModeManager.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/31/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardTypedefs.h"

@protocol KeyboardModeUpdater <NSObject>
@required
- (void)updateKeyboardMode:(KeyboardMode)mode;
- (void)updateKeyboardShiftMode:(KeyboardShiftMode)shiftMode;
- (void)advanceToNextKeyboard;
@end

@interface KeyboardModeManager : NSObject

+ (void)setKeyboardModeUpdater:(NSObject<KeyboardModeUpdater>*)updater;

+ (void)updateKeyboardMode:(KeyboardMode)mode;
+ (KeyboardMode)currentMode;

+ (void)updateKeyboardShiftMode:(KeyboardShiftMode)shiftMode;
+ (KeyboardShiftMode)currentShiftMode;

+ (void)advanceToNextKeyboard;

@end
