//
//  KeyboardLetterLayer.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KeyboardTypedefs.h"
@import UIKit;

@interface KeyboardKeyLayer : CATextLayer

+ (instancetype)layerWithText:(NSString*)text keyType:(KeyboardKeyType)type;

- (void)makeTextBold;
- (void)makeTextRegular;
- (void)makeTextUnderlined;
- (void)removeTextUnderline;
- (void)makeTextUppercase;
- (void)makeTextLowercase;

- (void)applyHighlight;
- (void)removeHighlight;

- (void)updateText:(NSString*)text;

@end
