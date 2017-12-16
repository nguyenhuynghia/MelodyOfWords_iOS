//
//  KeyboardTimer.h
//  SoundBoard
//
//  Created by Alton, Leif on 02/16/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "FunctionalKeyController.h"


// forward declarations
@class KeyView;

@interface KeyboardTimer : NSObject

+ (KeyboardTimer *)startKeyTimer:(KeyView*)repeatKey;
+ (KeyboardTimer *)startOneShotTimerWithBlock:(dispatch_block_t)block andDelay:(NSInteger)delayInMS;
+ (KeyboardTimer *)startTimerWithBlock:(dispatch_block_t)block andRepeatInterval:(NSInteger)timeInMS;

- (KeyView *)keyView;
- (BOOL)stopTimer;

@end
