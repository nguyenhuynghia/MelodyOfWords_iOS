//
//  KeyboardTypedefs.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/24/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#ifndef SoundBoard_KeyboardTypedefs_h
#define SoundBoard_KeyboardTypedefs_h

typedef NS_ENUM(NSUInteger, AltKeysViewDirection)
{
   AltKeysViewDirectionCenter = 0,
   AltKeysViewDirectionLeft,
   AltKeysViewDirectionRight
};

typedef NS_ENUM(NSUInteger, KeyboardKeyType)
{
   KeyTypeDefault,
   KeyTypeFunctional,
   KeyTypeEnlarged,
   KeyTypeAlternate
};

typedef NS_ENUM(NSUInteger, KeyboardFunctionalKeyType)
{
   KeyboardShiftKey,
   KeyboardNumbersKey,
   KeyboardNextKeyboardKey,
   KeyboardDeleteKey,
   KeyboardReturnKey,
   KeyboardSpacebarKey
};

typedef NS_ENUM(NSUInteger, KeyboardShiftMode)
{
   ShiftModeNotApplied = 1,
   ShiftModeApplied,
   ShiftModeCapsLock
};

typedef NS_ENUM(NSUInteger, KeyboardMode)
{
   KeyboardModeLetters = 1,
   KeyboardModeNumbers,
   KeyboardModeSymbols
};

typedef NS_ENUM(NSUInteger, KeyboardRow)
{
   KeyboardRowTop,
   KeyboardRowMiddle,
   KeyboardRowBottom
};

typedef NS_ENUM(NSUInteger, KeyboardKeyRegion)
{
   KeyRegionTop,
   KeyRegionBottom
};

typedef NS_ENUM(NSUInteger, KeyboardRepeatKeyCount)
{
   KeyboardRepeatStartDeletingWords = 15,
};


typedef NS_ENUM(NSUInteger, AutocorrectKeyControllerPriority)
{
   AutocorrectControllerPrimary,
   AutocorrectControllerSecondary,
   AutocorrectControllerTertiary
};
      
#endif
