//
//  AutocorrectKeyController.m
//  SoundBoard
//
//  Created by Gregory Klein on 3/7/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "AutocorrectKeyController.h"
#import "KeyView.h"
#import "ThemeAttributesProvider.h"
#import "TextDocumentProxyManager.h"

@interface AutocorrectKeyController ()
@property (nonatomic) UILabel* textLabel;
@end

@implementation AutocorrectKeyController

#pragma mark - Init
- (instancetype)init
{
   if (self = [super init])
   {
      self.view = [KeyView viewWithText:@"" keyType:KeyTypeFunctional];

      __weak typeof(self) weakSelf = self;
      [(KeyView*)self.view setActionBlock:^(NSInteger repeatCount) {

         if (weakSelf.textLabel.text.length > 0)
         {
            NSString* text = [weakSelf.textLabel.text stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            text = [text stringByAppendingString:@" "];

            [TextDocumentProxyManager replaceCurrentWordWithText:text];
            [TextDocumentProxyManager updateShiftMode];
         }
      }];
      [self setupLabel];
   }
   return self;
}

#pragma mark - Class Init
+ (instancetype)controller
{
   return [[self alloc] init];
}

#pragma mark - Setup
- (void)setupLabel
{
   self.textLabel = [[UILabel alloc] init];

   self.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
   self.textLabel.textAlignment = NSTextAlignmentCenter;
   self.textLabel.textColor = [UIColor whiteColor];
   self.textLabel.adjustsFontSizeToFitWidth = YES;
   self.textLabel.minimumScaleFactor = .8f;

   [self.view addSubview:self.textLabel];
}

#pragma mark - Public
- (void)updateFrame:(CGRect)frame
{
   if ([self.view isKindOfClass:[KeyView class]])
   {
      KeyView* keyView = (KeyView*)self.view;
      [keyView updateFrame:frame];
   }
   self.textLabel.frame = CGRectInset(self.view.bounds, 12, 4);
}

- (void)updateText:(NSString*)text
{
   dispatch_async(dispatch_get_main_queue(), ^{
      self.textLabel.text = text;
   });
}

- (void)trigger
{
   [(KeyView*)self.view executeActionBlock:1];
}

@end
