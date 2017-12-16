//
//  CommonErrorProcessor.m
//  App
//
//  Created by HBLab-NghiaNH on 6/6/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "CommonErrorProcessor.h"
#import "Reachability.h"
#import "BaseEntity.h"

#define TAG_SHOW_MESSAGE_UPDATE_VERSION 123

@implementation CommonErrorProcessor
+ (CommonErrorProcessor*)sharedInstance {
    static CommonErrorProcessor *processor = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        processor = [CommonErrorProcessor new];
    });
    
    return processor;
}

- (void)showMessageWithTitle:(NSString*)title message:(NSString*)message isUpdateAlert:(BOOL)isUpdateAlert {
    [self showMessageWithTitle:title message:message isUpdateAlert:isUpdateAlert alwShow:NO tag:-1];
}

- (void)showMessageWithTitle:(NSString*)title message:(NSString*)message isUpdateAlert:(BOOL)isUpdateAlert alwShow:(BOOL)alwShow tag:(NSInteger )inTag{
    static UIAlertView *alert = nil;
    static UIAlertView *confirmAlert = nil; // Confirm Yes/No alert
    static dispatch_once_t oncePredicate;
    
    NSString *titleTag = @"";
    NSString *titleCancel = nil;
    if (inTag == TAG_SHOW_MESSAGE_UPDATE_VERSION) {
        titleTag = NSLocalizedString(@"title_close_app", @"");
        titleCancel =  NSLocalizedString(@"title_version_up_enterprise", @"");
    } else {
        titleTag = NSLocalizedString(@"ok_alert_text", @"");
    }
    
    
    
    dispatch_once(&oncePredicate, ^{
        
        alert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:titleTag otherButtonTitles:nil];
        if (isUpdateAlert) {
            confirmAlert = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:self cancelButtonTitle:titleTag otherButtonTitles:titleCancel, nil];
            confirmAlert.tag = inTag;
        }
    });
    // check if alert already shown ==>do nothing
    BOOL isShowing = ((alert && alert.visible) || (confirmAlert && confirmAlert.visible));
    if (isShowing == NO || alwShow) {
        if (isUpdateAlert) {
            confirmAlert.title = title;
            confirmAlert.message = message;
            confirmAlert.delegate = self;
            [confirmAlert show];
        } else {
            alert.title = title;
            alert.message = message;
            [alert show];
        }
    } else {
        
    }
}

- (void)networkCheckError {
    // Allocate a reachability object
    Reachability *reach = [Reachability reachabilityWithHostname:@"www.apple.com"];
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        [reach stopNotifier];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            //            if (APP_DELEGATE.isAfterFiveSec) { // Modify by CanhLD
            //                [self showMessageWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"cannot_connect_to_the_host", @"") isUpdateAlert:NO];
            //            }
            
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        [reach stopNotifier];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            //            if (APP_DELEGATE.isAfterFiveSec) { //Modify by CanhLD
            //                [self showMessageWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"network_error", @"") isUpdateAlert:NO];
            //            }
            
        });
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
}

- (BOOL)process:(id)error {
    if (error == nil) {
        [self showMessageWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"unknown_error_message_code", @"") isUpdateAlert:NO];
    }
    
    if ([error isKindOfClass:[NSError class]]) {
        NSString *message = ((NSError *)error).localizedDescription;
        NSInteger code = ((NSError *)error).code;
        if(code == -1001) {
            // request timed out
        } else if (code == -1009 || code == -1004) {
            // no internet connectivity
            message = @"インターネットの接続がありません";
        }
        [self showMessageWithTitle:@"エラー" message:message isUpdateAlert:NO];
        
//        [self showMessageWithTitle:NSLocalizedString(@"error_title", @"") message:((NSError *)error).localizedDescription isUpdateAlert:NO];
        
    } /*else if ([error isKindOfClass:[ABMError class]]) {
        [self showMessageWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"unknown_error_message_code", @"") isUpdateAlert:NO];
        return YES;
    } else if ([error isKindOfClass:[ABMError class]]) {
         int errorCode = (int)((ABMBaseEntity*)error).code;
         switch (errorCode) {
         case ERR_CODE_INVALID_TOKEN:
         {
         BOOL isDeactivate = [USER_DEFAULT_STANDARD boolForKey:@"DEACTIVE_STOP_AUTO_LOGIN"];
         if (!isDeactivate) {
         APP_DELEGATE.gLoginEntity.isLogout = YES;
         APP_DELEGATE.gLoginEntity.didShowFreePageAfterSignup = YES;
         [APP_DELEGATE.gLoginEntity storeToFile];
         [APP_DELEGATE autoLogin];
         }
         
         }
         return YES;
         break;
         case ERR_CODE_ACC_LOCKED:
         [self showMessageWithTitle:@"" message:NSLocalizedString(@"account_is_locked", @"") isUpdateAlert:NO];
         return YES;
         
         case ERR_CODE_UNKNOWN_ERROR:
         case ERR_CODE_WRONG_DATA_FORMAT:
         [self showMessageWithTitle:NSLocalizedString(@"error_title", @"") message:NSLocalizedString(@"unknown_error_message_code", @"") isUpdateAlert:NO];
         return YES;
         break;
         case ERR_CODE_API_OUT_OF_DATE:
         [self showMessageWithTitle:@"" message:NSLocalizedString(@"need_update_the_app_msg", @"") isUpdateAlert:YES];
         return YES;
         break;
         // Add by CanhLD
         case ERR_CODE_INVALID_BIRTHDAY:
         [self showMessageWithTitle:@"" message:NSLocalizedString(@"birthday_invalid", @"") isUpdateAlert:NO];
         return YES;
         break;
         // Add by ThuyDT
         case ERR_CODE_UNUSABLE_VERSION_APPLICATION:
         [self showMessageWithTitle:@"" message:NSLocalizedString(@"need_update_the_app_msg", @"") isUpdateAlert:YES alwShow:YES tag:TAG_SHOW_MESSAGE_UPDATE_VERSION];
         return YES;
         break;
         default:
         break;
         }
    }*/
    
    return NO;
}

#pragma mark - AlertView
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    //    if (alertView.tag == TAG_SHOW_MESSAGE_UPDATE_VERSION) {
    //        if (APPLICATION_TYPE == APPLICATION_TYPE_APPSTORE) {
    //            [APP_DELEGATE openAppStoreForRate:NO];
    //        } else {
    //            if (buttonIndex == 0) {
    //                exit(0);
    //            } else {
    //                [self openSafariWithURL];
    //            }
    //        }
    //    } else {
    //        [APP_DELEGATE openAppStoreForRate:NO];
    //    }
    
}

#pragma mark - open safari


- (void) openSafariWithURL {
    //    [[UIApplication sharedApplication]
    //     openURL:[NSURL URLWithString:kShowWebApplicationTypeEnterprise]];
}


@end
