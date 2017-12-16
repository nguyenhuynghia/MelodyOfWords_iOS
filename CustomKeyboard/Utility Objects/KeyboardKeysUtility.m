//
//  KeyboardKeysUtility.m
//  SoundBoard
//
//  Created by Gregory Klein on 1/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyboardKeysUtility.h"

static NSArray* _altCharactersArray(NSString* character)
{
   NSArray* characterArray = nil;
   NSString* uppercaseCharacter = character.uppercaseString;

   if ([uppercaseCharacter isEqualToString:@"E"])
   {
      characterArray = @[@"È", @"É", @"Ê", @"Ë", @"Ē", @"Ė", @"Ę"];
   }
   else if ([uppercaseCharacter isEqualToString:@"Y"])
   {
      characterArray = @[@"Ÿ"];
   }
   else if ([uppercaseCharacter isEqualToString:@"U"])
   {
      characterArray = @[@"Ū", @"Ú", @"Ù", @"Ü", @"Û"];
   }
   else if ([uppercaseCharacter isEqualToString:@"I"])
   {
      characterArray = @[@"Ì", @"Į", @"Ī", @"Í", @"Ï", @"Î"];
   }
   else if ([uppercaseCharacter isEqualToString:@"O"])
   {
      characterArray = @[@"Õ", @"Ō", @"Ø", @"Œ", @"Ó", @"Ò", @"Ö", @"Ô"];
   }
   else if ([uppercaseCharacter isEqualToString:@"A"])
   {
      characterArray = @[@"À", @"Á", @"Â", @"Ä", @"Æ", @"Ã", @"Å", @"Ā"];
   }
   else if ([uppercaseCharacter isEqualToString:@"S"])
   {
      characterArray = @[@"Ś", @"Š"];
   }
   else if ([uppercaseCharacter isEqualToString:@"L"])
   {
      characterArray = @[@"Ł"];
   }
   else if ([uppercaseCharacter isEqualToString:@"Z"])
   {
      characterArray = @[@"Ž", @"Ź", @"Ż"];
   }
   else if ([uppercaseCharacter isEqualToString:@"C"])
   {
      characterArray = @[@"Ç", @"Ć", @"Č"];
   }
   else if ([uppercaseCharacter isEqualToString:@"N"])
   {
      characterArray = @[@"Ń", @"Ñ"];
   }
   else if ([uppercaseCharacter isEqualToString:@"%"])
   {
      characterArray = @[@"‰"];
   }
   else if ([uppercaseCharacter isEqualToString:@"."])
   {
      characterArray = @[@"…"];
   }
   else if ([uppercaseCharacter isEqualToString:@"?"])
   {
      characterArray = @[@"¿"];
   }
   else if ([uppercaseCharacter isEqualToString:@"!"])
   {
      characterArray = @[@"¡"];
   }
   else if ([uppercaseCharacter isEqualToString:@"'"])
   {
      characterArray = @[@"`", @"‘", @"’"];
   }
   else if ([uppercaseCharacter isEqualToString:@"0"])
   {
      characterArray = @[@"°"];
   }
   else if ([uppercaseCharacter isEqualToString:@"-"])
   {
      characterArray = @[@"–", @"—", @"•"];
   }
   else if ([uppercaseCharacter isEqualToString:@"/"])
   {
      characterArray = @[@"\\"];
   }
   else if ([uppercaseCharacter isEqualToString:@"$"])
   {
      characterArray = @[@"₽", @"¥", @"€", @"¢", @"£", @"₩"];
   }
   else if ([uppercaseCharacter isEqualToString:@"&"])
   {
      characterArray = @[@"§"];
   }
   else if ([uppercaseCharacter isEqualToString:@"\""])
   {
      characterArray = @[@"«", @"»", @"„", @"“", @"”"];
   }
   return characterArray;
}

static NSArray* _altCharactersArrayWithPrimaryCharacter(NSString* primaryCharacter, AltKeysViewDirection direction)
{
   NSMutableArray* mutableAltCharacters = [_altCharactersArray(primaryCharacter) mutableCopy];
   NSUInteger indexToInsert = 0;
   switch (direction)
   {
      case AltKeysViewDirectionCenter:
         indexToInsert = mutableAltCharacters.count * .5f;
         break;

      case AltKeysViewDirectionLeft:
         indexToInsert = mutableAltCharacters.count;
         break;

      case AltKeysViewDirectionRight:
      default:
         break;
   }
   [mutableAltCharacters insertObject:primaryCharacter atIndex:indexToInsert];
   return mutableAltCharacters;
}

static AltKeysViewDirection _altKeysViewDirection(NSString* character)
{
   AltKeysViewDirection direction = AltKeysViewDirectionCenter;
   NSString* uppercaseCharacter = character.uppercaseString;

   if ([uppercaseCharacter isEqualToString:@"E"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"Y"])
   {
      direction = AltKeysViewDirectionLeft;
   }
   else if ([uppercaseCharacter isEqualToString:@"U"])
   {
      direction = AltKeysViewDirectionLeft;
   }
   else if ([uppercaseCharacter isEqualToString:@"I"])
   {
      direction = AltKeysViewDirectionLeft;
   }
   else if ([uppercaseCharacter isEqualToString:@"O"])
   {
      direction = AltKeysViewDirectionLeft;
   }
   else if ([uppercaseCharacter isEqualToString:@"A"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"S"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"L"])
   {
      direction = AltKeysViewDirectionLeft;
   }
   else if ([uppercaseCharacter isEqualToString:@"Z"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"C"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"N"])
   {
      direction = AltKeysViewDirectionLeft;
   }
   else if ([uppercaseCharacter isEqualToString:@"%"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"."])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"?"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"!"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"'"])
   {
      direction = AltKeysViewDirectionLeft;
   }
   else if ([uppercaseCharacter isEqualToString:@"0"])
   {
      direction = AltKeysViewDirectionLeft;
   }
   else if ([uppercaseCharacter isEqualToString:@"-"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"/"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"$"])
   {
      direction = AltKeysViewDirectionCenter;
   }
   else if ([uppercaseCharacter isEqualToString:@"&"])
   {
      direction = AltKeysViewDirectionRight;
   }
   else if ([uppercaseCharacter isEqualToString:@"\""])
   {
      direction = AltKeysViewDirectionLeft;
   }
   return direction;
}

static NSArray* _letterArray(KeyboardRow row)
{
   NSArray* characterArray = nil;
   switch (row)
   {
      case KeyboardRowTop:
         characterArray = @[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P"];
         break;

      case KeyboardRowMiddle:
         characterArray = @[@"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K", @"L"];
         break;

      case KeyboardRowBottom:
         characterArray = @[@"Z", @"X", @"C", @"V", @"B", @"N", @"M"];
         break;

      default:
         break;
   }
   return characterArray;
}

static NSArray* _numberArray(KeyboardRow row)
{
   NSArray* characterArray = nil;
   switch (row)
   {
      case KeyboardRowTop:
         characterArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
         break;
         
      case KeyboardRowMiddle:
         characterArray = @[@"-", @"/", @":", @";", @"(", @")", @"$", @"&", @"@", @"\""];
         break;
         
      case KeyboardRowBottom:
         characterArray = @[@".", @",", @"?", @"!", @"'"];
         break;
         
      default:
         break;
   }
   return characterArray;
}

static NSArray* _symbolArray(KeyboardRow row)
{
   NSArray* characterArray = nil;
   switch (row)
   {
      case KeyboardRowTop:
         characterArray = @[@"[", @"]", @"{", @"}", @"#", @"%", @"^", @"*", @"+", @"="];
         break;
         
      case KeyboardRowMiddle:
         characterArray = @[@"_", @"\\", @"|", @"~", @"<", @">", @"€", @"£", @"¥", @"•"];
         break;
         
      case KeyboardRowBottom:
         characterArray = @[@".", @",", @"?", @"!", @"'"];
         break;
         
      default:
         break;
   }
   return characterArray;
}

@implementation KeyboardKeysUtility

+ (NSArray*)charactersForMode:(KeyboardMode)mode row:(KeyboardRow)row
{
   NSArray* characterArray = nil;
   switch (mode)
   {
      case KeyboardModeLetters:
         characterArray = _letterArray(row);
         break;

      case KeyboardModeNumbers:
         characterArray = _numberArray(row);
         break;

      case KeyboardModeSymbols:
         characterArray = _symbolArray(row);

      default:
         break;
   }
   return characterArray;
}

+ (NSArray*)altCharactersForCharacter:(NSString*)character
{
   return _altCharactersArray(character);
}

+ (NSArray*)altCharactersForCharacter:(NSString*)character direction:(AltKeysViewDirection)direction
{
   return _altCharactersArrayWithPrimaryCharacter(character, direction);
}

+ (NSUInteger)numKeysForMode:(KeyboardMode)mode row:(KeyboardRow)row
{
   NSUInteger numKeys = [KeyboardKeysUtility charactersForMode:mode row:row].count;
   return isnan(numKeys) ? 0 : numKeys;
}

+ (AltKeysViewDirection)directionForCharacter:(NSString *)character
{
   return _altKeysViewDirection(character);
}

@end
