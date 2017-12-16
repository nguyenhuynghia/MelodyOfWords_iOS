//
//  Requester.m
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "Requester.h"
#import "CommonErrorProcessor.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "Names.h"
#import "NSMutableDictionary+Params.h"
#import <AFNetworking/AFURLSessionManager.h>

#define _REQUESTER_TIMEOUT 180

typedef enum : NSUInteger {
    RequesterTypeGET        = 0,
    RequesterTypePOST       = 1,
    RequesterTypePUT        = 2,
    RequesterTypeDELETE_URL = 3,
    RequesterTypeDELETE_API = 4
} RequesterType;

@interface Requester () {
    AFHTTPSessionManager *requestOperationManager;
    AFHTTPSessionManager *requestOperationManagerLogin;
    AFHTTPSessionManager *requestOperationManagerAgain;
    
    NSOperation *requestOpr;
    
    BOOL isCancelling;
    
    BOOL isTokenExpired;
}

@end

@implementation Requester
- (id)init {
    if (self = [super init]) {
        
        NSSet *typeSet = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
        
        requestOperationManager = [AFHTTPSessionManager manager];
        requestOperationManager.requestSerializer.timeoutInterval = _REQUESTER_TIMEOUT;
        requestOperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        requestOperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        requestOperationManager.responseSerializer.acceptableContentTypes = typeSet;
        [requestOperationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        requestOperationManagerLogin = [AFHTTPSessionManager manager];
        requestOperationManagerLogin.requestSerializer.timeoutInterval = _REQUESTER_TIMEOUT;
        requestOperationManagerLogin.responseSerializer.acceptableContentTypes = typeSet;
        requestOperationManagerLogin.requestSerializer = [AFJSONRequestSerializer serializer];
        requestOperationManagerLogin.responseSerializer = [AFJSONResponseSerializer serializer];
        [requestOperationManagerLogin.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        requestOperationManagerAgain = [AFHTTPSessionManager manager];
        requestOperationManagerAgain.requestSerializer.timeoutInterval = _REQUESTER_TIMEOUT;
        requestOperationManagerAgain.responseSerializer.acceptableContentTypes = typeSet;
        requestOperationManagerAgain.requestSerializer = [AFJSONRequestSerializer serializer];
        requestOperationManagerAgain.responseSerializer = [AFJSONResponseSerializer serializer];
        [requestOperationManagerAgain.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        self.bgCalling = NO;
        
        
    }
    
    return self;
}

- (NSString*)makeFullAPIMethodWithAction:(NSString*)action {
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@", API_ROOT_URL, action]);
    return [NSString stringWithFormat:@"%@%@", API_ROOT_URL, action];
}

- (NSString*)makeFullAPIMethodWithAction:(NSString*)action userToken:(BOOL)userToken {
    NSString *fullAPIPath = action;
    if ([action hasPrefix:@"http://"] == NO && [action hasPrefix:@"https://"] == NO) {
        fullAPIPath = [NSString stringWithFormat:@"%@%@", API_ROOT_URL, action];
        if (userToken) {
//            fullAPIPath = [NSString stringWithFormat:@"%@%@?token=%@", API_ROOT_URL, action,[AuthInfoEntity getLoggedInUser].token];
        }
        NSLog(@"fullAPIPath: %@",fullAPIPath);
    }
    return fullAPIPath;
}

- (BaseEntity*)baseEntityFromClass:(Class)c {
    id result = [c new];
    if ([result isKindOfClass:[BaseEntity class]]) {
        return result;
    } else {
        return nil;
    }
}

#pragma mark - Public methods

- (void)sendGETRequestWithURL:(NSString*)urlStr parameters:(NSDictionary *)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken {
    NSDate *methodStart = [NSDate date];
    
//    if (userToken && [AuthInfoEntity getLoggedInUser].token.length == 0) {
//        [self closeCurrentSession];
//        return;
//    }
    
    // Make common params
    NSMutableDictionary *paramDict  = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramDict commonParams];
    
    [requestOperationManager GET:[self makeFullAPIMethodWithAction:urlStr userToken:userToken] parameters:paramDict progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//        DLog(LOG_LEVEL_INF,@"api: %@\nexecutionTime = %f \n Response:%@",urlStr, executionTime, responseObject);
        
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
            
            if([result shouldLogout]) {
                isTokenExpired = YES;
                NSLog(@"_ERROR_CODE_UNAUTHORIZED");
                [self actionWhenSessionExpired];
                return;
            } else {
                if (self.bgCalling == NO) {
                    [[CommonErrorProcessor sharedInstance] process:result];
                }
                
                if (responseHandler) {
                    responseHandler (YES, result);
                }
            }
        } else {
            if (self.bgCalling == NO) {
                [[CommonErrorProcessor sharedInstance] process:result];
            }
            
            if (responseHandler) {
                responseHandler (YES, result);
            }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        DLog(LOG_LEVEL_ERR, @"API: %@ \n Error:%@",[self makeFullAPIMethodWithAction:urlStr],error);
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        if ([self shouldLogoutWithURLResponse:httpResponse]) {
            isTokenExpired = YES;
            NSLog(@"_ERROR_CODE_UNAUTHORIZED");
            [self actionWhenSessionExpired];
            return;
        }
        
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }];
}

- (void)sendPOSTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken {
    NSDate *methodStart = [NSDate date];
    
//    if (userToken && [AuthInfoEntity getLoggedInUser].token.length == 0) {
//        [self closeCurrentSession];
//        return;
//    }

    NSMutableDictionary *paramDict  =[NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramDict commonParams];
    
    [requestOperationManager POST:[self makeFullAPIMethodWithAction:api userToken:userToken] parameters:paramDict progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDate *methodFinish = [NSDate date];
        NSTimeInterval executionTime = [methodFinish timeIntervalSinceDate:methodStart];
//        DLog(LOG_LEVEL_INF,@"api: %@\nexecutionTime = %f \n Response:%@",api, executionTime, responseObject);
        
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
            
            if([result shouldLogout]) {
                isTokenExpired = YES;
                NSLog(@"_ERROR_CODE_UNAUTHORIZED");
                [self actionWhenSessionExpired];
                return;
            } else {
                if (self.bgCalling == NO) {
                    [[CommonErrorProcessor sharedInstance] process:result];
                }
                
                if (responseHandler) {
                    responseHandler (YES, result);
                }
            }
        } else {
            if (self.bgCalling == NO) {
                [[CommonErrorProcessor sharedInstance] process:result];
            }
            
            if (responseHandler) {
                responseHandler (YES, result);
            }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        DLog(LOG_LEVEL_ERR, @"API: %@ \n Error:%@",[self makeFullAPIMethodWithAction:api],error);
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        if ([self shouldLogoutWithURLResponse:httpResponse]) {
            isTokenExpired = YES;
            NSLog(@"_ERROR_CODE_UNAUTHORIZED");
            [self actionWhenSessionExpired];
            return;
        } else if (httpResponse.statusCode == _ERROR_CODE_CREDIT_CARD_REQUIRE || httpResponse.statusCode == _ERROR_CODE_BANK_ACCOUNT_REQUIRE) {
            if (responseHandler) {
                BaseEntity *responseEntity = [BaseEntity new];
                responseEntity.isSuccess = NO,
                responseEntity.srvCode = httpResponse.statusCode;
                if (error) {
                    responseEntity.message = error.localizedDescription;
                }
                responseHandler (YES, responseEntity);
            }
            return;
        }
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:error];
        }
        
        
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }];
}

- (void)sendPUTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken {
    
//    if (userToken && [AuthInfoEntity getLoggedInUser].token.length == 0) {
//        [self closeCurrentSession];
//        return;
//    }

    // Make common params
    NSMutableDictionary *paramDict  =[NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramDict commonParams];
    
    [requestOperationManager PUT:[self makeFullAPIMethodWithAction:api userToken:userToken] parameters:paramDict success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
            
            if([result shouldLogout]) {
                isTokenExpired = YES;
                NSLog(@"_ERROR_CODE_UNAUTHORIZED");
                [self actionWhenSessionExpired];
                return;
            } else {
                if (self.bgCalling == NO) {
                    [[CommonErrorProcessor sharedInstance] process:result];
                }
                
                if (responseHandler) {
                    responseHandler (YES, result);
                }
            }
        } else {
            if (self.bgCalling == NO) {
                [[CommonErrorProcessor sharedInstance] process:result];
            }
            
            if (responseHandler) {
                responseHandler (YES, result);
            }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        DLog(LOG_LEVEL_ERR, @"API: %@ \n Error:%@",[self makeFullAPIMethodWithAction:api],error);
        
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        if ([self shouldLogoutWithURLResponse:httpResponse]) {
            isTokenExpired = YES;
            NSLog(@"_ERROR_CODE_UNAUTHORIZED");
            [self actionWhenSessionExpired];
            return;
        }
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }];
}

- (void)sendPOSTRequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters andImgData:(NSData*)imgData responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken {
    
//    if (userToken && [AuthInfoEntity getLoggedInUser].token.length == 0) {
//        [self closeCurrentSession];
//        return;
//    }

    // Make common params
    NSMutableDictionary *paramDict  =[NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramDict commonParams];
    
    NSData *jsonData;
    if (parameters != nil) {
        NSError *error;
        jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];
    }
    
    [requestOperationManager POST:[self makeFullAPIMethodWithAction:api userToken:userToken] parameters:paramDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (imgData != nil) {
            [formData appendPartWithFileData:imgData name:@"file" fileName:@"img.jpg" mimeType:@"image/jpeg"];
        }
        
        if (jsonData) {
            [formData appendPartWithFormData:jsonData name:@"param"];
        }
    } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        if ([self shouldLogoutWithURLResponse:httpResponse]) {
            isTokenExpired = YES;
            NSLog(@"_ERROR_CODE_UNAUTHORIZED");
            [self actionWhenSessionExpired];
            return;
        }
        
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }];
}


- (void)sendDELETERequestWithURL:(NSString*)urlStr parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken {
    
//    if (userToken && [AuthInfoEntity getLoggedInUser].token.length == 0) {
//        [self closeCurrentSession];
//        return;
//    }

    // Make common params
    NSMutableDictionary *paramDict  =[NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramDict commonParams];
    
    [requestOperationManager DELETE:[self makeFullAPIMethodWithAction:urlStr userToken:userToken] parameters:paramDict success:^(NSURLSessionTask *task, id responseObject) {
        
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
            
            if([result shouldLogout]) {
                isTokenExpired = YES;
                NSLog(@"_ERROR_CODE_UNAUTHORIZED");
                [self actionWhenSessionExpired];
                return;
            } else {
                if (self.bgCalling == NO) {
                    [[CommonErrorProcessor sharedInstance] process:result];
                }
                
                if (responseHandler) {
                    responseHandler (YES, result);
                }
            }
        } else {
            if (self.bgCalling == NO) {
                [[CommonErrorProcessor sharedInstance] process:result];
            }
            
            if (responseHandler) {
                responseHandler (YES, result);
            }
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        if ([self shouldLogoutWithURLResponse:httpResponse]) {
            isTokenExpired = YES;
            NSLog(@"_ERROR_CODE_UNAUTHORIZED");
            [self actionWhenSessionExpired];
            return;
        }
        
//        DLog(LOG_LEVEL_ERR, @"API: %@ \n Error:%@",[self makeFullAPIMethodWithAction:urlStr],error);
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }];
    
}

- (void)sendDELETERequestForAPI:(NSString*)api parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler userToken:(BOOL)userToken {
    
//    if (userToken && [AuthInfoEntity getLoggedInUser].token.length == 0) {
//        [self closeCurrentSession];
//        return;
//    }

    // Make common params
    NSMutableDictionary *paramDict  =[NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramDict commonParams];
    
    
    [requestOperationManager DELETE:[self makeFullAPIMethodWithAction:api userToken:userToken] parameters:paramDict success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
            
            if([result shouldLogout]) {
                isTokenExpired = YES;
                NSLog(@"_ERROR_CODE_UNAUTHORIZED");
                [self actionWhenSessionExpired];
                return;
            } else {
                if (self.bgCalling == NO) {
                    [[CommonErrorProcessor sharedInstance] process:result];
                }
                
                if (responseHandler) {
                    responseHandler (YES, result);
                }
            }
        } else {
            if (self.bgCalling == NO) {
                [[CommonErrorProcessor sharedInstance] process:result];
            }
            
            if (responseHandler) {
                responseHandler (YES, result);
            }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        if ([self shouldLogoutWithURLResponse:httpResponse]) {
            isTokenExpired = YES;
            NSLog(@"_ERROR_CODE_UNAUTHORIZED");
            [self actionWhenSessionExpired];
            return;
        }
        
//        DLog(LOG_LEVEL_ERR, @"API: %@ \n Error:%@",[self makeFullAPIMethodWithAction:api],error);
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }];
}

- (void)callbackData:(NSString*)urlStr responseObject:(id)responseObject parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler withType:(int)type {
    
    //[LoadingView hideLoading];
    //    BaseEntity *result = [self baseEntityFromClass:[AccountModel class]];
    //    if (result != nil) {
    //        [result parseResponse:responseObject];
    //    }
    
    //    switch (result.srvCode) {
    //        case API_CODE_SUCESS:{
    //
    //            AccountModel *accountModel = [AccountModel getUser];
    //            accountModel.session = ((AccountModel *)result).session;
    //            [accountModel storeUser];
    //
    //            NSString *session = accountModel.session;
    //            [requestOperationManagerAgain.requestSerializer setValue:session forHTTPHeaderField:API_PR_SAND_session];
    //
    //            switch (type) {
    //                case RequesterTypeGET: {
    //                    [self callbackDataByGET:urlStr responseObjectClass:responseObjectClass responseHandler:responseHandler];
    //                }
    //                    break;
    //
    //                case RequesterTypePOST: {
    //                    [self callbackDataByPOST:urlStr parameters:parameters responseObjectClass:responseObjectClass responseHandler:responseHandler];
    //                }
    //                    break;
    //
    //                case RequesterTypePUT: {
    //                    [self callbackDataByPUT:urlStr parameters:parameters responseObjectClass:responseObjectClass responseHandler:responseHandler];
    //                }
    //                    break;
    //
    //                case RequesterTypeDELETE_URL: {
    //                    [self callbackDataByDELETEURL:urlStr responseObjectClass:responseObjectClass responseHandler:responseHandler];
    //                }
    //                    break;
    //
    //                default: {
    //                    [self callbackDataByDELETEAPI:urlStr parameters:parameters responseObjectClass:responseObjectClass responseHandler:responseHandler];
    //                }
    //                    break;
    //            }
    //
    //            break;
    //        }
    //
    //        default: {
    //            [LoadingView hideLoading];
    //            if (self.bgCalling == NO) {
    //                [[CommonErrorProcessor sharedInstance] process:result];
    //            }
    //
    //            if (responseHandler) {
    //                responseHandler (YES, result);
    //            }
    //        }
    //            break;
    //    }
    
}

- (void)callbackDataByGET:(NSString*)urlStr responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler {
    
    [requestOperationManagerAgain GET:[self makeFullAPIMethodWithAction:urlStr] parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
        
        isTokenExpired = NO;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
    }];
}

- (void)callbackDataByPOST:(NSString*)urlStr parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler {
    
    [requestOperationManagerAgain POST:[self makeFullAPIMethodWithAction:urlStr] parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
        
        isTokenExpired = NO;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
    }];
}

- (void)callbackDataByPUT:(NSString*)urlStr parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler {
    
    [requestOperationManagerAgain PUT:[self makeFullAPIMethodWithAction:urlStr] parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
        isTokenExpired = NO;
    } failure:^(NSURLSessionTask *operation, NSError *error) {
    }];
}

- (void)callbackDataByDELETEAPI:(NSString*)urlStr parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler {
    
    [requestOperationManagerAgain DELETE:[self makeFullAPIMethodWithAction:urlStr] parameters:parameters success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
        isTokenExpired = NO;
    } failure:^(NSURLSessionTask *operation, NSError *error) {
    }];
}

- (void)callbackDataByDELETEURL:(NSString*)urlStr responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler {
    
    [requestOperationManagerAgain DELETE:[self makeFullAPIMethodWithAction:urlStr] parameters:nil success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        if (result != nil) {
            [result parseResponse:responseObject];
        }
        
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:result];
        }
        
        if (responseHandler) {
            responseHandler (YES, result);
        }
        
        isTokenExpired = NO;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
    }];
}

- (void)uploadImageWithUrl:(NSString *)urlStr image:(UIImage *)image parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler {
    
    NSMutableDictionary *paramDict  =[NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramDict commonParams];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [requestOperationManager POST:[self makeFullAPIMethodWithAction:urlStr userToken:YES] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.png" mimeType:[Utils contentTypeForImageData:imageData]];
    } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        if (result != nil) {
            [result parseResponse:responseObject];
            
            if([result shouldLogout]) {
                isTokenExpired = YES;
                NSLog(@"_ERROR_CODE_UNAUTHORIZED");
                [self actionWhenSessionExpired];
                return;
            } else {
                if (self.bgCalling == NO) {
                    [[CommonErrorProcessor sharedInstance] process:result];
                }
                
                if (responseHandler) {
                    responseHandler (YES, result);
                }
            }
        } else {
            if (self.bgCalling == NO) {
                [[CommonErrorProcessor sharedInstance] process:result];
            }
            
            if (responseHandler) {
                responseHandler (YES, result);
            }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        if ([self shouldLogoutWithURLResponse:httpResponse]) {
            isTokenExpired = YES;
            NSLog(@"_ERROR_CODE_UNAUTHORIZED");
            [self actionWhenSessionExpired];
            return;
        }
        
//        DLog(LOG_LEVEL_ERR, @"API: %@ \n Error:%@",[self makeFullAPIMethodWithAction:urlStr userToken:YES],error);
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }];
}

- (void)uploadImageWithUrl:(NSString *)urlStr image:(UIImage *)image name:(NSString *)name parameters:(NSDictionary*)parameters responseObjectClass:(Class)responseObjectClass responseHandler:(ServerResponseHandler)responseHandler {
    
    NSMutableDictionary *paramDict  =[NSMutableDictionary dictionaryWithDictionary:parameters];
    [paramDict commonParams];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [requestOperationManager POST:[self makeFullAPIMethodWithAction:urlStr userToken:YES] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //do not put image inside parameters dictionary as I did, but append it!
        [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@.png",name] mimeType:[Utils contentTypeForImageData:imageData]];
    } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        BaseEntity *result = [self baseEntityFromClass:responseObjectClass];
        if (result != nil) {
            [result parseResponse:responseObject];
            
            if([result shouldLogout]) {
                isTokenExpired = YES;
                NSLog(@"_ERROR_CODE_UNAUTHORIZED");
                [self actionWhenSessionExpired];
                return;
            } else {
                if (self.bgCalling == NO) {
                    [[CommonErrorProcessor sharedInstance] process:result];
                }
                
                if (responseHandler) {
                    responseHandler (YES, result);
                }
            }
        } else {
            if (self.bgCalling == NO) {
                [[CommonErrorProcessor sharedInstance] process:result];
            }
            
            if (responseHandler) {
                responseHandler (YES, result);
            }
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)operation.response;
        if ([self shouldLogoutWithURLResponse:httpResponse]) {
            isTokenExpired = YES;
            NSLog(@"_ERROR_CODE_UNAUTHORIZED");
            [self actionWhenSessionExpired];
            return;
        }
        
//        DLog(LOG_LEVEL_ERR, @"API: %@ \n Error:%@",[self makeFullAPIMethodWithAction:urlStr userToken:YES],error);
        if (self.bgCalling == NO) {
            [[CommonErrorProcessor sharedInstance] process:error];
        }
        
        if (responseHandler) {
            responseHandler (NO, nil);
        }
    }];
}


- (void)actionWhenSessionExpired {
    UIAlertView *alertView = [UIAlertView alertViewtWithTitle:@"Session invalid" message:@"Your session is expired\nPlease relogin to use this feature" callback:^(UIAlertView *al, NSInteger idx) {
        [self closeCurrentSession];
    } cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)closeCurrentSession {
//    [AuthInfoEntity clearCachedUser];
//    [APP_DELEGATE showMainScreen];
}

- (BOOL)shouldLogoutWithURLResponse:(NSHTTPURLResponse *) httpResponse {
    BOOL shouldLogout = NO;
    if (httpResponse.statusCode == _ERROR_CODE_UNAUTHORIZED || httpResponse.statusCode == _ERROR_CODE_FORBIDDEN) {
        shouldLogout = YES;
    }
    return shouldLogout;
}

@end
