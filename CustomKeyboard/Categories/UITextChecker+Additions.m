//
//  UITextChecker+Additions.m
//  SoundBoard
//
//  Created by Gregory Klein on 3/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "UITextChecker+Additions.h"

static NSString* _deviceLanguage()
{
   return [[NSLocale preferredLanguages] objectAtIndex:0];
}

static NSRange _range(NSString* word)
{
   return NSMakeRange(0, word.length);
}

@implementation UITextChecker (Additions)

- (NSArray*)guessesForWord:(NSString *)word
{
   return [self guessesForWordRange:_range(word) inString:word language:_deviceLanguage()];
}

- (NSArray*)completionsForWord:(NSString*)word
{
   return [self completionsForPartialWordRange:_range(word) inString:word language:_deviceLanguage()];
}

@end
