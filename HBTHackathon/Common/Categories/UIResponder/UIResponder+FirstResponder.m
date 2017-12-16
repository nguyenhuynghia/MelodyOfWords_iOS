//
//  UIResponder+FirstResponder.m
//  App
//
//  Created by Huy Nghia Nguyen on 6/11/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static __weak id currentFirstResponder;

@implementation UIResponder (FirstResponder)

+(id)currentFirstResponder {
    
    currentFirstResponder = nil;
    
    [[UIApplication sharedApplication] sendAction:@selector(findFirstResponder:) to:nil from:nil forEvent:nil];
    
    return currentFirstResponder;
}

-(void)findFirstResponder:(id)sender {
    
    currentFirstResponder = self;
}

@end
