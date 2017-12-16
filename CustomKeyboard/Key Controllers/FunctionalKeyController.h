//
//  FunctionalKeyController.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardTypedefs.h"

@class KeyView;
@interface FunctionalKeyController : UIViewController

+ (instancetype)controller;

// Override!
- (void)setupKeyViews;
- (KeyView*)keyViewForMode:(KeyboardMode)mode;

- (void)updateFrame:(CGRect)frame;
- (void)updateMode:(KeyboardMode)mode;

@property (nonatomic) NSArray* keyViewArray;

@end
