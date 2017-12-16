//
//  NSDictionary+GSetter.h
//  App
//
//  Created by HBLab-NghiaNH on 6/6/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (GSetter)

- (id) nullSafeForKey: (id) aKey;
- (id) safeObjectForKey:(id)key;
- (NSDate*)dateForKey:(id)aKey;
- (NSURL*)urlForKey:(id)aKey;
- (NSDictionary *) dictionaryForKey:(id)aKey;

- (NSNumber *) numberForKey:(id)aKey;
- (NSNumber *) numberFromStringForKey:(id)aKey;

- (BOOL) boolForKey: (id)aKey;
- (BOOL) boolFromStringForKey: (id)aKey;

- (double) doubleForKey: (NSString *) key;

- (CGFloat) floatForKey: (id)aKey;
- (CGFloat) floatFromStringForKey: (id)aKey;

- (NSInteger) integerForKey: (id)aKey;
- (NSInteger) integerFromStringForKey: (id)aKey;

@end


@interface NSMutableDictionary (SCUtility)
//if obj is nill or @"" it will do nothing
- (void)safeSetObject:(id)obj forKey:(id)aKey;
- (void)safeSetValue:(id)value forKey:(NSString*)key;
- (void)setObjectNilSafe:(id)obj forKey:(id)aKey;

- (void) setBool: (BOOL) boolean forKey: (id)aKey;
- (void) setInteger: (NSInteger) integer forKey: (id)aKey;
- (void) setFloat: (CGFloat) value forKey: (id)aKey;
- (void) setLong: (long) value forKey: (id)aKey;
- (void) setDouble: (double) value forKey: (id)aKey;
@end

