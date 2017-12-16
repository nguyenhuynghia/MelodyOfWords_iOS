//
//  LetterKeysController.m
//  SoundBoard
//
//  Created by Klein, Greg on 2/5/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "LetterKeysController.h"
#import "KeyViewCollection.h"
#import "KeyViewCollectionCreator.h"
#import "LetterSymbolKeyView.h"

static KeyViewCollection* _collection(KeyboardMode mode, KeyboardRow row)
{
   return [KeyViewCollectionCreator collectionForMode:mode row:row];
}

@class KeyView;
@interface LetterKeysController ()
@property (nonatomic) KeyViewCollection* topLettersCollection;
@property (nonatomic) KeyViewCollection* middleLettersCollection;
@property (nonatomic) KeyViewCollection* bottomLettersCollection;
@end

@implementation LetterKeysController

#pragma mark - Init
- (instancetype)initWithDimensionsProvider:(KeyboardLayoutDimensonsProvider*)provider
{
   if (self = [super initWithDimensionsProvider:provider])
   {
      [self setupKeyViewCollections];
   }
   return self;
}

#pragma mark - Setup
- (void)setupKeyViewCollections
{
   self.topLettersCollection = _collection(KeyboardModeLetters, KeyboardRowTop);
   self.middleLettersCollection = _collection(KeyboardModeLetters, KeyboardRowMiddle);
   self.bottomLettersCollection = _collection(KeyboardModeLetters, KeyboardRowBottom);
   
   for (KeyViewCollection* collection in self.keyViewCollections)
   {
      [self.view addSubview:collection];
   }
}

#pragma mark - Helper
- (void)updateKeyCollectionForRow:(KeyboardRow)row withFrame:(CGRect)frame
{
   KeyViewCollection* collection = nil;
   switch (row)
   {
      case KeyboardRowTop:
         collection = self.topLettersCollection;
         break;
      case KeyboardRowMiddle:
         collection = self.middleLettersCollection;
         break;
      case KeyboardRowBottom:
         collection = self.bottomLettersCollection;
         break;
      default:
         break;
   }
   [collection updateFrame:frame];
}

#pragma mark - Public
- (void)updateKeyViewFrames
{
   KeyboardRow rows[] = {KeyboardRowTop, KeyboardRowMiddle, KeyboardRowBottom};
   for (int rowIndex = 0; rowIndex < 3; ++rowIndex)
   {
      KeyboardRow currentRow = rows[rowIndex];
      CGRect frame = [self.dimensionsProvider frameForKeyboardMode:KeyboardModeLetters row:currentRow];
      [self updateKeyCollectionForRow:currentRow withFrame:frame];
   }
}

- (void)updateFrame:(CGRect)frame
{
   [super updateFrame:frame];
   [self updateKeyViewFrames];
}

- (void)updateShiftMode:(KeyboardShiftMode)shiftMode
{
   for (LetterSymbolKeyView* keyView in self.keyViews)
   {
      [keyView updateForShiftMode:shiftMode];
   }
}

- (void)initializeAlternateKeyViews
{
   for (LetterSymbolKeyView* keyView in self.keyViews)
   {
      [keyView initializeAlternateKeysView];
   }
}

#pragma mark - Property Overrides
- (NSArray*)keyViewCollections
{
   return @[self.topLettersCollection, self.middleLettersCollection, self.bottomLettersCollection];
}

@end
