//
//  EnlargedKeyView.h
//  SoundBoard
//
//  Created by Gregory Klein on 2/2/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardTypedefs.h"

typedef  NS_ENUM(NSUInteger, EnlargedKeyType)
{
   EnlargedKeyTypeDefault,
   EnlargedKeyTypeLeft,
   EnlargedKeyTypeRight
};

@class KeyView;
@interface EnlargedKeyView : UIView

+ (instancetype)viewWithKeyView:(KeyView*)keyView;
- (void)updateFrame:(CGRect)frame;
- (void)updateForShiftMode:(KeyboardShiftMode)mode;

@property (nonatomic) EnlargedKeyType keyType;

@end
