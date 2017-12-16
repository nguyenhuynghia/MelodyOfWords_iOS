//
//  Requester.h
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorCodes.h"
#import "BaseEntity.h"
#import "Macros.h"

// success: NO - network error, server not response...
typedef void(^ServerResponseHandler) (BOOL success, BaseEntity *response);

@interface Requester : NSObject

@property BOOL bgCalling; // Don't start from a user action (Ex: don't show user message in this case)

- (void)sendGETRequestWithURL:(NSString*)urlStr parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken;

- (void)sendPOSTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken;

- (void)sendPUTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken;

- (void)sendPOSTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters andImgData:(NSData*)imgData responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken;

- (void)sendDELETERequestWithURL:(NSString*)urlStr parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken;

- (void)sendDELETERequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken;

- (void)uploadImageWithUrl:(NSString *)urlStr image:(UIImage *)image parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler;
- (void)uploadImageWithUrl:(NSString *)urlStr image:(UIImage *)image name:(NSString *)name parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler;
@end

