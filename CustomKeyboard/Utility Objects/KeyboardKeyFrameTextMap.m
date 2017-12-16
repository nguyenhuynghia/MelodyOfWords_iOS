//
//  KeyboardKeyFrameTextMap.m
//  SoundBoard
//
//  Created by Klein, Greg on 1/26/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyboardKeyFrameTextMap.h"
#import "KeyViewCollection.h"
#import "KeyView.h"

@interface KeyboardKeyFrameTextMap ()
@property (nonatomic) NSMutableDictionary* keyFrameTextDictionary;
@end

@implementation KeyboardKeyFrameTextMap

#pragma mark - Init
- (instancetype)init
{
   if (self = [super init])
   {
      self.keyFrameTextDictionary = [NSMutableDictionary dictionary];
   }
   return self;
}

#pragma mark - Class Init
+ (instancetype)map
{
   return [[KeyboardKeyFrameTextMap alloc] init];
}

#pragma mark - Helper
- (CGRect)convertedFrameFromKeyboardView:(KeyView*)keyView
{
   return [keyView convertRect:keyView.bounds toView:nil];
}

- (void)removeValuesWithKeyView:(KeyView*)keyView
{
   NSMutableArray* keysToRemove = [NSMutableArray array];
   for (NSValue* frameValue in self.keyFrameTextDictionary.allKeys)
   {
      KeyView* view = [self.keyFrameTextDictionary objectForKey:frameValue];
      if (view == keyView)
      {
         [keysToRemove addObject:frameValue];
      }
   }

   [self.keyFrameTextDictionary removeObjectsForKeys:keysToRemove];
}

#pragma mark - Public
- (void)reset
{
   [self.keyFrameTextDictionary removeAllObjects];
}

- (void)updateFrameForKeyView:(KeyView*)keyView
{
   [self removeValuesWithKeyView:keyView];

   CGRect frame = [self convertedFrameFromKeyboardView:keyView];
   NSValue* frameValue = [NSValue valueWithCGRect:frame];
   self.keyFrameTextDictionary[frameValue] = keyView;
}

- (void)addFramesForKeyViewCollection:(KeyViewCollection*)collection
{
   for (KeyView* keyView in collection.keyViews)
   {
      [self updateFrameForKeyView:keyView];
   }
}

- (void)addFramesWithMap:(KeyboardKeyFrameTextMap *)map
{
   for (KeyView* keyView in map.keyViews)
   {
      [self updateFrameForKeyView:keyView];
   }
}

- (void)removeFramesForMap:(KeyboardKeyFrameTextMap*)map
{
   for (KeyView* keyView in map.keyViews)
   {
      [self removeValuesWithKeyView:keyView];
   }
}

- (KeyView*)keyViewAtPoint:(CGPoint)point
{
   KeyView* targetKeyView = nil;
   for (NSValue* frameValue in self.keyFrameTextDictionary.allKeys)
   {
      CGRect frame = [frameValue CGRectValue];
      if (CGRectContainsPoint(frame, point))
      {
         targetKeyView = self.keyFrameTextDictionary[frameValue];
         break;
      }
   }
   return targetKeyView;
}

- (KeyView*)keyViewAtPointX:(CGPoint)point
{
   KeyView* targetKeyView = nil;
   for (NSValue* frameValue in self.keyFrameTextDictionary.allKeys)
   {
      CGRect frame = [frameValue CGRectValue];
      if (CGRectGetMinX(frame) <= point.x && CGRectGetMaxX(frame) >= point.x)
      {
         targetKeyView = self.keyFrameTextDictionary[frameValue];
         break;
      }
   }
   return targetKeyView;
}

- (NSArray*)keyViews
{
   return self.keyFrameTextDictionary.allValues;
}

@end
