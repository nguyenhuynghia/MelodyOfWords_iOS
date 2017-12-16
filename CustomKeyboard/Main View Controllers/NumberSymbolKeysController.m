//
//  NumberSymbolKeysController.m
//  SoundBoard
//
//  Created by Klein, Greg on 2/6/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "NumberSymbolKeysController.h"
#import "KeyViewCollectionCreator.h"
#import "KeyViewCollection.h"
#import "LetterSymbolKeyView.h"

static KeyViewCollection* _collection(KeyboardMode mode, KeyboardRow row)
{
   return [KeyViewCollectionCreator collectionForMode:mode row:row];
}

static void _hideCollectionArray(NSArray* array, BOOL hidden)
{
   for (KeyViewCollection* collection in array)
   {
      collection.hidden = hidden;
   }
}

@interface NumberSymbolKeysController ()
@property (nonatomic) KeyViewCollection* topNumberKeysCollection;
@property (nonatomic) KeyViewCollection* topSymbolKeysCollection;

@property (nonatomic) KeyViewCollection* middleNumberKeysCollection;
@property (nonatomic) KeyViewCollection* middleSymbolKeysCollection;

@property (nonatomic) KeyViewCollection* punctuationKeysCollection;
@end

@implementation NumberSymbolKeysController

#pragma mark - Init
- (instancetype)initWithDimensionsProvider:(KeyboardLayoutDimensonsProvider*)provider
{
   if (self = [super initWithDimensionsProvider:provider])
   {
      [self setupKeyViewCollections];
      [self updateMode:KeyboardModeNumbers];
   }
   return self;
}

#pragma mark - Setup
- (void)setupKeyViewCollections
{
   self.topNumberKeysCollection = _collection(KeyboardModeNumbers, KeyboardRowTop);
   self.middleNumberKeysCollection = _collection(KeyboardModeNumbers, KeyboardRowMiddle);
   self.topSymbolKeysCollection = _collection(KeyboardModeSymbols, KeyboardRowTop);
   self.middleSymbolKeysCollection  = _collection(KeyboardModeSymbols, KeyboardRowMiddle);
   self.punctuationKeysCollection = _collection(KeyboardModeSymbols, KeyboardRowBottom);
   
   for (KeyViewCollection* collection in self.keyViewCollections)
   {
      [self.view addSubview:collection];
   }
}

#pragma mark - Update
- (void)updateKeyViewFrames
{
   [self updateNumberKeyCollectionFrames];
   [self updateSymbolKeyCollectionFrames];
}

- (void)updateNumberKeyCollectionFrames
{
   KeyboardRow rows[] = {KeyboardRowTop, KeyboardRowMiddle};
   NSUInteger rowIndex = 0;
   for (KeyViewCollection* numberCollection in self.numberKeysCollectionArray)
   {
      CGRect frame = [self.dimensionsProvider frameForKeyboardMode:KeyboardModeNumbers row:rows[rowIndex++]];
      [numberCollection updateFrame:frame];
   }
}

- (void)updateSymbolKeyCollectionFrames
{
   KeyboardRow rows[] = {KeyboardRowTop, KeyboardRowMiddle};
   NSUInteger rowIndex = 0;
   for (KeyViewCollection* symbolCollection in self.symbolKeysCollectionArray)
   {
      CGRect frame = [self.dimensionsProvider frameForKeyboardMode:KeyboardModeSymbols row:rows[rowIndex++]];
      [symbolCollection updateFrame:frame];
   }
}

- (void)updatePunctuationKeyCollectionFrame
{
   CGRect puncutationFrame = [self.dimensionsProvider frameForKeyboardMode:KeyboardModeNumbers row:KeyboardRowBottom];
   [self.punctuationKeysCollection updateFrame:puncutationFrame];
}

#pragma mark - Public
- (void)updateFrame:(CGRect)frame
{
   [super updateFrame:frame];
   [self updateNumberKeyCollectionFrames];
   [self updateSymbolKeyCollectionFrames];
   [self updatePunctuationKeyCollectionFrame];
}

- (void)updateMode:(KeyboardMode)mode
{
   NSArray* collectionToShow = nil;
   NSArray* collectionToHide = nil;
   switch (mode)
   {
      case KeyboardModeLetters:
         break;

      case KeyboardModeNumbers:
         collectionToShow = self.numberKeysCollectionArray;
         collectionToHide = self.symbolKeysCollectionArray;
         break;

      case KeyboardModeSymbols:
         collectionToShow = self.symbolKeysCollectionArray;
         collectionToHide = self.numberKeysCollectionArray;
         break;

      default:
         break;
   }

   _hideCollectionArray(collectionToShow, NO);
   _hideCollectionArray(collectionToHide, YES);
}

- (void)initializeAlternateKeyViews
{
   for (LetterSymbolKeyView* keyView in self.keyViews)
   {
      [keyView initializeAlternateKeysView];
   }
}

#pragma mark - Property Overrides
- (NSArray*)numberKeysCollectionArray
{
   return @[self.topNumberKeysCollection, self.middleNumberKeysCollection];
}

- (NSArray*)symbolKeysCollectionArray
{
   return @[self.topSymbolKeysCollection, self.middleSymbolKeysCollection];
}

- (NSArray*)keyViewCollections
{
   return @[self.topNumberKeysCollection,
            self.topSymbolKeysCollection,
            self.middleNumberKeysCollection,
            self.middleSymbolKeysCollection,
            self.punctuationKeysCollection];
}

@end
