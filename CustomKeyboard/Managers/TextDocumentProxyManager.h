//
//  TextDocumentProxyManager.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/29/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface TextDocumentProxyManager : NSObject

+ (NSString*)documentContextBeforeInput;
+ (NSString*)documentContextAfterInput;

+ (void)setTextDocumentProxy:(id<UITextDocumentProxy>)proxy;
+ (void)insertText:(NSString*)text;
+ (void)updateShiftMode;
+ (void)replaceCurrentWordWithText:(NSString*)text;
+ (BOOL)deleteBackward:(NSInteger)repeatCount;
+ (void)adjustTextPositionByCharacterOffset:(NSInteger)offset;
+ (BOOL)insertPeriodPriorToWhitespace;
+ (void)insertSpace;

@end
