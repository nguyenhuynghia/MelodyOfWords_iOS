//
//  LetterView.h
//  SoundBoard
//
//  Created by Gregory Klein on 1/21/15.
//  Copyright (c) 2015 gPure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardTypedefs.h"

typedef void (^keyActionBlock)(NSInteger repeatCount);

@class KeyboardKeyLayer;
@interface KeyView : UIView

- (instancetype)initWithText:(NSString *)text keyType:(KeyboardKeyType)type;
+ (instancetype)viewWithText:(NSString*)text keyType:(KeyboardKeyType)type;

- (void)updateFrame:(CGRect)frame;
- (void)setActionBlock:(keyActionBlock)block;
- (void)executeActionBlock:(NSInteger)repeatCount;
- (void)handleTouchEvent:(UITouch*)touch;

- (void)giveFocus;
- (void)removeFocus;

- (void)updateDisplayText:(NSString*)text;

@property (readonly) BOOL hasFocus;
@property (nonatomic, copy) NSString* displayText;
@property (nonatomic) BOOL shouldTriggerActionOnTouchDown;
@property (nonatomic) BOOL shouldShowEnlargedKeyOnTouchDown;
@property (readonly) BOOL wantsToHandleTouchEvents;

@property (nonatomic, readonly) KeyboardKeyLayer* keyLayer;

@end
