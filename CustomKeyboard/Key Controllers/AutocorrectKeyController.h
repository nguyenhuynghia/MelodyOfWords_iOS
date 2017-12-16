//
//  AutocorrectKeyController.h
//  SoundBoard
//
//  Created by Gregory Klein on 3/7/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyView.h"

@interface AutocorrectKeyController : UIViewController

+ (instancetype)controller;

- (void)updateFrame:(CGRect)frame;
- (void)updateText:(NSString*)text;
- (void)trigger;

@end
