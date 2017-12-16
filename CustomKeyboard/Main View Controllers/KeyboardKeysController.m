//
//  KeyboardKeysController.m
//  SoundBoard
//
//  Created by Gregory Klein on 1/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyboardKeysController.h"
#import "DeleteKeyController.h"
#import "ShiftSymbolsKeyController.h"
#import "LetterNumberKeyController.h"
#import "NextKeyboardKeyController.h"
#import "SpacebarKeyController.h"
#import "ReturnKeyController.h"
#import "LetterKeysController.h"
#import "NumberSymbolKeysController.h"
#import "KeyboardLayoutDimensonsProvider.h"
#import "KeyboardKeyFrameTextMap.h"
#import "LetterSymbolKeyView.h"

@interface KeyboardKeysController ()

@property (nonatomic) LetterKeysController* letterKeysController;
@property (nonatomic) NumberSymbolKeysController* numberSymbolKeysController;

@property (nonatomic) DeleteKeyController* deleteController;
@property (nonatomic) ShiftSymbolsKeyController* shiftSymbolsController;
@property (nonatomic) LetterNumberKeyController* letterNumberController;
@property (nonatomic) SpacebarKeyController* spacebarKeyController;
@property (nonatomic) ReturnKeyController* returnKeyController;

@property (nonatomic, readonly) NSArray* functionalKeyControllers;

@property (nonatomic) KeyboardLayoutDimensonsProvider* dimensionsProvider;
@property (nonatomic) KeyboardMode mode;

@end

@implementation KeyboardKeysController

#pragma mark - Init
- (instancetype)initWithMode:(KeyboardMode)mode
{
   if (self = [super init])
   {
      [self setupDimensionsProvider];
      [self setupKeysControllers];
      [self setupFunctionalKeyControllers];
      [self updateMode:mode];
   }
   return self;
}

#pragma mark - Class Init
+ (instancetype)controllerWithMode:(KeyboardMode)mode
{
   return [[KeyboardKeysController alloc] initWithMode:mode];
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
   [super viewDidLoad];
   self.view.backgroundColor = [UIColor colorWithRed:43/255.f green:44/255.f blue:48/255.f alpha:1];
}

- (void)viewDidLayoutSubviews
{
   if (CGRectEqualToRect(self.view.bounds, CGRectZero) == NO)
   {
      [self.dimensionsProvider updateInputViewFrame:self.view.frame];

      [self updateKeysControllersFrames];
      [self updateFunctionalKeysFrames];
      [self updateKeyboardMapUpdaterWithMode:self.mode];
   }
}

#pragma mark - Setup
- (void)setupFunctionalKeyControllers
{
   self.deleteController = [DeleteKeyController controller];
   self.shiftSymbolsController = [ShiftSymbolsKeyController controller];
   self.letterNumberController = [LetterNumberKeyController controller];
//   self.nextKeyboardController = [NextKeyboardKeyController controller];
   self.spacebarKeyController = [SpacebarKeyController controller];
   self.returnKeyController = [ReturnKeyController controller];
   
   for (FunctionalKeyController* controller in self.functionalKeyControllers)
   {
      [self.view addSubview:controller.view];
   }
}

- (void)setupKeysControllers
{
   self.letterKeysController = [LetterKeysController controllerWithDimensionsProvider:self.dimensionsProvider];
   [self.letterKeysController initializeAlternateKeyViews];
   [self.view addSubview:self.letterKeysController.view];

   self.numberSymbolKeysController = [NumberSymbolKeysController controllerWithDimensionsProvider:self.dimensionsProvider];
   [self.numberSymbolKeysController initializeAlternateKeyViews];
   [self.view addSubview:self.numberSymbolKeysController.view];
}

- (void)setupDimensionsProvider
{
   self.dimensionsProvider = [KeyboardLayoutDimensonsProvider dimensionsProvider];
}

#pragma mark - Update
- (void)updateKeysControllersFrames
{
   CGRect topRegionFrame = [self.dimensionsProvider frameForKeyboardKeyRegion:KeyRegionTop];

   [self.letterKeysController updateFrame:topRegionFrame];
   [self.numberSymbolKeysController updateFrame:topRegionFrame];
}

- (void)updateFunctionalKeysFrames
{
   [self updateDeleteKeyFrame];
   [self updateShiftSymbolKeyFrame];
   [self updateLetterNumberKeyFrame];
   [self updateNextKeyboardKeyFrame];
   [self updateSpacebarKeyFrame];
   [self updateReturnKeyFrame];
}

- (void)updateDeleteKeyFrame
{
   CGRect backspaceKeyFrame = [self.dimensionsProvider frameForKeyboardKeyType:KeyboardDeleteKey];
   [self.deleteController updateFrame:backspaceKeyFrame];
}

- (void)updateShiftSymbolKeyFrame
{
   CGRect shiftKeyFrame = [self.dimensionsProvider frameForKeyboardKeyType:KeyboardShiftKey];
   [self.shiftSymbolsController updateFrame:shiftKeyFrame];
}

- (void)updateLetterNumberKeyFrame
{
   CGRect letterNumberKeyFrame = [self.dimensionsProvider frameForKeyboardKeyType:KeyboardNumbersKey];
   [self.letterNumberController updateFrame:letterNumberKeyFrame];
}

- (void)updateNextKeyboardKeyFrame
{
   CGRect nextKeyboardKeyFrame = [self.dimensionsProvider frameForKeyboardKeyType:KeyboardNextKeyboardKey];
//   [self.nextKeyboardController updateFrame:nextKeyboardKeyFrame];
}

- (void)updateSpacebarKeyFrame
{
   CGRect spacebarFrame = [self.dimensionsProvider frameForKeyboardKeyType:KeyboardSpacebarKey];
   [self.spacebarKeyController updateFrame:spacebarFrame];
}

- (void)updateReturnKeyFrame
{
   CGRect returnKeyFrame = [self.dimensionsProvider frameForKeyboardKeyType:KeyboardReturnKey];
   [self.returnKeyController updateFrame:returnKeyFrame];
}

#pragma mark - Helper
- (void)updateKeyboardMapUpdaterWithMode:(KeyboardMode)mode
{
//   [self resetKeyboardMapUpdaterWithMode:mode];

   KeyboardKeyFrameTextMap* keyFrameTextMap = [KeyboardKeyFrameTextMap map];
   for (KeyViewCollection* collection in [self keysCollectionArrayForMode:mode])
   {
      [keyFrameTextMap addFramesForKeyViewCollection:collection];
   }
   
   for (FunctionalKeyController* controller in self.functionalKeyControllers)
   {
      KeyView* keyView = [controller keyViewForMode:mode];
      [keyFrameTextMap updateFrameForKeyView:keyView];
   }
   
   if (self.keyboardMapUpdater != nil)
   {
      [self.keyboardMapUpdater updateKeyboardKeyFrameTextMap:keyFrameTextMap];
   }
}

- (void)resetKeyboardMapUpdaterWithMode:(KeyboardMode)mode
{
   KeyboardKeyFrameTextMap* keyFrameTextMap = [KeyboardKeyFrameTextMap map];
   for (KeyViewCollection* collection in [self keysCollectionArrayForMode:mode])
   {
      [keyFrameTextMap addFramesForKeyViewCollection:collection];
   }
   [self.keyboardMapUpdater removeKeyViewsWithKeyFrameTextMap:keyFrameTextMap];
}

- (NSArray*)keysCollectionArrayForMode:(KeyboardMode)mode
{
   NSArray* keysCollectionArray = nil;
   switch (mode)
   {
      case KeyboardModeLetters:
         keysCollectionArray = self.letterKeysController.keyViewCollections;
         break;
      
      case KeyboardModeNumbers:
         keysCollectionArray = self.numberSymbolKeysController.numberKeysCollectionArray;
         keysCollectionArray = [keysCollectionArray arrayByAddingObject:self.numberSymbolKeysController.punctuationKeysCollection];
         break;
         
      case KeyboardModeSymbols:
         keysCollectionArray = self.numberSymbolKeysController.symbolKeysCollectionArray;
         keysCollectionArray = [keysCollectionArray arrayByAddingObject:self.numberSymbolKeysController.punctuationKeysCollection];
         break;
         
      default:
         break;
   }
   return keysCollectionArray;
}

- (NSArray*)unusedKeysCollectionArrayForMode:(KeyboardMode)mode
{
   NSArray* keysCollectionArray = nil;
   switch (mode)
   {
      case KeyboardModeLetters:
         keysCollectionArray = self.numberSymbolKeysController.keyViewCollections;
         break;

      case KeyboardModeNumbers:
         keysCollectionArray = self.letterKeysController.keyViewCollections;
         break;

      case KeyboardModeSymbols:
         keysCollectionArray = self.letterKeysController.keyViewCollections;
         break;

      default:
         break;
   }
   return keysCollectionArray;
}

#pragma mark - Property Overrides
- (NSArray*)functionalKeyControllers
{
   return @[
//            self.shiftSymbolsController,
//            self.letterNumberController,
//            self.nextKeyboardController,
            self.spacebarKeyController,
            self.deleteController,
//            self.returnKeyController
            ];
}

#pragma mark - Public
- (void)updateMode:(KeyboardMode)mode
{
   if (mode != self.mode)
   {
      [self updateKeysControllersWithMode:mode];
      [self updateFunctionalKeyControllersWithMode:mode];
      
      if (self.mode != 0)
      {
         [self resetKeyboardMapUpdaterWithMode:self.mode];
      }
      [self updateKeyboardMapUpdaterWithMode:mode];
      self.mode = mode;
   }
}

- (void)updateKeysControllersWithMode:(KeyboardMode)mode
{
   KeysController* keysControllerToShow = nil;
   KeysController* keysControllerToHide = nil;
   switch (mode)
   {
      case KeyboardModeLetters:
         keysControllerToShow = self.letterKeysController;
         keysControllerToHide = self.numberSymbolKeysController;
         break;

      case KeyboardModeNumbers:
      case KeyboardModeSymbols:
         keysControllerToShow = self.numberSymbolKeysController;
         keysControllerToHide = self.letterKeysController;
         [self.numberSymbolKeysController updateMode:mode];
         break;

      default:
         break;
   }
   keysControllerToShow.view.hidden = NO;
   keysControllerToHide.view.hidden = YES;
}

- (void)updateFunctionalKeyControllersWithMode:(KeyboardMode)mode
{
   for (FunctionalKeyController* controller in self.functionalKeyControllers)
   {
      [controller updateMode:mode];
   }
}

- (void)updateShiftMode:(KeyboardShiftMode)shiftMode
{
   [self.letterKeysController updateShiftMode:shiftMode];
   [((ShiftSymbolsKeyController*)self.shiftSymbolsController) updateShiftMode:shiftMode];
}

@end
