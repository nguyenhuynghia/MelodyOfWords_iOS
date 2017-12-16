//
//  ImageEntity.h
//  App
//
//  Created by HBLab-NghiaNH on 7/19/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "BaseEntity.h"

typedef enum : NSUInteger {
    ImageSizeTypeOrigin,
    ImageSizeTypeThumb,
    ImageSizeTypeLarge
} ImageSizeType;

#define _IMAGE_SIZE_THUMB  @"thumb"
#define _IMAGE_SIZE_LARGE  @"large"
#define _IMAGE_SIZE_ORIGIN @"origin"

@interface FileEntity : BaseEntity
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *errorMsg;
@end
