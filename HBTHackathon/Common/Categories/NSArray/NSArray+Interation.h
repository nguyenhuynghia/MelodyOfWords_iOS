//
//  NSArray+Interation.h
//  App
//
//  Created by HBLab-NghiaNH on 6/6/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Interation)
- (id) safeObjectAtIndex:(NSInteger)index;
- (NSInteger)safIndexOfObject:(id)obj;
@end
