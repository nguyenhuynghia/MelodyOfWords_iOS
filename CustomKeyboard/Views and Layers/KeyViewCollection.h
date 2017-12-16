//
//  LetterViewCollection.h
//  SoundBoard
//
//  Created by Gregory Klein on 1/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardTypedefs.h"

@interface KeyViewCollection : UIView

+ (instancetype)collectionWithCharacters:(NSArray*)array;
+ (instancetype)collectionWithCharacters:(NSArray*)array forKeyType:(KeyboardKeyType)type;

- (void)updateFrame:(CGRect)frame;

@property (nonatomic, readonly) NSArray* keyViews;
@property (nonatomic, readonly) CGFloat keyWidth;

@end
