//
//  KeyboardTimer.m
//  SoundBoard
//
//  Created by Alton, Leif on 02/16/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyboardTimer.h"
#import "KeyboardTypedefs.h"
#import "KeyView.h"

@interface KeyboardTimer ()
{
   dispatch_source_t _oneShotTimer;
   dispatch_source_t _repeatTimer;
   KeyView *         _repeatKey;
   NSInteger         _repeatCount;
}

@end

@implementation KeyboardTimer

- (void)dealloc
{
   [self stopTimer];
}

- (void)fireOneShot
{
   if ([self stopTimer]) [self startRepeatTimer:0.09];
}

- (void)startRepeatTimer:(double)repeatTimeInSeconds
{
   [self stopRepeatTimer];
   if (_repeatKey)
   {
      if (_repeatTimer == NULL)
         _repeatTimer = [self createTimer:^{[self fireKeyRepeat];}];
      
      assert(_repeatTimer != NULL);
      dispatch_source_set_timer(_repeatTimer,
                                dispatch_walltime(NULL, 0),
                                repeatTimeInSeconds * NSEC_PER_SEC,
                                0.010 * NSEC_PER_SEC);
      dispatch_resume(_repeatTimer);
   }
}

- (void)stopRepeatTimer
{
   if (_repeatTimer && 0 == dispatch_source_testcancel(_repeatTimer))
   {
      dispatch_source_cancel(_repeatTimer);
      _repeatTimer = NULL;
   }
}

- (void)fireKeyRepeat
{
   if (_repeatKey)
   {
      NSInteger currentCount = _repeatCount;
      ++_repeatCount;
      
      [_repeatKey executeActionBlock:_repeatCount];
      
      // see if we have crossed the threshold for deleting words,  when we
      // do, we'd like to slow down the timer so the user has time to react
      if (currentCount < KeyboardRepeatStartDeletingWords &&
          _repeatCount >= KeyboardRepeatStartDeletingWords)
      {
         [self stopRepeatTimer];
         [self startRepeatTimer:0.50];
      }
   }
}

- (dispatch_source_t)createTimer:(dispatch_block_t)block
{
   dispatch_source_t timer =
   dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,
                          dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
   if (timer)
   {
      dispatch_source_set_event_handler(timer, block);
   }
   
   return timer;
}

- (void)startTimer:(KeyView*)repeatKey
{
   _repeatKey = repeatKey;
   _repeatCount = 1;
   
   [self stopTimer];
   
   if (_repeatKey)
   {
      if (_oneShotTimer == NULL)
         _oneShotTimer = [self createTimer:^{[self fireOneShot];}];
      
      assert(_oneShotTimer != NULL);
      dispatch_source_set_timer(_oneShotTimer,
                                dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),
                                DISPATCH_TIME_FOREVER, 0.010 * NSEC_PER_SEC);
      dispatch_resume(_oneShotTimer);
   }
}

- (BOOL)stopTimer
{
   BOOL result = false;
   if (_oneShotTimer && 0 == dispatch_source_testcancel(_oneShotTimer))
   {
      dispatch_source_cancel(_oneShotTimer);
      _oneShotTimer = NULL;
      [self stopRepeatTimer];
      result = true;
   }
   else if (_repeatTimer && 0 == dispatch_source_testcancel(_repeatTimer))
   {
      [self stopRepeatTimer];
      result = true;
   }
   
   return result;
}

- (void)startOneShotTimerWithBlock:(dispatch_block_t)block andDelay:(NSInteger)delayInMS
{
   _oneShotTimer = [self createTimer:block];
   if (_oneShotTimer)
   {
      dispatch_source_set_timer(_oneShotTimer,
                                dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC),
                                DISPATCH_TIME_FOREVER, delayInMS * NSEC_PER_SEC);
      dispatch_resume(_oneShotTimer);
   }
}

- (void)startTimerWithBlock:(dispatch_block_t)block andRepeatInterval:(NSInteger)timeInMS
{
   _repeatTimer = [self createTimer:block];
   if (_repeatTimer)
   {
      dispatch_source_set_timer(_repeatTimer,
                                dispatch_walltime(NULL, 0),
                                timeInMS * NSEC_PER_SEC,
                                timeInMS * NSEC_PER_SEC * 0.10);
      dispatch_resume(_repeatTimer);
   }
}

#pragma mark - Public
+ (KeyboardTimer *)startKeyTimer:(KeyView*)repeatKey
{
   KeyboardTimer * result = [[KeyboardTimer alloc] init];
   [result startTimer:repeatKey];
   return result;
}

+ (KeyboardTimer *)startOneShotTimerWithBlock:(dispatch_block_t)block andDelay:(NSInteger)delayInMS
{
   KeyboardTimer * result = [[KeyboardTimer alloc] init];
   [result startOneShotTimerWithBlock:block andDelay:delayInMS];
   return result;
}

+ (KeyboardTimer *)startTimerWithBlock:(dispatch_block_t)block andRepeatInterval:(NSInteger)timeInMS
{
   KeyboardTimer * result = [[KeyboardTimer alloc] init];
   [result startTimerWithBlock:block andRepeatInterval:timeInMS];
   return result;
}

- (KeyView *)keyView
{
   return _repeatKey;
}

@end
