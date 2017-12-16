//
//  KeyViewCollectionCreator.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/24/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardTypedefs.h"

@class KeyViewCollection;
@interface KeyViewCollectionCreator : NSObject

+ (KeyViewCollection*)collectionForMode:(KeyboardMode)mode row:(KeyboardRow)row;

@end
