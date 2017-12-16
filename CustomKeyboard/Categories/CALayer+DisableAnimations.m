//
//  CALayer+DisableAnimations.m
//  SoundBoard
//
//  Created by Klein, Greg on 2/1/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "CALayer+DisableAnimations.h"

@implementation CALayer (DisableAnimations)

- (void)disableAnimations
{
   self.actions = @{@"hidden" : [NSNull null],
                    @"frame" : [NSNull null],
                    @"position" : [NSNull null],
                    @"bounds" : [NSNull null],
                    @"contents" : [NSNull null],
                    @"backgroundColor" : [NSNull null]};
}

@end
