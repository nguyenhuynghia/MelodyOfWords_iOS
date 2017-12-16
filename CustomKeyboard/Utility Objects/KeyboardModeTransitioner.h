//
//  KeyboardModeTransitioner.h
//  SoundBoard
//
//  Created by Gregory Klein on 2/8/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardTypedefs.h"

@interface KeyboardModeTransitioner : NSObject

+ (void)giveTextInput:(NSString*)input;
+ (void)giveSpacebarInput;

+ (void)disableRequestsWhileInMode:(KeyboardMode)mode;
+ (void)setCharacterArray:(NSArray*)array forImmediateTransitionToMode:(KeyboardMode)mode;

+ (void)requestTransitionToMode:(KeyboardMode)mode afterNextInput:(NSString*)input;
+ (void)requestTransitionToModeAfterNextSpacebarInput:(KeyboardMode)mode;
+ (void)resetPreviousRequest;

@end
