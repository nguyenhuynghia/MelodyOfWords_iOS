//
//  CustomNavigationController.m
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//


#import "CustomNavigationController.h"

#define SIDE_MENU_BUTTON_IMAGE       @"icon_menu"
#define BACK_BUTTON_IMAGE            @"ic_navi_back_button"
#define RIGHT_BUTTON_IMAGE           @"icon_search"
#define BACKGROUND_USER_NAVIGATION   @"bg_user_navigation_normal"
#define BACKGROUND_WORKER_NAVIGATION @"bg_worker_navigation_normal"

@interface CustomNavigationController () <UINavigationControllerDelegate> {
    void (^pushCompleteHandler)(id vcDidPush);
    NSMutableArray *_viewControllersWithHiddenBottomBar;
}

@end

@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (void)customBarBtn {
    //    UIImage *barButtonImage = [[UIImage imageNamed:BACK_BUTTON_IMAGE] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    // [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *barButtonImage = nil;
    // Use appearanceWhenContainedIn: to don't apply this setting in unwanted screen (Ex: a webview)
    [[UIBarButtonItem  appearanceWhenContainedIn:[UINavigationController class], nil] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

+ (void)customAppearanceForNavi:(UINavigationBar*)navi {
    navi.barTintColor = [Utils colorWithHexString:@"fafafa"];
    navi.translucent = NO;
    navi.backgroundColor = [UIColor whiteColor];
    [navi setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
}

- (void)customAppearance {
    [CustomNavigationController customAppearanceForNavi:self.navigationBar];
    
    UIImage *backgroundImage  = [UIImage imageNamed:BACKGROUND_USER_NAVIGATION];
    UIColor *titleColor = [UIColor blackColor];

    UIImage *resizableBackground = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(21, 2, 1, 2)];
    
    [self.navigationBar setBackgroundImage:resizableBackground forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.barTintColor = [UIColor whiteColor];

    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : titleColor,
                                                           NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightBold]
                                                           }];
    
    // Use appearanceWhenContainedIn: to don't apply this setting in unwanted screen (Ex: a webview)
    [[UIBarButtonItem  appearanceWhenContainedIn:[UINavigationController class], nil] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18], NSForegroundColorAttributeName : titleColor} forState:UIControlStateNormal];
    
    // Background color when show in a popover
    [CustomNavigationController customBarBtn];
}

- (void) enableOrDisableButtonBarItem:(BOOL) isEnable {
    self.topViewController.navigationItem.leftBarButtonItem.enabled = isEnable;
    self.topViewController.navigationItem.rightBarButtonItem.enabled = isEnable;
}

- (UIBarButtonItem*)barButtonWithImage:(UIImage*)img target:(id)target action:(SEL)action{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    [btn setImage:img forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (UIBarButtonItem*)createCustomBackBtn {
    UIImage *img = [UIImage imageNamed:BACK_BUTTON_IMAGE];
    return [self barButtonWithImage:img target:self action:@selector(customBackAction)];
}

- (UIBarButtonItem*)createDefaultRightBtn {
    UIImage *img = [UIImage imageNamed:RIGHT_BUTTON_IMAGE];
    
    return [self barButtonWithImage:img target:self action:@selector(customBackAction)];
}

- (UIBarButtonItem *)makeDefaultRightBtn {
    UIBarButtonItem *barBtn = [self barButtonWithImage:[UIImage imageNamed:RIGHT_BUTTON_IMAGE] target:self action:@selector(defaultRightBtnTouched)];
    
    return barBtn;
}

- (UIBarButtonItem *)makeDefaultRightBtn:(SEL)defaultTouched {
    UIBarButtonItem *barBtn = [self barButtonWithImage:[UIImage imageNamed:RIGHT_BUTTON_IMAGE] target:self action:defaultTouched];
    
    return barBtn;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customAppearance];
    self.delegate = self;
    _viewControllersWithHiddenBottomBar = [[NSMutableArray alloc]init];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)removeViewControllerFromStack:(UIViewController*)vc{
    if (vc != nil && [vc isKindOfClass:[UIViewController class]]) {
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.viewControllers];
        if (arr.count > 1 && [arr containsObject:vc]) {
            [arr removeObject:vc];
            
            self.viewControllers = arr;
            
            return YES;
        }
    }
    
    return NO;
}

- (void)setLeftButton:(UIBarButtonItem*)barBtn {
    if (barBtn != nil) {
        if (/*(self.topViewController.supportDefaultLeft == NO) || */(barBtn.tag == BTN_TAG_DEFAULT_BACK_BTN)) {
            self.topViewController.navigationItem.leftBarButtonItem = barBtn;
        } else {
        }
    }
}

- (void)showBackButton {
    self.topViewController.navigationItem.hidesBackButton = NO;
    if (self.topViewController.supportDefaultLeft && self.allowShowMenu) {
        self.topViewController.navigationItem.leftBarButtonItem = [self makeDefaultLeftBtn];
    } else if ([self.viewControllers count] > 0) {
        self.topViewController.navigationItem.leftBarButtonItem = [self createCustomBackBtn];
    }
}

- (UIBarButtonItem*)makeDefaultLeftBtn {
    UIBarButtonItem *barBtn = [self barButtonWithImage:[UIImage imageNamed:SIDE_MENU_BUTTON_IMAGE] target:self action:@selector(defaultLeftBtnTouched)];
    barBtn.tag = BTN_TAG_DEFAULT_BACK_BTN;
    
    return barBtn;
}
#pragma mark - Dealloc
#pragma mark - Button actions
- (void)customBackAction {
    if (self.topViewController.selfHandleBackNavi) {
        SAFE_PERFORM_SELECTOR(self.topViewController, @selector(backNaviBtnTouched));
    } else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"" object:nil];
        [self popViewControllerAnimated:YES]; // Just act like default back button
    }
}


- (void)defaultLeftBtnTouched {
    //    [APP_DELEGATE.mainFrame toggleLeft];
}

- (void)defaultRightBtnTouched {
    //    [self showSearchBarController];
}

- (void)hideSearchBarController {
    [self customBackAction];
    [self showBackButton];
    self.topViewController.navigationItem.titleView = nil;
    //    if ([HVSearchManager sharedInstance].searchController.searchField &&[[HVSearchManager sharedInstance].searchController.searchField canResignFirstResponder]) {
    //        [[HVSearchManager sharedInstance].searchController.searchField resignFirstResponder];
    //    }
    [self showDefaultRightBtn];
}

#pragma mark - Override methods
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (viewController.supportDefaultLeft && self.allowShowMenu) {
        viewController.navigationItem.leftBarButtonItem = [self makeDefaultLeftBtn];
    } else if ([self.viewControllers count] > 0) {
        viewController.navigationItem.leftBarButtonItem = [self createCustomBackBtn];
    }
    if (viewController.supportDefaultRight) {
        viewController.navigationItem.rightBarButtonItem = [self makeDefaultRightBtn];
    }
    // Custom hide bottom navigator bar
    if(viewController.hidesBottomBarWhenPushed)
    {
        [_viewControllersWithHiddenBottomBar addObject:viewController];
        [self rootViewController].hidesBottomBarWhenPushed = YES;
    }
    else
    {
        [self rootViewController].hidesBottomBarWhenPushed = NO;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *) rootViewController
{
    return ((UIViewController *)self.viewControllers.firstObject);
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated{
    
    if([_viewControllersWithHiddenBottomBar containsObject:[self.viewControllers objectAtIndex:0]])
    {
        [self rootViewController].hidesBottomBarWhenPushed = YES;
    }
    else
    {
        [self rootViewController].hidesBottomBarWhenPushed = NO;
    }
    
    NSArray* array = [super popToRootViewControllerAnimated:animated];
    return array;
}

- (UIViewController*)popViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count >= 2) {
        if([_viewControllersWithHiddenBottomBar containsObject:self.viewControllers[self.viewControllers.count - 2]])
        {
            [self.viewControllers[self.viewControllers.count - 2] setHidesBottomBarWhenPushed:YES]; // Add by CanhLD
            [self rootViewController].hidesBottomBarWhenPushed = YES;
        }
        else
        {
            [self rootViewController].hidesBottomBarWhenPushed = NO;
        }
    }
    
    if (self.dontAllowPopToRoot == NO || self.viewControllers.count > 2) {
        
        UIViewController *popToVC = nil;
        
        if (self.viewControllers.count > 2) {
            popToVC = self.viewControllers[self.viewControllers.count - 2];
        }
        
        UIViewController *popped = [super popViewControllerAnimated:animated];
        
        if (popToVC != nil && [popToVC respondsToSelector:@selector(naviWillPopToMe)]) {
            // [popToVC naviWillPopToMe];
        }
        
        [_viewControllersWithHiddenBottomBar removeObject:popped];
        
        return popped;
    } else {
        return nil; // Return nothing in this case
    }
    
    return nil;
}

- (void) naviWillPopToMe {
    
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.isNavigationBarHidden != viewController.selfHideNavi) {
        [navigationController setNavigationBarHidden:viewController.selfHideNavi animated:YES];
    }
    
    if (viewController.presentingViewController == nil && navigationController.presentingViewController == nil) {
        if (viewController.hidesBottomBarWhenPushed) {
            viewController.hidesBottomBarWhenPushed = NO;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (pushCompleteHandler != nil) {
        pushCompleteHandler(viewController);
        pushCompleteHandler = nil;
    }
}

#pragma mark - Public methods
- (void)showDefaultLeftBtn {
    UIBarButtonItem *barBtn = [self makeDefaultLeftBtn];
    [self setLeftButton:barBtn];
}

- (void)showDefaultRightBtn {
    UIBarButtonItem *barBtn = [self makeDefaultRightBtn];
    self.topViewController.navigationItem.rightBarButtonItem = barBtn;
}

- (void)showDefaultRightBtn:(SEL)defaultTouched {
    UIBarButtonItem *barBtn = [self makeDefaultRightBtn:defaultTouched];
    self.topViewController.navigationItem.rightBarButtonItem = barBtn;
}

- (void)addLeftBtnWithImg:(UIImage*)img target:(id)target action:(SEL)action {
    UIBarButtonItem *barBtn = [self barButtonWithImage:img target:target action:action];
    [self setLeftButton:barBtn];
}

- (void)addBackButtonWithTarget:(id)target action:(SEL)action {
    UIBarButtonItem *barBtn = [self barButtonWithImage:[UIImage imageNamed:BACK_BUTTON_IMAGE] target:target action:action];
    barBtn.tag = BTN_TAG_DEFAULT_BACK_BTN;
    [self setLeftButton:barBtn];
}

- (void)addRightBtnWithImg:(UIImage*)img target:(id)target action:(SEL)action {
    //if ([target isKindOfClass:[UIViewController class]] == NO || target == self.topViewController) {
    UIBarButtonItem *barBtn = [self barButtonWithImage:img target:target action:action];
    self.topViewController.navigationItem.rightBarButtonItem = barBtn;
    //} else {
    // Do nothing
    //    DLog(LOG_LEVEL_INF, @"%@", @"Access to not showing VC");
    //}
}

- (void)addRightBtnWithImg:(UIImage*)img toLeftOrRightOfDefaultBtn:(BOOL)leftOrRight target:(id)target action:(SEL)action {
    UIBarButtonItem *barBtn = [self barButtonWithImage:img target:target action:action];
    NSArray *btnArr = @[barBtn];
    
    [self.topViewController.navigationItem setRightBarButtonItems:btnArr];
}

- (NSArray*)addMultiBtns:(NSArray*)btnContent leftOrRight:(BOOL)leftOrRight target:(id)target actions:(NSArray*)actions {
    if (btnContent.count > 0 && actions.count > 0 && btnContent.count == actions.count) {
        NSMutableArray *btnArr = [[NSMutableArray alloc] init];
        for (int i = (int)btnContent.count - 1; i >= 0; i--) {
            id cont = btnContent[i];
            
            SEL act = [actions[i] isKindOfClass:[NSValue class]] ? (SEL)[actions[i] pointerValue] : nil;
            
            if ([cont isKindOfClass:[UIImage class]]) {
                UIBarButtonItem *barBtn = [self barButtonWithImage:cont target:target action:act];
                
                [btnArr addObject:barBtn];
            } else if ([cont isKindOfClass:[NSString class]]) {
                UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:cont style:UIBarButtonItemStylePlain target:target action:act];
                
                [btnArr addObject:barBtn];
            }
        }
        
        if (leftOrRight == YES) {
            [self.topViewController.navigationItem setLeftBarButtonItems:btnArr];
        } else {
            [self.topViewController.navigationItem setRightBarButtonItems:btnArr];
        }
        
        return [self reversedArray:btnArr];
    } else {
        return nil;
    }
    
}

- (NSArray *)reversedArray:(NSArray*)inputArr {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[inputArr count]];
    NSEnumerator *enumerator = [inputArr reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

- (void)addLeftBtnWithText:(NSString*)text target:(id)target action:(SEL)action {
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:target action:action];
    
    [self setLeftButton:barBtn];
}

- (void)addLeftBtnWithView:(UIView*)v {
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:v];
    [self setLeftButton:barBtn];
}

- (void)addRightBtnWithView:(UIView*)v {
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:v];
    self.topViewController.navigationItem.rightBarButtonItem = barBtn;
}

- (UIBarButtonItem *)addRightBtnWithText:(NSString*)text target:(id)target action:(SEL)action {
    if ([target isKindOfClass:[UIViewController class]] == NO || target == self.topViewController) {
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:target action:action];
        self.topViewController.navigationItem.rightBarButtonItem = barBtn;
        
        return barBtn;
    } else {
        // Do nothing
        return nil;
    }
}
-(void)addLeftButtonWithImage:(UIImage*)img target:(id)target action:(SEL)action {
    if ([target isKindOfClass:[UIViewController class]] == NO || target == self.topViewController) {
        UIBarButtonItem *barBtn = [self barButtonWithImage:img target:target action:action];
        self.topViewController.navigationItem.leftBarButtonItem = barBtn;
    } else {
        // Do nothing
    }
}

- (UIBarButtonItem *)addRightBtnWithText:(NSString*)text toLeftOrRightOfDefaultBtn:(BOOL)leftOrRight target:(id)target action:(SEL)action {
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:target action:action];
    
    UIBarButtonItem *barDefaultBtn = [self createDefaultRightBtn];
    NSArray *btnArr;
    
    if (leftOrRight == YES) { // To left
        btnArr = @[barDefaultBtn, barBtn];
    } else { // To right
        btnArr = @[barBtn, barDefaultBtn];
    }
    
    [self.topViewController.navigationItem setRightBarButtonItems:btnArr];
    
    return barBtn;
}

- (void)hideBackButton {
    self.topViewController.navigationItem.leftBarButtonItem = nil;
    self.topViewController.navigationItem.hidesBackButton = YES;
}

- (void)hideSideMenuButton {
    self.topViewController.navigationItem.rightBarButtonItem = nil;
}

// Added by ThaiTB
- (void)updateEnableStateOfLeftButton:(BOOL)isEnable{
    self.topViewController.navigationItem.leftBarButtonItem.enabled = isEnable;
}

- (void)updateEnableStateOfRightButton:(BOOL)isEnable{
    self.topViewController.navigationItem.rightBarButtonItem.enabled = isEnable;
}

- (void)updateEnableStateOfAllRightButtons:(BOOL)isEnable{
    for (UIBarButtonItem *item in self.topViewController.navigationItem.rightBarButtonItems) {
        item.enabled = isEnable;
    }
}

- (void)updateTitleToRightButton:(NSString *)newTitle{
    self.topViewController.navigationItem.rightBarButtonItem.title = newTitle;
}

- (NSArray*)listVCInStackOfClass:(Class)c {
    if (self.viewControllers.count > 0) {
        NSMutableArray *result = [NSMutableArray new];
        for (id v in self.viewControllers) {
            if ([v isKindOfClass:c]) {
                [result addObject:v];
            }
        }
        return result;
    }
    
    return nil;
}

- (void)pushBackChildToTop:(UIViewController*)backChild animated:(BOOL)animated {
    if (backChild != self.topViewController) {
        
        [self removeViewControllerFromStack:backChild];
        [self pushViewController:backChild animated:animated];
        
    } else {
        // Do nothing if this top view controller
    }
}

- (void)pusVC:(UIViewController*)vc animated:(BOOL)animated completeHandler:(void(^)(id vcDidPush))completeHandler {
    [self pushViewController:vc animated:animated];
}

- (void)pushVC:(UIViewController*)vc andRemoveVC:(UIViewController*)removeVC animated:(BOOL)animated {
    [self pusVC:vc animated:animated completeHandler:^(id vcDidPush) {
        if (vcDidPush == vc) {
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.viewControllers];
            if ([arr containsObject:removeVC]) {
                [arr removeObject:removeVC];
                self.viewControllers = arr;
            }
        }
    }];
}

- (void)pushVC:(UIViewController *)vc andRemoveAllOtherExcept:(UIViewController *)exceptVC animated:(BOOL)animated {
    [self pusVC:vc animated:animated completeHandler:^(id vcDidPush) {
        if (vcDidPush == vc) {
            self.viewControllers = [NSArray arrayWithObjects:exceptVC, vc, nil];
        }
    }];
}

#pragma mark - Orientation
#pragma mark - Hande rotatation on iOS 5.1 and lower
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

// New Autorotation support.
- (BOOL)shouldAutorotate{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

// Returns interface orientation masks.
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    UIStatusBarStyle barStyle = UIStatusBarStyleDefault;
    return barStyle;
}


@end
