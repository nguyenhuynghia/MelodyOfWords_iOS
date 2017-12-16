//
//  KeyboardViewController.m
//  CustomKeyboard
//
//  Created by Gregory Klein on 1/17/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import "KeyboardViewController.h"
#import "KeyboardAuxiliaryController.h"
#import "KeyboardKeysController.h"
#import "KeyboardTouchEventHandler.h"
#import "TextDocumentProxyManager.h"
#import "KeyboardModeManager.h"
#import "KeyboardModeTransitioner.h"
#import "SpellCorrectorBridge.h"

static const CGFloat s_auxViewHeightPercentage = .0f;
static const NSUInteger s_portraitHeight = 215;
static const NSUInteger s_landscapeHeight = 215;

@interface KeyboardViewController () <KeyboardModeUpdater>

@property (nonatomic) KeyboardAuxiliaryController* auxController;
@property (nonatomic) KeyboardKeysController* keysController;
@property (nonatomic) KeyboardTouchEventHandler* touchEventHandler;

@property (nonatomic) NSLayoutConstraint* heightConstraint;
@property (nonatomic) BOOL isLandscape;

@end

@implementation KeyboardViewController

#pragma mark - Init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
        [SpellCorrectorBridge load];
        
        [TextDocumentProxyManager setTextDocumentProxy:self.textDocumentProxy];
        [KeyboardModeManager setKeyboardModeUpdater:self];
        
        [KeyboardModeManager updateKeyboardShiftMode:ShiftModeApplied];
        [KeyboardModeManager updateKeyboardMode:KeyboardModeLetters];
        
        [KeyboardModeTransitioner disableRequestsWhileInMode:KeyboardModeLetters];
        [KeyboardModeTransitioner setCharacterArray:@[@"'"] forImmediateTransitionToMode:KeyboardModeLetters];
    }
    return self;
}

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupControllers];
    [self setupTouchEventHandler];
    
    // This is currently a hack: we need at least one view that uses autolayout in our view heirarchy in order to adjust the
    // height constraint of this view controller's view, so we're adding a dummy view with autolayout constraints
    [self setupAutolayoutView];
    
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.inputView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:0.0
                                                          constant:s_portraitHeight];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect viewFrame = self.inputView.frame;
    if (CGRectGetWidth(viewFrame) != 0 && CGRectGetHeight(viewFrame) != 0)
    {
        [self.inputView removeConstraint:self.heightConstraint];
        
        CGFloat height = self.isLandscape ? s_landscapeHeight : s_portraitHeight;
        self.heightConstraint.constant = height;
        
        [self.inputView addConstraint:self.heightConstraint];
        [self updateControllerViewFrames];
    }
}

#pragma mark - Setup
- (void)setupAutolayoutView
{
    UIView* autolayoutView = [[UIView alloc] init];
    autolayoutView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary* views = NSDictionaryOfVariableBindings(autolayoutView);
    
    [self.inputView insertSubview:autolayoutView belowSubview:self.auxController.view];
    NSArray* horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|[autolayoutView]|" options:0 metrics:nil views:views];
    NSArray* verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[autolayoutView]|" options:0 metrics:nil views:views];
    
    [self.inputView addConstraints:horizontalConstraints];
    [self.inputView addConstraints:verticalConstraints];
}

- (void)setupControllers
{
    self.auxController = [KeyboardAuxiliaryController controller];
    [self.inputView addSubview:self.auxController.view];
    
    self.keysController = [KeyboardKeysController controllerWithMode:[KeyboardModeManager currentMode]];
    [self.inputView addSubview:self.keysController.view];
}

- (void)setupTouchEventHandler
{
    self.touchEventHandler = [KeyboardTouchEventHandler handler];
    
    [self.inputView addSubview:self.touchEventHandler.view];
    self.keysController.keyboardMapUpdater = self.touchEventHandler;
    self.auxController.keyboardMapUpdater = self.touchEventHandler;
}

#pragma mark - Update
- (void)updateControllerViewFrames
{
    [self updateAuxViewFrame];
    [self updateKeysViewFrame];
    self.touchEventHandler.view.frame = self.inputView.frame;
}

- (void)updateAuxViewFrame
{
    NSUInteger containerViewHeight = self.heightConstraint.constant*s_auxViewHeightPercentage;
    self.auxController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.inputView.bounds), containerViewHeight);
}

- (void)updateKeysViewFrame
{
    CGFloat keysViewHeight = self.heightConstraint.constant - CGRectGetHeight(self.auxController.view.bounds);
    CGFloat keysViewYPosition = CGRectGetMaxY(self.auxController.view.bounds);
    self.keysController.view.frame = CGRectMake(0, keysViewYPosition, CGRectGetWidth(self.inputView.bounds), keysViewHeight);
}

#pragma mark - Property Overrides
- (BOOL)isLandscape
{
    CGRect viewFrame = self.inputView.frame;
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGFloat screenH = CGRectGetHeight(screenFrame);
    CGFloat screenW = CGRectGetWidth(screenFrame);
    return !(CGRectGetWidth(viewFrame) == (screenW*(screenW<screenH))+(screenH*(screenW>screenH)));
}

#pragma mark - UITextInput Delegate
- (void)textWillChange:(id<UITextInput>)textInput
{
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput
{
    NSString* text = self.textDocumentProxy.documentContextBeforeInput;
    if (text.length == 0)
    {
        [KeyboardModeManager updateKeyboardShiftMode:ShiftModeApplied];
    }
}

#pragma mark - Keyboard Mode Updater
- (void)updateKeyboardMode:(KeyboardMode)mode
{
    [self.keysController updateMode:mode];
}

- (void)updateKeyboardShiftMode:(KeyboardShiftMode)shiftMode
{
    [self.keysController updateShiftMode:shiftMode];
}

- (void)advanceToNextKeyboard
{
    [self advanceToNextInputMode];
}

@end
