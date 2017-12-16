//
//  KeyboardTouchEventHandler.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/26/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardMapUpdaterProtocol.h"
#import "KeyboardTypedefs.h"

@interface KeyboardTouchEventHandler : UIViewController <KeyboardKeyFrameTextMapUpdater>

+ (instancetype)handler;

@property (nonatomic, copy) dispatch_block_t advanceToNextKeyboardBlock;
@property (nonatomic, copy) void (^modeSwitchingBlock)(KeyboardMode mode);

@end
