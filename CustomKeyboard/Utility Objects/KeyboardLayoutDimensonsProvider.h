//
//  KeyboardLayoutDimensonsProvider.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/25/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardTypedefs.h"
@import UIKit;

@interface KeyboardLayoutDimensonsProvider : NSObject

+ (instancetype)dimensionsProvider;

- (void)updateInputViewFrame:(CGRect)frame;

- (CGRect)frameForKeyboardMode:(KeyboardMode)mode row:(KeyboardRow)row;
- (CGRect)frameForKeyboardKeyType:(KeyboardFunctionalKeyType)type;
- (CGRect)frameForKeyboardKeyRegion:(KeyboardKeyRegion)region;

@end
