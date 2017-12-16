//
//  UIResponder+FirstResponder.h
//  App
//
//  Created by Huy Nghia Nguyen on 6/11/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (FirstResponder)
+(id)currentFirstResponder;
-(void)findFirstResponder:(id)sender;
@end
