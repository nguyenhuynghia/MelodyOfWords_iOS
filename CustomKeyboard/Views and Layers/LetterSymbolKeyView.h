//
//  LetterSymbolKeyView.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/31/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyView.h"
#import "KeyboardTypedefs.h"

@interface LetterSymbolKeyView : KeyView

- (void)updateForShiftMode:(KeyboardShiftMode)shiftMode;
- (void)initializeAlternateKeysView;

@end
