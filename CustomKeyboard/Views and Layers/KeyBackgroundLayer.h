//
//  KeyLayer.h
//  SoundBoard
//
//  Created by Klein, Greg on 2/24/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KeyboardTypedefs.h"

@interface KeyBackgroundLayer : CAShapeLayer

+ (instancetype)layerWithKeyType:(KeyboardKeyType)type;

- (void)applyHighlight;
- (void)removeHighlight;

@end
