//
//  NSDictionary+GSetter.m
//  App
//
//  Created by HBLab-NghiaNH on 6/6/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "NSDictionary+GSetter.h"

@implementation NSDictionary (GSetter)

- (id)safeObjectForKey:(id)key{
    if ([[self allKeys] containsObject:key]) {
        return [self objectForKey:key];
    }
    return nil;
}

- (id) nullSafeForKey: (id) aKey {
    id obj = [self objectForKey:aKey];
    if(obj == [NSNull null]) {
        return nil;
    }
    
    // our servers will return <null> instead of an actual JSON null, so deal with this here
    if([obj isKindOfClass: NSString.class] && [(NSString *) obj isEqualToString: @"<null>"]) {
        return nil;
    }
    
    return obj;
}

- (NSDictionary *) dictionaryForKey:(id)aKey {
    id obj = [self nullSafeForKey:aKey];
    if (obj==nil || ![obj isKindOfClass: NSDictionary.class]) {
        return nil;
    }
    
    return (NSDictionary *) obj;
}

// Return an UTC date
- (NSDate*) dateForKey:(id)aKey {
    id obj = [self nullSafeForKey:aKey];
    if (obj==nil || ![obj isKindOfClass: NSString.class]) {
        return nil;
    }
    
    NSString *dateString = (NSString*)obj;
    
    NSDateFormatter* formatterUtc = [NSDateFormatter sharedInstance];
    [formatterUtc setDateFormat:COMMON_DATETIME_FORMAT];
    [formatterUtc setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    // Cast the input string to NSDate
    NSDate* utcDate = [formatterUtc dateFromString:dateString];
    
    return utcDate;
}

- (NSURL*)urlForKey:(id)aKey {
    id obj = [self nullSafeForKey:aKey];
    if (obj == nil || ![obj isKindOfClass: NSString.class]) {
        return nil;
    }
    return [NSURL URLWithString:obj];
}

- (NSNumber *) numberForKey:(id)aKey {
    /*
     //new sollution, but need to test more
     id value = [self nullSafeForKey: aKey];
     if(value == nil || ![value isKindOfClass: NSNumber.class]) {
     return nil;
     }
     
     return (NSNumber *) value;
     */
    
    //old solution from aDuc
    NSString* value = [self safeObjectForKey:aKey];
    if (value && ![value isKindOfClass:[NSNull class]]) {
        return [NSNumber numberWithInteger:[value integerValue]];
    }
    return [NSNumber numberWithInt:0];
}

- (NSNumber *) numberFromStringForKey:(id)aKey {
    id value = [self nullSafeForKey: aKey];
    if(value == nil) {
        return nil;
    }
    
    if([value isKindOfClass: NSNumber.class]) {
        return (NSNumber *) value;
    }
    
    if(![value isKindOfClass: NSString.class]) {
        return nil;
    }
    
    return [NSNumber numberWithInteger:[value integerValue]];
}

- (BOOL) boolForKey: (id)aKey {
    id value = [self numberForKey: aKey];
    return value == nil ? NO :[(NSNumber *) value boolValue];
}

- (BOOL) boolFromStringForKey: (id)aKey {
    id value = [self numberFromStringForKey: aKey];
    return value == nil ? NO :[(NSNumber *) value boolValue];
}

- (CGFloat) floatForKey: (id)aKey {
    id value = [self numberForKey: aKey];
    return value == nil ? 0.0f :[(NSNumber *) value floatValue];
}

- (double) doubleForKey: (NSString *) key {
    id value = [self numberForKey: key];
    return value == nil ? 0.0f :[(NSNumber *) value doubleValue];
}

- (CGFloat) floatFromStringForKey:(id)aKey {
    id value = [self numberFromStringForKey: aKey];
    return value == nil ? NO :[(NSNumber *) value floatValue];
}

- (NSInteger) integerForKey: (id)aKey {
    id value = [self numberForKey: aKey];
    return value == nil ? NO :[(NSNumber *) value integerValue];
}

- (NSInteger) integerFromStringForKey: (id)aKey {
    id value = [self numberFromStringForKey: aKey];
    return value == nil ? NO :[(NSNumber *) value integerValue];
}

@end


@implementation NSMutableDictionary (SCUtility)

- (void) setBool: (BOOL) boolean forKey: (id)aKey {
    NSNumber *number = [NSNumber numberWithBool: boolean];
    [self safeSetObject: number forKey: aKey];
}

- (void) setInteger: (NSInteger) integer forKey: (id)aKey {
    NSNumber *number = [NSNumber numberWithInteger: integer];
    [self safeSetObject: number forKey: aKey];
}

- (void) setFloat: (CGFloat) value forKey: (id)aKey {
    NSNumber *number = [NSNumber numberWithFloat:value];
    [self safeSetObject: number forKey: aKey];
}

- (void) setLong: (long) value forKey: (id)aKey {
    NSNumber *number = [NSNumber numberWithLong: value];
    [self safeSetObject: number forKey: aKey];
}

- (void) setDouble: (double) value forKey: (id)aKey {
    NSNumber *number = [NSNumber numberWithDouble:value];
    [self safeSetObject: number forKey: aKey];
}

- (void)safeSetObject:(id)obj forKey:(id)aKey {
    [self setObjectNilSafe: obj forKey: aKey];
}

- (void)safeSetValue:(id)value forKey:(NSString*)key
{
    if (value == nil) {
        [self setValue:[NSNull null] forKey:key];
    } else {
        [self setValue:value forKey:key];
    }
}



- (void)setObjectNilSafe:(id)obj forKey:(id)aKey {
    // skip nils and NSNull
    if(obj == nil || obj == [NSNull null]) {
        return;
    }
    
    // skip empty string
    if([obj isKindOfClass: NSString.class] && [obj length]==0) {
        return;
    }
    
    [self setObject:obj forKey:aKey];
}
@end
