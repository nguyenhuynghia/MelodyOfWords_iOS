//
//  ReturnKeyController.m
//  SoundBoard
//
//  Created by Klein, Greg on 1/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "ReturnKeyController.h"
#import "TextDocumentProxyManager.h"
#import "KeyView.h"

@interface ReturnKeyController ()
@property (nonatomic) KeyView* returnKeyView;
@end

@implementation ReturnKeyController

#pragma mark - Setup
- (void)setupKeyViews
{
   self.returnKeyView = [KeyView viewWithText:@"return" keyType:KeyTypeFunctional];
   [self.returnKeyView setActionBlock:^(NSInteger repeatCount)
   {
      [TextDocumentProxyManager insertText:@"\n"];
   }];
   
   self.keyViewArray = @[self.returnKeyView];
   [self.view addSubview:self.returnKeyView];
}

#pragma mark - Public
- (KeyView*)keyViewForMode:(KeyboardMode)mode
{
   return self.returnKeyView;
}

@end
