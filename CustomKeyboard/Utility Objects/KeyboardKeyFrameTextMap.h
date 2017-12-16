//
//  KeyboardKeyFrameTextMap.h
//  SoundBoard
//
//  Created by Klein, Greg on 1/26/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class KeyView;
@class KeyViewCollection;

@interface KeyboardKeyFrameTextMap : NSObject

+ (instancetype)map;

- (void)reset;

- (void)updateFrameForKeyView:(KeyView*)keyView;
- (void)addFramesForKeyViewCollection:(KeyViewCollection*)collection;
- (void)addFramesWithMap:(KeyboardKeyFrameTextMap*)map;

- (void)removeFramesForMap:(KeyboardKeyFrameTextMap*)map;

- (KeyView*)keyViewAtPointX:(CGPoint)point;
- (KeyView*)keyViewAtPoint:(CGPoint)point;
- (NSArray*)keyViews;

@end
