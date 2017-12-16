//
//  SpellCorrectionResult.m
//  SoundBoard
//
//  Created by Gregory Klein on 3/15/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "SpellCorrectionResult.h"

@implementation SpellCorrectionResult

#pragma mark - Class Init
+ (instancetype)resultWithWord:(NSString *)word likelihood:(NSUInteger)likelihood
{
   SpellCorrectionResult* result = [SpellCorrectionResult new];
   result.word = word;
   result.likelihood = likelihood;
   return result;
}

@end
