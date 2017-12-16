//
//  NSString+Additions.h
//  SoundBoard
//
//  Created by Gregory Klein on 3/17/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

@property (nonatomic, readonly) BOOL isUppercase;
@property (nonatomic, readonly) NSString* titleCase;
@property (nonatomic, readonly) NSString* quotedString;


/*
 Strings that are valid for correcting are in the following format:

 letters-symbols  --  e.g. "abcdefg??"
 symbols-letters  --  e.g. "??abcdefg"

 invalid examples: ??abcdefg??, ??abc?d?efg??, abcd??efg
 */
@property (nonatomic, readonly) BOOL isValidForCorrecting;
@property (nonatomic, readonly) NSString* letterCharacterString;
@property (nonatomic, readonly) NSString* nonLetterCharacterString;

- (NSString*)stringByReplacingLetterCharactersWithString:(NSString*)string;

@end
