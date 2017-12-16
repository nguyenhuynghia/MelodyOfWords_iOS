//
//  UIStoryboard+Main.m
//  App
//
//  Created by HBLab-NghiaNH on 6/6/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "UIStoryboard+Main.h"
UIStoryboard *_mainStoryboard = nil;

@implementation UIStoryboard (Main)
+ (instancetype)mainStoryboard {
    if (!_mainStoryboard) {
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *storyboardName = [bundle objectForInfoDictionaryKey:@"UIMainStoryboardFile"];
        _mainStoryboard = [UIStoryboard storyboardWithName:storyboardName bundle:bundle];
    }
    return _mainStoryboard;
}
@end
