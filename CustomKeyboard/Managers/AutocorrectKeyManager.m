//
//  AutocorrectKeyManager.m
//  SoundBoard
//
//  Created by Gregory Klein on 3/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "AutocorrectKeyManager.h"
#import "AutocorrectKeyController.h"
#import "SpellCorrectorBridge.h"
#import "UITextChecker+Additions.h"
#import "NSString+Additions.h"
#import "SpellCorrectionResult.h"

static NSString* _properCasing(NSString* string, BOOL uppercase)
{
   NSString* retVal = string;
   if (uppercase)
   {
      retVal = string.titleCase;
   }
   return retVal;
}

@interface AutocorrectKeyManager ()
@property (nonatomic) AutocorrectKeyController* primaryController;
@property (nonatomic) AutocorrectKeyController* secondaryController;
@property (nonatomic) AutocorrectKeyController* tertiaryController;
@property (nonatomic) UITextChecker* textChecker;
@property (nonatomic) BOOL primaryControllerCanTrigger;
@end

@implementation AutocorrectKeyManager

#pragma mark - Init
- (instancetype)init
{
   if (self = [super init])
   {
      // this will do nothing if someone else already called this method, we're calling it
      // here just in case the text file used for spell correction hasn't been loaded yet
      [SpellCorrectorBridge loadForSpellCorrection];
      self.textChecker = [UITextChecker new];

      // For Debugging:
//      NSString* string1 = @"1234abcd";
//      NSString* string2 = @"abcd1234";
//      NSString* string3 = @"a23445";
//      NSString* string4 = @"b123434";
//      NSString* string5 = @"hello";
//
//      NSArray* strings = @[string1, string2, string3, string4, string5];
//      for (NSString* string in strings)
//      {
//         NSLog(@"%@, %@, %@, %@", string,
//               string.letterCharacterString,
//               string.nonLetterCharacterString,
//               [string stringByReplacingLetterCharactersWithString:@"REPLACE"]);
//      }
   }
   return self;
}

#pragma mark - Public Class Methods
+ (instancetype)sharedManager
{
   static AutocorrectKeyManager* manager = nil;
   static dispatch_once_t onceToken;
   dispatch_once(&onceToken, ^{
      manager = [AutocorrectKeyManager new];
   });
   return manager;
}

#pragma mark - Private
- (void)updateControllersWithRealWord:(NSString*)text
{
   NSString* word = text;
   NSArray* guesses = [self.textChecker guessesForWord:text.letterCharacterString];

   if (guesses.count > 0)
   {
      // punctuation hopefully
      NSString* secondaryWord = guesses[0];
      BOOL shouldUseGuess = NO;
      for (int charIndex = 0; charIndex < secondaryWord.length; ++charIndex)
      {
         if ([secondaryWord characterAtIndex:charIndex] == '\'')
         {
            shouldUseGuess = YES;
            break;
         }
      }

      if (shouldUseGuess == NO && ![text isEqualToString:word])
      {
         secondaryWord = text.quotedString;
      }
      [self.secondaryController updateText:[text stringByReplacingLetterCharactersWithString:secondaryWord]];

      NSString* tertiaryWord = guesses.count > 1 ? _properCasing(guesses[1], text.isUppercase) : nil;
      tertiaryWord = [text stringByReplacingLetterCharactersWithString:tertiaryWord];

      [self.tertiaryController updateText:tertiaryWord];
   }

   [self.primaryController updateText:word.quotedString];
   self.primaryControllerCanTrigger = YES;
}

- (void)updateControllersWithMisspelledWord:(NSString*)text corrections:(NSArray*)corrections
{
   [self.secondaryController updateText:text.quotedString];

   SpellCorrectionResult* firstResult = corrections[0];
   NSString* word = _properCasing(firstResult.word, text.isUppercase);
   NSString* primaryWord = [text stringByReplacingLetterCharactersWithString:word];

   [self.primaryController updateText:primaryWord];
   self.primaryControllerCanTrigger = YES;

   if (corrections.count > 1)
   {
      for (int correctionIndex = 1; correctionIndex < corrections.count; ++correctionIndex)
      {
         SpellCorrectionResult* result = corrections[correctionIndex];
         NSString* resultWord = _properCasing(result.word, text.isUppercase);
         if (![resultWord isEqualToString:word] && resultWord.length > 0)
         {
            NSString* tertiaryWord = [text stringByReplacingLetterCharactersWithString:resultWord];
            [self.tertiaryController updateText:tertiaryWord];
            break;
         }
      }
   }
}

- (void)updateControllersWithInvalidWord:(NSString*)word
{
   [self.primaryController updateText:word.quotedString];
   [self.secondaryController updateText:@""];
   [self.tertiaryController updateText:@""];
}

#pragma mark - Public
- (void)setAutocorrectKeyController:(AutocorrectKeyController *)controller withPriority:(AutocorrectKeyControllerPriority)priority
{
   AutocorrectKeyManager* manager = [[self class] sharedManager];
   switch (priority)
   {
      case AutocorrectControllerPrimary:
         manager.primaryController = controller;
         break;

      case AutocorrectControllerSecondary:
         manager.secondaryController = controller;
         break;

      case AutocorrectControllerTertiary:
         manager.tertiaryController = controller;
         break;

      default:
         break;
   }
}

- (void)updateControllersWithTextInput:(NSString*)text
{
   self.primaryControllerCanTrigger = NO;
   if (text)
   {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

         if (text.isValidForCorrecting)
         {
            NSArray* corrections = [SpellCorrectorBridge correctionsForText:text.letterCharacterString];
            if (corrections.count == 0)
            {
               [self updateControllersWithRealWord:text];
            }
            else
            {
               [self updateControllersWithMisspelledWord:text corrections:corrections];
            }
         }
         else
         {
            [self updateControllersWithInvalidWord:text];
         }
      });
   }
   else
   {
      [self resetControllers];
   }
}

- (void)resetControllers
{
   self.primaryControllerCanTrigger = NO;
   [self.primaryController updateText:@""];
   [self.secondaryController updateText:@""];
   [self.tertiaryController updateText:@""];
}

- (BOOL)triggerPrimaryKeyIfPossible
{
   BOOL triggered = NO;
   if (self.primaryControllerCanTrigger)
   {
      [self.primaryController trigger];
      triggered = YES;
   }
   return triggered;
}

@end
