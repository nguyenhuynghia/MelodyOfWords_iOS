//
//  KeyViewCollectionCreator.m
//  SoundBoard
//
//  Created by Klein, Greg on 1/24/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyViewCollectionCreator.h"
#import "KeyViewCollection.h"
#import "KeyboardKeysUtility.h"

@implementation KeyViewCollectionCreator

+ (KeyViewCollection*)collectionForMode:(KeyboardMode)mode row:(KeyboardRow)row
{
   NSArray* array = [KeyboardKeysUtility charactersForMode:mode row:row];
   return [KeyViewCollection collectionWithCharacters:array];
}

@end
