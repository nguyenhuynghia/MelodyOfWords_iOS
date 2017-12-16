
//
//  KeyboardLayoutDimensonsProvider.m
//  SoundBoard
//
//  Created by Klein, Greg on 1/25/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyboardLayoutDimensonsProvider.h"
#import "KeyboardKeysUtility.h"

#define NUM_ROWS 4
#define NUM_LETTERS_OVER_SPACEBAR 7

static CGRect _bottomRegionFrame(CGRect inputViewFrame, CGFloat keyHeight)
{
   CGFloat x = 0;
   CGFloat y = CGRectGetHeight(inputViewFrame) - keyHeight;
   CGFloat width = CGRectGetWidth(inputViewFrame);
   CGFloat height = keyHeight;
   
   return CGRectMake(x, y, width, height);
}

static CGRect _topRegionFrame(CGRect inputViewFrame, CGFloat keyHeight)
{
   CGFloat x = 0;
   CGFloat y = 0;
   CGFloat width = CGRectGetWidth(inputViewFrame);
   CGFloat height = CGRectGetHeight(inputViewFrame) - keyHeight;
   
   return CGRectMake(x, y, width, height);
}

static CGRect _lettersFrame(KeyboardRow row, CGFloat letterKeyWidth, CGFloat keyHeight)
{
   CGFloat xPosition = 0;
   CGFloat yPosition = 0;
   
   NSUInteger numKeys = [KeyboardKeysUtility numKeysForMode:KeyboardModeLetters row:row];
   CGFloat width = letterKeyWidth * numKeys;
   switch (row)
   {
      case KeyboardRowTop:
         break;
         
      case KeyboardRowMiddle:
         xPosition = letterKeyWidth*.5f;
         yPosition = keyHeight;
         break;
      
      case KeyboardRowBottom:
         xPosition = letterKeyWidth*1.5f;
         yPosition = keyHeight*2;
         break;
         
      default:
         break;
   }
   return CGRectMake(xPosition, yPosition, width, keyHeight);
}

static CGRect _numbersFrame(KeyboardRow row, CGFloat numberKeyWidth, CGFloat punctuationKeyWidth, CGFloat keyHeight)
{
   CGFloat xPosition = 0;
   CGFloat yPosition = 0;
   
   NSUInteger numKeys = [KeyboardKeysUtility numKeysForMode:KeyboardModeNumbers row:row];
   CGFloat width = numberKeyWidth * numKeys;
   switch (row)
   {
      case KeyboardRowTop:
         break;
         
      case KeyboardRowMiddle:
         yPosition = keyHeight;
         break;
         
      case KeyboardRowBottom:
         xPosition = numberKeyWidth*1.5f;
         yPosition = keyHeight*2;
         width = punctuationKeyWidth * numKeys;
         break;
         
      default:
         break;
   }
   return CGRectMake(xPosition, yPosition, width, keyHeight);
}

static CGRect _symbolsFrame(KeyboardRow row, CGFloat symbolsKeyWidth, CGFloat punctuationKeyWidth, CGFloat keyHeight)
{
   return _numbersFrame(row, symbolsKeyWidth, punctuationKeyWidth, keyHeight);
}

static CGRect _shiftKeyFrame(CGFloat letterKeyWidth, CGFloat keyHeight, CGFloat inputViewWidth)
{
   CGFloat bottomLettersFrameWidth = CGRectGetWidth(_lettersFrame(KeyboardRowBottom, letterKeyWidth, keyHeight));
   CGFloat width = (inputViewWidth - bottomLettersFrameWidth)*.5f;
   CGFloat yPosition = keyHeight*2;
   
   return CGRectMake(0, yPosition, width, keyHeight);
}

static CGRect _deleteKeyFrame(CGFloat letterKeyWidth, CGFloat keyHeight, CGFloat inputViewWidth)
{
   CGFloat bottomLettersFrameWidth = CGRectGetWidth(_lettersFrame(KeyboardRowBottom, letterKeyWidth, keyHeight));
   CGFloat width = (inputViewWidth - bottomLettersFrameWidth)*.5f;
   CGFloat xPosition = inputViewWidth - width;
   CGFloat yPosition = keyHeight*2;
   
   return CGRectMake(xPosition, yPosition, width, keyHeight);
}

static CGRect _numbersKeyFrame(CGFloat letterKeyWidth, CGFloat keyHeight, CGFloat inputViewWidth)
{
   CGFloat spacebarKeyWidth = letterKeyWidth*NUM_LETTERS_OVER_SPACEBAR;
   CGFloat width = (inputViewWidth - spacebarKeyWidth)*.25f;
   CGFloat xPosition = 0;
   CGFloat yPosition = keyHeight*3;
   
   return CGRectMake(xPosition, yPosition, width, keyHeight);
}

static CGRect _nextKeyboardKeyFrame(CGFloat letterKeyWidth, CGFloat keyHeight, CGFloat inputViewWidth)
{
   CGFloat spacebarKeyWidth = letterKeyWidth*NUM_LETTERS_OVER_SPACEBAR;
   CGFloat width = (inputViewWidth - spacebarKeyWidth)*.25f;
   CGFloat xPosition = width;
   CGFloat yPosition = keyHeight*3;
   
   return CGRectMake(xPosition, yPosition, width, keyHeight);
}

static CGRect _returnKeyFrame(CGFloat letterKeyWidth, CGFloat keyHeight, CGFloat inputViewWidth)
{
   CGFloat spacebarKeyWidth = letterKeyWidth*NUM_LETTERS_OVER_SPACEBAR;
   CGFloat width = (inputViewWidth - spacebarKeyWidth)*.5f;
   CGFloat xPosition = inputViewWidth - width;
   CGFloat yPosition = keyHeight*3;
   
   return CGRectMake(xPosition, yPosition, width, keyHeight);
}

static CGRect _spacebarKeyFrame(CGFloat letterKeyWidth, CGFloat keyHeight, CGFloat inputViewWidth)
{
   CGFloat width = letterKeyWidth*NUM_LETTERS_OVER_SPACEBAR;
   CGFloat xPosition = inputViewWidth*.5 - width*.5f;
   CGFloat yPosition = keyHeight*3;
   
   return CGRectMake(xPosition, yPosition, width, keyHeight);
}

@interface KeyboardLayoutDimensonsProvider ()
@property (nonatomic) CGRect inputViewFrame;
@property (nonatomic, readonly) CGFloat letterKeyWidth;
@property (nonatomic, readonly) CGFloat punctuationKeyWidth;
@property (nonatomic, readonly) CGFloat keyHeight;
@end

@implementation KeyboardLayoutDimensonsProvider

#pragma mark - Class Init
+ (instancetype)dimensionsProvider
{
   KeyboardLayoutDimensonsProvider* provider = [KeyboardLayoutDimensonsProvider new];
   provider.inputViewFrame = CGRectZero;
   
   return provider;
}

#pragma mark - Property Overrides
- (CGFloat)letterKeyWidth
{
   NSUInteger numKeysInTopRow = [KeyboardKeysUtility numKeysForMode:KeyboardModeLetters row:KeyboardRowTop];
   return CGRectGetWidth(self.inputViewFrame) / numKeysInTopRow;
}

- (CGFloat)punctuationKeyWidth
{
   NSUInteger numKeys = [KeyboardKeysUtility numKeysForMode:KeyboardModeNumbers row:KeyboardRowBottom];
   CGFloat punctuationKeyFrameWidth = CGRectGetWidth(self.inputViewFrame) - self.letterKeyWidth*3;
   return punctuationKeyFrameWidth / numKeys;
}

- (CGFloat)keyHeight
{
   return CGRectGetHeight(self.inputViewFrame) / NUM_ROWS;
}

#pragma mark - Public
- (void)updateInputViewFrame:(CGRect)frame
{
   self.inputViewFrame = frame;
}

- (CGRect)frameForKeyboardMode:(KeyboardMode)mode row:(KeyboardRow)row
{
   CGRect frame = CGRectZero;
   switch (mode)
   {
      case KeyboardModeLetters:
         frame = _lettersFrame(row, self.letterKeyWidth, self.keyHeight);
         break;
         
      case KeyboardModeNumbers:
         frame = _numbersFrame(row, self.letterKeyWidth, self.punctuationKeyWidth, self.keyHeight);
         break;
         
      case KeyboardModeSymbols:
         frame = _symbolsFrame(row, self.letterKeyWidth, self.punctuationKeyWidth, self.keyHeight);
         break;
   }
   return frame;
}

- (CGRect)frameForKeyboardKeyType:(KeyboardFunctionalKeyType)type
{
   CGRect frame = CGRectZero;
   CGFloat inputViewWidth = CGRectGetWidth(self.inputViewFrame);
   switch (type)
   {
      case KeyboardShiftKey:
         frame = _shiftKeyFrame(self.letterKeyWidth, self.keyHeight, inputViewWidth);
         break;
         
      case KeyboardNumbersKey:
         frame = _numbersKeyFrame(self.letterKeyWidth, self.keyHeight, inputViewWidth);
         break;
         
      case KeyboardNextKeyboardKey:
         frame = _nextKeyboardKeyFrame(self.letterKeyWidth, self.keyHeight, inputViewWidth);
         break;
         
      case KeyboardDeleteKey:
         frame = _deleteKeyFrame(self.letterKeyWidth, self.keyHeight, inputViewWidth);
         break;
         
      case KeyboardReturnKey:
         frame = _returnKeyFrame(self.letterKeyWidth, self.keyHeight, inputViewWidth);
         break;
         
      case KeyboardSpacebarKey:
         frame = _spacebarKeyFrame(self.letterKeyWidth, self.keyHeight, inputViewWidth);
         break;
         
      default:
         break;
   }
   return frame;
}

- (CGRect)frameForKeyboardKeyRegion:(KeyboardKeyRegion)region
{
   CGRect frame = CGRectZero;
   switch (region)
   {
      case KeyRegionTop:
         frame = _topRegionFrame(self.inputViewFrame, self.keyHeight);
         break;
         
      case KeyRegionBottom:
         frame = _bottomRegionFrame(self.inputViewFrame, self.keyHeight);
         break;
         
      default:
         break;
   }
   return frame;
}

@end
