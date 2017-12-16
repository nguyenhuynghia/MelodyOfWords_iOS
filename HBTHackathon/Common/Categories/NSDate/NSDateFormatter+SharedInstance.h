//
//  NSDateFormatter+SharedInstance.h
//  App
//
//  Created by HBLab-NghiaNH on 11/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (SharedInstance)
+ (NSDateFormatter*)sharedInstance;
@end
