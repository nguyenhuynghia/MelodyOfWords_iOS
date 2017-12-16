//
//  Macros.h
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#ifndef Macros_h
#define Macros_h

#define	SAFE_RELEASE(ptr)	{if(ptr!=nil){if ([ptr respondsToSelector:@selector(setDelegate:)]) {[ptr performSelector:@selector(setDelegate:) withObject:nil];}[ptr release];ptr=nil;}}
#define	SAFE_RELEASE_BLOCK(bl)	{if(bl!=nil){Block_release(bl);bl=nil;}}
#ifndef SAFE_CF_RELEASE
#define	SAFE_CF_RELEASE(ptr)	{if(ptr!=nil){CFRelease(ptr);ptr=nil;}}
#endif
#define APP_DELEGATE [AppDelegate sharedInstance]
#define CUSTOM_NAVIGATION ((CustomNavigationController*)self.navigationController)
#define USER_DEFAULT_STANDARD [NSUserDefaults standardUserDefaults]

#ifdef DEBUG_MODE
#define DLog(level, f, ...)
#else
#define DLog(level, f, ...) [Logger writeLogWithLevel:level format:f, ## __VA_ARGS__]
#endif

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_4_INCH_SCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_3_5_INCH_SCREEN (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_OS_9_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0f)
#define MESSAGE_NOT_EMPTY(message) (message.length > 0 ? 1 : 0)

#define SAFE_PERFORM_SELECTOR(target,selector) {if(target!=nil&&selector!=nil&&[target respondsToSelector:selector]){[target performSelector:selector];}}
#define SAFE_PERFORM_SELECTOR_WITH_OBJECT(target,selector,obj) {if(target!=nil&&selector!=nil&&[target respondsToSelector:selector]){[target performSelector:selector withObject:obj];}}
#define SAFE_PERFORM_SELECTOR_WITH_2OBJECT(target,selector,obj1,obj2) {if(target!=nil&&selector!=nil&&[target respondsToSelector:selector]){[target performSelector:selector withObject:obj1 withObject:obj2];}}

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGB(r, g, b)		[UIColor colorWithRed:(CGFloat)r/255.0 green:(CGFloat)g/255.0 blue:(CGFloat)b/255.0 alpha:1.0]

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6_PLUS (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define DEVICE_NAME ([[UIDevice currentDevice] name])

#define FONT_ICIEL_CADENA(sz)   [UIFont fontWithName:@"iCielCadena" size:(sz * [Utils deviceSizeScale])]
#define FONT_UTM_AVO_BOLD(sz)   [UIFont fontWithName:@"UTMAvoBold" size:(sz * [Utils deviceSizeScale])]
#define FONT_UTM_AVO(sz)        [UIFont fontWithName:@"UTM-Avo" size:(sz * [Utils deviceSizeScale])]

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

#define VIEW_X(view) view.frame.origin.x
#define VIEW_XW(view) view.frame.origin.x+view.frame.size.width
#define VIEW_Y(view) view.frame.origin.y
#define VIEW_YH(view) view.frame.origin.y+view.frame.size.height
#define VIEW_W(view) view.frame.size.width
#define VIEW_H(view) view.frame.size.height
#define BOUND_SCALED(bound) CGRectMake(0,0,bound.size.width*[Utils deviceSizeScale],bound.size.height*[Utils deviceSizeScale])

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#endif /* Macros_h */
