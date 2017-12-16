//
//  KeysController.h
//  SoundBoard
//
//  Created by Klein, Greg on 2/6/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardLayoutDimensonsProvider.h"

@class KeyboardLayoutDimensonsProvider;
@interface KeysController : UIViewController

+ (instancetype)controllerWithDimensionsProvider:(KeyboardLayoutDimensonsProvider*)provider;
- (instancetype)initWithDimensionsProvider:(KeyboardLayoutDimensonsProvider*)provider;

- (void)updateFrame:(CGRect)frame;
- (void)initializeAlternateKeyViews;

@property (readonly) NSArray* keyViews;
@property (readonly) NSArray* keyViewCollections;
@property (readonly) KeyboardLayoutDimensonsProvider* dimensionsProvider;

@end
