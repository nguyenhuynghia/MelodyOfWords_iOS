//
//  NSArray+Interation.m
//  App
//
//  Created by HBLab-NghiaNH on 6/6/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "NSArray+Interation.h"

@implementation NSArray (Interation)
- (id) safeObjectAtIndex:(NSInteger)index{
    if (index < [self count]) {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSInteger)safIndexOfObject:(id)obj {
    if ([self containsObject:obj]) {
        return [self indexOfObject:obj];
    }
    return NSNotFound;
}
@end
