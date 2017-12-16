//
//  SpellCorrectorBridge.m
//  SoundBoard
//
//  Created by Gregory Klein on 3/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "SpellCorrectorBridge.h"
#include "SpellCorrector.h"
#import "SpellCorrectionResult.h"
#include <string>

@interface SpellCorrectorBridge ()
{
   SpellCorrector _corrector;
}

@property (nonatomic) BOOL isLoaded;
@end

@implementation SpellCorrectorBridge

#pragma mark - Private Class Methods
+ (SpellCorrectorBridge*)spellCorrector
{
   static SpellCorrectorBridge* spellCorrector = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      spellCorrector = [SpellCorrectorBridge new];
   });
   return spellCorrector;
}

#pragma mark - Public Class Methods
+ (void)loadForSpellCorrection
{
   SpellCorrectorBridge* spellCorrector = [self spellCorrector];
   if (spellCorrector.isLoaded == NO)
   {
      [spellCorrector loadFileForCorrections];
      spellCorrector.isLoaded = YES;
   }
}

+ (NSArray*)correctionsForText:(NSString *)text
{
   SpellCorrectorBridge* spellCorrector = [self spellCorrector];
   NSArray* results = nil;
   if (spellCorrector.isLoaded)
   {
      results = [spellCorrector corrections:text];
   }
   return results;
}

#pragma mark - Private
- (void)loadFileForCorrections
{
   NSString* filePath = [[NSBundle mainBundle] pathForResource:@"big" ofType:@"txt"];
   _corrector.load(filePath.fileSystemRepresentation);
}

- (NSArray*)corrections:(NSString*)text
{
   Dictionary candidates = _corrector.corrections(text.lowercaseString.UTF8String);

   NSMutableArray* results = [NSMutableArray array];
   for (Dictionary::iterator it = candidates.begin(); it != candidates.end(); ++it)
   {
      NSString* word = [NSString stringWithUTF8String:it->first.c_str()];
      SpellCorrectionResult* result = [SpellCorrectionResult resultWithWord:word likelihood:it->second];

      [results addObject:result];
   }

   return [results sortedArrayUsingComparator:^NSComparisonResult(SpellCorrectionResult* obj1, SpellCorrectionResult* obj2) {

      if (obj1.likelihood == obj2.likelihood)
      {
         return NSOrderedSame;
      }
      return (obj1.likelihood > obj2.likelihood) ? NSOrderedAscending : NSOrderedDescending;
   }];
}

@end
