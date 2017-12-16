//
//  AlternateKeysView.h
//  SoundBoard
//
//  Created by Klein, Greg on 2/21/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardTypedefs.h"

@class KeyView;
@interface AlternateKeysView : UIView

@property (nonatomic, readonly) NSArray* alternateKeyViews;
@property (nonatomic, readonly) KeyView* selectedKeyView;

+ (instancetype)viewWithKeyView:(KeyView*)keyView;

- (void)show;
- (void)hide;

- (void)updateFrame:(CGRect)frame;
- (void)updateForShiftMode:(KeyboardShiftMode)mode;
- (void)handleTouchEvent:(UITouch*)touch;

@end
