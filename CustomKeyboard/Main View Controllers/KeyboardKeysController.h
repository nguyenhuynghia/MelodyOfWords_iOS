//
//  KeyboardKeysController.h
//  SoundBoard
//
//  Created by Gregory Klein on 1/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardTypedefs.h"
#import "KeyboardMapUpdaterProtocol.h"

@interface KeyboardKeysController : UIViewController

+ (instancetype)controllerWithMode:(KeyboardMode)mode;
- (void)updateMode:(KeyboardMode)mode;
- (void)updateShiftMode:(KeyboardShiftMode)shiftMode;

@property (nonatomic, readonly) KeyboardMode mode;
@property (nonatomic, weak) NSObject<KeyboardKeyFrameTextMapUpdater>* keyboardMapUpdater;

@end
