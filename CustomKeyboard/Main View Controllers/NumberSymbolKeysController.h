//
//  NumberSymbolKeysController.h
//  SoundBoard
//
//  Created by Klein, Greg on 2/6/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeysController.h"

@class KeyViewCollection;
@interface NumberSymbolKeysController : KeysController

@property (readonly) NSArray* numberKeysCollectionArray;
@property (readonly) NSArray* symbolKeysCollectionArray;
@property (readonly) KeyViewCollection* punctuationKeysCollection;

- (void)updateMode:(KeyboardMode)mode;

@end
