//
//  KeyboardKeysUtility.h
//  SoundBoard
//
//  Created by Gregory Klein on 1/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardTypedefs.h"

@interface KeyboardKeysUtility : NSObject

+ (NSArray*)charactersForMode:(KeyboardMode)mode row:(KeyboardRow)row;

+ (NSArray*)altCharactersForCharacter:(NSString*)character;
+ (NSArray*)altCharactersForCharacter:(NSString*)character direction:(AltKeysViewDirection)direction;

+ (NSUInteger)numKeysForMode:(KeyboardMode)mode row:(KeyboardRow)row;
+ (AltKeysViewDirection)directionForCharacter:(NSString*)character;

@end
