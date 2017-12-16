//
//  NSDateFormatter+SharedInstance.m
//  App
//
//  Created by HBLab-NghiaNH on 11/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "NSDateFormatter+SharedInstance.h"

@implementation NSDateFormatter (SharedInstance)
+ (NSDateFormatter*)sharedInstance {
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    return formatter;
}
@end
