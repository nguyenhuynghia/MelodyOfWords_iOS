//
//  SpacebarKeyController.m
//  SoundBoard
//
//  Created by Klein, Greg on 1/23/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "SpacebarKeyController.h"
#import "TextDocumentProxyManager.h"
#import "KeyboardModeTransitioner.h"
#import "KeyView.h"

@interface SpacebarKeyController ()
@property (nonatomic) KeyView* spacebarKeyView;
@property (nonatomic) CAShapeLayer* spacebarIconLayer;
@end

@implementation SpacebarKeyController

#pragma mark - Setup
- (void)setupKeyViews
{
   self.spacebarKeyView = [KeyView viewWithText:@" " keyType:KeyTypeFunctional];
   [self.spacebarKeyView setActionBlock:^(NSInteger repeatCount)
    {
       if (repeatCount == -1)
          if ([TextDocumentProxyManager insertPeriodPriorToWhitespace])
             return;
       
       [TextDocumentProxyManager insertSpace];
       [KeyboardModeTransitioner giveSpacebarInput];
    }];
   
   self.keyViewArray = @[self.spacebarKeyView];
   [self.view addSubview:self.spacebarKeyView];

   self.spacebarIconLayer = [CAShapeLayer layer];
   self.spacebarIconLayer.lineWidth = 2;
   self.spacebarIconLayer.strokeColor = [UIColor whiteColor].CGColor;
   self.spacebarIconLayer.fillColor = [UIColor clearColor].CGColor;
   self.spacebarIconLayer.lineCap = kCALineCapRound;

   [self.view.layer addSublayer:self.spacebarIconLayer];
}

#pragma mark - Update
- (void)updateSpacebarIconLayerWithFrame:(CGRect)frame
{
   CGFloat maxX = CGRectGetMaxX(frame);
   CGFloat maxY = CGRectGetMaxY(frame);

   CGMutablePathRef keyPath = CGPathCreateMutable();

   CGPathMoveToPoint(keyPath, nil, maxX * .25f, maxY * .45f);
   CGPathAddLineToPoint(keyPath, nil, maxX * .25f, maxY * .55f);
   CGPathAddLineToPoint(keyPath, nil, maxX * .75f, maxY * .55f);
   CGPathAddLineToPoint(keyPath, nil, maxX * .75f, maxY * .45f);

   self.spacebarIconLayer.path = keyPath;
   CGPathRelease(keyPath);
}

#pragma mark - Public
- (KeyView*)keyViewForMode:(KeyboardMode)mode
{
   return self.spacebarKeyView;
}

- (void)updateFrame:(CGRect)frame
{
   [super updateFrame:frame];
   [self updateSpacebarIconLayerWithFrame:self.view.bounds];
}

@end
