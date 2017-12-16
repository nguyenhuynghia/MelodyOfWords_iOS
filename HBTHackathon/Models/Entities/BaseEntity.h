//
//  BaseEntity.h
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseEntity : NSObject
@property (nonatomic, assign) NSInteger srvCode;
@property (nonatomic, strong) NSDictionary *responseDict;
@property (nonatomic, strong) NSDictionary *meta;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *errorName;

- (void)parseResponse:(NSDictionary *)response;
- (BOOL)shouldLogout;
- (NSDictionary *)infoDict;
@end
