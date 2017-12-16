//
//  KeyboardAuxilaryController.h
//  SoundBoard
//
//  Created by Gregory Klein on 1/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KeyboardKeysController;
#import "KeyboardMapUpdaterProtocol.h"

@interface KeyboardAuxiliaryController : UIViewController

+ (instancetype)controller;

@property (nonatomic, weak) NSObject<KeyboardKeyFrameTextMapUpdater>* keyboardMapUpdater;

@end
