//
//  KeyboardAuxilaryController.m
//  SoundBoard
//
//  Created by Gregory Klein on 1/22/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyboardAuxiliaryController.h"
#import "KeyboardKeyFrameTextMap.h"
#import "KeyboardKeysController.h"
#import "AutocorrectKeyController.h"
#import "AutocorrectKeyManager.h"

@interface KeyboardAuxiliaryController ()
@property (nonatomic) AutocorrectKeyController* leftAutocorrectController;
@property (nonatomic) AutocorrectKeyController* centerAutocorrectController;
@property (nonatomic) AutocorrectKeyController* rightAutocorrectController;
@end

@implementation KeyboardAuxiliaryController

#pragma mark - Init
- (instancetype)init
{
   if (self = [super init])
   {
      self.view.backgroundColor = [UIColor colorWithRed:43/255.f green:44/255.f blue:48/255.f alpha:1];

      [self setupAutocorectControllers];
      [self addControllersToAutocorrectKeyManager];
   }
   return self;
}

#pragma mark - Class Init
+ (instancetype)controller
{
   return [[KeyboardAuxiliaryController alloc] init];
}

#pragma mark - Setup
- (void)setupAutocorectControllers
{
   self.leftAutocorrectController = [AutocorrectKeyController controller];
   self.centerAutocorrectController = [AutocorrectKeyController controller];
   self.rightAutocorrectController = [AutocorrectKeyController controller];

   [self.view addSubview:self.leftAutocorrectController.view];
   [self.view addSubview:self.centerAutocorrectController.view];
   [self.view addSubview:self.rightAutocorrectController.view];
}

- (void)addControllersToAutocorrectKeyManager
{
   AutocorrectKeyManager* manager = [AutocorrectKeyManager sharedManager];

   [manager setAutocorrectKeyController:self.centerAutocorrectController withPriority:AutocorrectControllerPrimary];
   [manager setAutocorrectKeyController:self.leftAutocorrectController withPriority:AutocorrectControllerSecondary];
   [manager setAutocorrectKeyController:self.rightAutocorrectController withPriority:AutocorrectControllerTertiary];
}

#pragma mark - Lifecycle
- (void)viewDidLayoutSubviews
{
   CGRect centerLabelViewFrame = CGRectMake(CGRectGetWidth(self.view.bounds)*.3333f - 4,
                                            0,
                                            CGRectGetWidth(self.view.bounds)*.3333f + 8,
                                            CGRectGetHeight(self.view.bounds));
   
   CGRect leftLabelViewFrame = CGRectMake(0, 0, CGRectGetMinX(centerLabelViewFrame), CGRectGetHeight(self.view.bounds));
   
   CGRect rightLabelViewFrame = CGRectMake(CGRectGetMaxX(centerLabelViewFrame),
                                           0,
                                           CGRectGetWidth(self.view.bounds) - CGRectGetMaxX(centerLabelViewFrame),
                                           CGRectGetHeight(self.view.bounds));
   
   [self.leftAutocorrectController updateFrame:leftLabelViewFrame];
   [self.centerAutocorrectController updateFrame:centerLabelViewFrame];
   [self.rightAutocorrectController updateFrame:rightLabelViewFrame];

   KeyboardKeyFrameTextMap* map = [KeyboardKeyFrameTextMap map];
   [map updateFrameForKeyView:(KeyView*)self.leftAutocorrectController.view];
   [map updateFrameForKeyView:(KeyView*)self.centerAutocorrectController.view];
   [map updateFrameForKeyView:(KeyView*)self.rightAutocorrectController.view];

   [self.keyboardMapUpdater updateKeyboardKeyFrameTextMap:map];
}

@end
