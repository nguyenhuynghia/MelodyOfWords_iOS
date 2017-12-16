//
//  CommonErrorProcessor.h
//  App
//
//  Created by HBLab-NghiaNH on 6/6/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonErrorProcessor : NSObject
+ (CommonErrorProcessor*)sharedInstance;

// check and process if has common errors
// Return: YES - has common error, NO = don't have common error
- (BOOL)process:(id)error;
@end
