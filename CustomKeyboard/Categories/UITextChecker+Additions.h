//
//  UITextChecker+Additions.h
//  SoundBoard
//
//  Created by Gregory Klein on 3/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextChecker (Additions)

- (NSArray*)guessesForWord:(NSString*)word;
- (NSArray*)completionsForWord:(NSString*)word;

@end
