//
//  Service.h
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Requester.h"
#import "BaseEntity.h"
#import "Names.h"
#import "FileEntity.h"

@interface Service : NSObject
- (void)getMidiFileWithPrimer:(NSArray *)primer completeHandle: (ServerResponseHandler)completion;
@end
