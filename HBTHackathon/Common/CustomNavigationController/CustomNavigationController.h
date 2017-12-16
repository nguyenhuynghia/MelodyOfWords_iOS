//
//  CustomNavigationController.h
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#define BTN_TAG_DEFAULT_BACK_BTN    1548

@interface CustomNavigationController : UINavigationController<UINavigationControllerDelegate>

@property (nonatomic, assign) BOOL dontAllowPopToRoot;
@property (nonatomic, assign) BOOL allowShowMenu;

+ (void)customAppearanceForNavi:(UINavigationBar*)navi;

// Show default left button, it is back button
- (void)showDefaultLeftBtn;

// Show default right button, it is side-menu button
- (void)showDefaultRightBtn;

// Add left custom button to navigation with inputted image
- (void)addLeftBtnWithImg:(UIImage*)img target:(id)target action:(SEL)action;
- (void)addBackButtonWithTarget:(id)target action:(SEL)action;

// Add right custom button to navigation with inputted image
- (void)addRightBtnWithImg:(UIImage*)img target:(id)target action:(SEL)action;
- (void)addRightBtnWithImg:(UIImage*)img toLeftOrRightOfDefaultBtn:(BOOL)leftOrRight target:(id)target action:(SEL)action;

// Add multi-buttons to navigation
// Params:
// + btnContent: array of content of button, from left to right, each element of array is text or image (NSString or UIImage)
// + actions: array of actions corresponding with each button, each element of array is NSValue object (type is pointer) or NSNull (Ex:[NSValue valueWithPointer:@selector(xxx)])
// Return: array of buttons in same order with btnContent
- (NSArray*)addMultiBtns:(NSArray*)btnContent leftOrRight:(BOOL)leftOrRight target:(id)target actions:(NSArray*)actions;

// Add left custom button to navigation with inputted text (background of button is fixed in a specific style)
- (void)addLeftBtnWithText:(NSString*)text target:(id)target action:(SEL)action;
// Add right custom button to navigation with inputted text (background of button is fixed in a specific style)
- (UIBarButtonItem *)addRightBtnWithText:(NSString*)text target:(id)target action:(SEL)action;
// BinhNT
- (void)addLeftButtonWithImage:(UIImage*)img target:(id)target action:(SEL)action;

- (UIBarButtonItem *)addRightBtnWithText:(NSString*)text toLeftOrRightOfDefaultBtn:(BOOL)leftOrRight target:(id)target action:(SEL)action;

// Add left custom button with a custom view
- (void)addLeftBtnWithView:(UIView*)v;
// Add right custom button with a custom view
- (void)addRightBtnWithView:(UIView*)v;

// Hide custom back button
- (void)hideBackButton;
// Show custom back button
- (void)showBackButton;
// Hide custom side menu button
- (void) hideSideMenuButton;

- (void)defaultRightBtnTouched;
// Added by ThaiTB
- (void)updateEnableStateOfLeftButton:(BOOL)isEnable;
- (void)updateEnableStateOfRightButton:(BOOL)isEnable;
- (void)updateEnableStateOfAllRightButtons:(BOOL)isEnable;
- (void)updateTitleToRightButton:(NSString *)newTitle;

//Add by LongNH
- (void) enableOrDisableButtonBarItem:(BOOL) isEnable;

// Get list of a kind of view controller in navigation stack
// Return: nil - if not exist
- (NSArray*)listVCInStackOfClass:(Class)c;
// Bring a child view controller from back (not on top) and push to top
- (void)pushBackChildToTop:(UIViewController*)backChild animated:(BOOL)animated;

// Push a VC and callback when finish
- (void)pusVC:(UIViewController*)vc animated:(BOOL)animated completeHandler:(void(^)(id vcDidPush))completeHandler;
// Push a VC and remove another (which one already in the stack)
- (void)pushVC:(UIViewController*)vc andRemoveVC:(UIViewController*)removeVC animated:(BOOL)animated;
// Push a VC and remove other except root VC (for free resouce purpose)
- (void)pushVC:(UIViewController *)vc andRemoveAllOtherExcept:(UIViewController *)exceptVC animated:(BOOL)animated;

- (void)naviWillPopToMe;

- (void)showDefaultRightBtn:(SEL)defaultTouched;
@end
