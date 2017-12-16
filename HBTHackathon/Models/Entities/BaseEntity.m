//
//  BaseEntity.m
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "BaseEntity.h"
#import "ErrorCodes.h"

@implementation BaseEntity
- (void)parseResponse:(NSDictionary*)response {    
    self.responseDict = [response copy];
    
    id tmp = [response safeObjectForKey:@"status"];
    if (tmp && [tmp isKindOfClass:[NSNumber class]]) {
        self.srvCode = [tmp integerValue];
    }
    
    tmp = [response safeObjectForKey:@"success"];
    if (tmp && [tmp isKindOfClass:[NSNumber class]]) {
        self.isSuccess = [tmp boolValue];
    }

    tmp = [response safeObjectForKey:@"message"];
    if (tmp && [tmp isKindOfClass:[NSString class]]) {
        self.message = tmp;
    }
    
    tmp = [response safeObjectForKey:@"name"];
    if (tmp && [tmp isKindOfClass:[NSString class]]) {
        self.errorName = tmp;
    }
    
    id dataDict = [response safeObjectForKey:@"data"];
    if (dataDict && [dataDict isKindOfClass:[NSDictionary class]]) {
        self.meta = [response safeObjectForKey:@"meta"];
    }
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        
    }
    return self;
}

- (BOOL)shouldLogout  {
    BOOL shouldLogout = NO;
    if (self.srvCode == _ERROR_CODE_UNAUTHORIZED || self.srvCode == _ERROR_CODE_FORBIDDEN) {
        shouldLogout = YES;
    }
    return shouldLogout;
}

- (NSDictionary *)infoDict {
    NSMutableDictionary *infoDict = [NSMutableDictionary new];
    return infoDict;
}

@end
