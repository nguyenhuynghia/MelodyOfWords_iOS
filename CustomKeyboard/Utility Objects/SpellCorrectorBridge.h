//
//  SpellCorrectorBridge.h
//  SoundBoard
//
//  Created by Gregory Klein on 3/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpellCorrectorBridge : NSObject

+ (void)loadForSpellCorrection;
+ (NSArray*)correctionsForText:(NSString*)text;

@end
