//
//  Utils.m
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import "Utils.h"
#import "Utils.h"
#import <CoreLocation/CoreLocation.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#import <QuartzCore/QuartzCore.h>
#import "AFNetworkReachabilityManager.h"
#import "Reachability.h"

#define MAX_CHARACTER_EMAIL         40
#define MIN_CHARACTER_PASSWORD      6
#define MAX_CHARACTER_PASSWORD      20

@implementation Utils
+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className {
    if ([className length] > 0) {
        // Nib name from className
        Class c = NSClassFromString(className);
        NSString *nibName = @"";
        /* Uncomment this when app supports Universal
         if (IS_IPHONE) {
         nibName = [NSString stringWithFormat:@"%@_iPhone", className];
         } else {
         nibName = [NSString stringWithFormat:@"%@_iPad", className];
         }
         */
        nibName = [NSString stringWithFormat:@"%@", className];
        if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil) {
            //file found
            return [[c alloc] initWithNibName:nibName bundle:nil];
        } else {
            return [[UIViewController alloc] init];
        }
    }
    return nil;
}

+ (UIViewController*)newAutoLayoutUniversalViewControllerWithClassName:(NSString*)className {
    if ([className length] > 0) {
        // Nib name from className
        Class c = NSClassFromString(className);
        NSString *nibName = [NSString stringWithFormat:@"%@", className];
        
        if([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] != nil) {
            //file found
            return [[c alloc] initWithNibName:nibName bundle:nil];
        } else {
            return [[UIViewController alloc] init];
        }
    }
    return nil;
}

+ (NSString*)trimming:(NSString*)string {
    //remove double whitespace
    NSArray *ar = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newString = @"";
    for (int i = 0; i < ar.count; i++) {
        NSString *word = [ar objectAtIndex:i];
        if(![word isEqualToString:@""]){
            newString = [newString stringByAppendingFormat:@"%@ ",word];
        }
    }
    
    return [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (void)moveUp:(BOOL)isMoveUp view:(UIView*)view deltaY:(double)height duration:(float)duration removeView:(BOOL)removeView hiddenWhenFinished:(BOOL)hiddenWhenFinished completion:(void (^)(BOOL finished))completion{
    CGRect frameToGo = view.frame;
    if (isMoveUp) {
        frameToGo.origin.y -= height;
    } else {
        frameToGo.origin.y += height;
    }
    
    [UIView animateWithDuration:((duration > 0)? duration: 0.3)
                     animations:^{
                         view.frame = frameToGo;
                     } completion:^(BOOL finished) {
                         if (hiddenWhenFinished) {
                             [view setHidden:YES];
                         }
                         if (removeView) {
                             if (finished) {
                                 [view removeFromSuperview];
                             }
                         }
                         if (completion != NULL) {
                             completion (finished);
                         }
                     }
     ];
}

// Add by ThaiTB
+ (void)showAlerWithTitle:(NSString *)title andMessage:(NSString *)message andCancelTitle:(NSString *)cancelTitle{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles: nil];
    
    [alertView show];
}

// Remove "(null)"
+ (NSString*)removeNull:(NSString*)string {
    if (string != nil && [string length] > 0) {
        string = [string stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"null" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    }
    
    return string;
}

+ (BOOL)validateEmail:(NSString *)email {
    ////	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,100}"; //comment by ThaiTB
    //    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,100}";
    //
    //	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //
    //	return [emailTest evaluateWithObject:email];
    // 20140204 - HungBM change to new regex to support "@i.softbank.jp"
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString =
    @"(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[A-Za-"
    @"z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//Add by LongNH
+ (void) responseErrorCode:(int) errCode {
    //    NSString *titleMessage = EMTPY_CHARACTER;
    //    switch (errCode) {
    //        case API_CODE_SUCESS: {
    //            //Login Success
    //            titleMessage = EMTPY_CHARACTER;
    //            break;
    //        }
    //        case ERR_CODE_EMAIL_NOT_FOUND: {
    //            //Email not found
    //             titleMessage = NSLocalizedString(@"email_not_found_message_code", @"");
    //            break;
    //        }
    //        case ERR_CODE_INVALID_EMAIL: {
    //            //Invalid Email
    //            titleMessage = NSLocalizedString(@"invalid_email_message_code", @"");
    //            break;
    //        }
    //        case ERR_CODE_INCORRECT_PASSWORD: {
    //            //Invalid Email
    //            titleMessage = NSLocalizedString(@"incorrect_password_message_code", @"");;
    //            break;
    //        }
    //        case ERR_CODE_EMAIL_REGISTED: {
    //            //Email registered
    //            titleMessage = NSLocalizedString(@"email_registered_message_code", @"");
    //            break;
    //        }
    //        case ERR_CODE_SEND_EMAIL_FAIL: {
    //            //Invalid Email
    //            titleMessage = NSLocalizedString(@"send_email_fail_message_code", @"");
    //            break;
    //        }
    //        case ERR_CODE_INCORRECT_CODE: {
    //            //Incorrect code
    //            titleMessage = NSLocalizedString(@"incorrect_code_message_code", @"");
    //            break;
    //        }
    //        case ERR_CODE_DUPLICATE_USERNAME: {
    //            titleMessage = NSLocalizedString(@"duplicate_username_message_code", @"");
    //            break;
    //        }
    //        default: {
    //            break;
    //        }
    //    }
    //
    //    if (MESSAGE_NOT_EMPTY(titleMessage)) {
    //        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:titleMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_button_yes_title", @"") otherButtonTitles:nil];
    //        [alerView show];
    //    }
}

//+ (BOOL) validateFieldsOfSingup:(NSString *)aName birthday:(NSString *)aBirthday {
//    /**
//     *  AnhVH: fix bug 8216
//     *  28May2014
//     */
//    BOOL isValidate = TRUE;
//    NSString *titleMessage = @"";
//
//    //validate Name
//    if (aName.length == 0) { //nil string
//        isValidate = FALSE;
//        titleMessage = NSLocalizedString(@"check_name_is_empty_message", @"");
//    } else if (aName.length > MAX_CHARACTER_NAME) { //out of range
//        isValidate = FALSE;
//        titleMessage = NSLocalizedString(@"user_name_is_too_long_message", @"");
//    }else if([Utils trimming:aName].length == 0){ //name string just only contants whitespace
//        isValidate = FALSE;
//        titleMessage = NSLocalizedString(@"check_name_is_empty_message", @"");
//    }
//    if (!isValidate) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:titleMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_button_yes_title", @"") otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
//        return isValidate;
//    }
//
//    //validate birthday
//    if (aBirthday.length == 0) { //nil string
//        isValidate = FALSE;
//        titleMessage = NSLocalizedString(@"check_birthday_is_required_message", @"");
//    }
//    if (!isValidate) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:titleMessage delegate:nil cancelButtonTitle:NSLocalizedString(@"alert_button_yes_title", @"") otherButtonTitles:nil];
//        [alertView show];
//        [alertView release];
//        return isValidate;
//    }
//    return isValidate;
//}

+ (BOOL) verifyLoginWithEmail:(NSString *)aEmail andPassword:(NSString *)aPassword {
//        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,100}";
//    	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
//    	BOOL isEmail = [emailTest evaluateWithObject:aEmail];
    
//     Update validate email by ThaiTB
    BOOL isEmail = [self validateEmail:aEmail];
    
    BOOL isPassword = (aPassword.length == 0) ? 0 : 1;
    BOOL isEmailEmpty = (aEmail.length == 0) ? 0 : 1;
    BOOL isVerify = NO;
    NSString *messageAlert = @"";
    if (!isEmailEmpty) {
        messageAlert = NSLocalizedString(@"email_is_empty_message", @"");
    } else if (!isEmail) {
        messageAlert = NSLocalizedString(@"email_is_wrong_message", @"");
    } else if (aEmail.length > MAX_CHARACTER_EMAIL) {
        messageAlert = NSLocalizedString(@"email_is_too_long_message", @"");
    } else if (!isPassword) {
        messageAlert = NSLocalizedString(@"password_is_empty_message", @"");
    } else if ((aPassword.length < MIN_CHARACTER_PASSWORD) |
               (aPassword.length > MAX_CHARACTER_PASSWORD)){
        messageAlert = [NSString stringWithFormat:NSLocalizedString(@"password_out_of_range", @""),MIN_CHARACTER_PASSWORD, MAX_CHARACTER_PASSWORD];
    } else {
        isVerify = YES;
    }
    if (!isVerify) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:messageAlert delegate:nil cancelButtonTitle:NSLocalizedString(@"ok_alert_text", @"") otherButtonTitles:nil];
        [alertView show];
    }
    return isVerify;
}

+ (BOOL) verifyLoginWithBirthDate:(NSString *)birthDate andGender:(NSInteger)gender {
    // Logic for birthDay here
    return YES;
}

//Show or hidden picker or picker date view
+ (void) animationHidenOrShowView:(UIView *)view {
    CATransition *animation = [CATransition animation];
    animation.duration = .3f;
    animation.removedOnCompletion = NO;
    animation.type = kCATransitionPush;
    if (view.hidden) {
        animation.subtype = kCATransitionFromBottom;
    } else {
        animation.subtype = kCATransitionFromTop;
    }
    [view.layer addAnimation:animation forKey:@"animation"];
}


+ (NSString *)trimString:(NSString *)sourceString reducedToWidth:(CGFloat)width withFont:(UIFont *)font {
    
    if ([self sizeOfString:sourceString withFont:font].width <= width) {
        return sourceString;
    }
    
    NSMutableString *cutedText = [NSMutableString string];
    for (NSInteger i = 0; i < [sourceString length]; i++) {
        [cutedText appendString:[sourceString substringWithRange:NSMakeRange(i, 1)]];
        if ([self sizeOfString:cutedText withFont:font].width >= width) {
            if ([cutedText length] == 1)
                return nil;
            [cutedText deleteCharactersInRange:NSMakeRange(i, 1)];
            break;
        }
    }
    return [cutedText stringByAppendingString:@"..."];
}
+ (CGSize) sizeOfString:(NSString*)string withFont:(UIFont*)font{
    // code here for iOS 7.0
    return [string sizeWithAttributes:
            @{NSFontAttributeName:font}];
}
//Update login time
+ (NSString *) formatLoginTime {
    NSDate *dateLocal = [[NSDate alloc] init];
    NSDateFormatter *dateFormater = [NSDateFormatter sharedInstance];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateFormat = [dateFormater stringFromDate:dateLocal];
    return dateFormat;
}

+(float) convertKilometToMiles:(float) kmValue {
    return 0.621371192 * kmValue;
}

// Add By ThaiTB
+ (NSNumber *)numberFromString:(NSString *)text{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *n = [f numberFromString:text];
    return n;
}

// Add by Khanh
//
//+ (void)playVibrate{
//
//    if (APP_DELEGATE.gSettingInfo.isVibrate) {
//
//        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
//    }
//}

UInt32 notificationID = -1;

//+ (void)playSound{
//
//    if (APP_DELEGATE.gSettingInfo.isPlaySound) {
//        // Update by ThaiTB
//        if (notificationID == -1) {
//            CFBundleRef mainBundle = CFBundleGetMainBundle();
//            CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) @"notice", CFSTR("mp3"), NULL);
//            AudioServicesCreateSystemSoundID(soundFileURLRef, &notificationID);
//            SAFE_CF_RELEASE(soundFileURLRef);
//        } else {
//            // do nothing
//        }
//        AudioServicesPlaySystemSound(notificationID);
//    }
//}

+ (void)performDelegateBlock:(dispatch_block_t)block{
    dispatch_async(dispatch_get_main_queue(), block);
}

+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

+ (NSString*)removeEmoji:(NSString *)string didStop:(BOOL*)didStop {
    __block BOOL isEmoji = NO;
    NSMutableString *tmp = [[NSMutableString alloc] initWithString:string];
    [tmp enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEmoji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEmoji = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 isEmoji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEmoji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEmoji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEmoji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 isEmoji = YES;
             }
         }
         
         if (isEmoji) {
             [tmp replaceCharactersInRange:substringRange withString:@""];
             *stop = YES;
         }
     }];
    
    *didStop = !isEmoji;
    
    return tmp;
}

+ (NSString*)removeAllEmojiFromString:(NSString*)str {
    BOOL didStop = NO;
    do {
        str = [Utils removeEmoji:str didStop:&didStop];
    } while (didStop == NO);
    
    return str;
}

+ (NSString*)emojiToUnicode:(NSString*)emoji {
    NSData *data = [emoji dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; // Add autorelease by ThaiTB
}

+ (NSString*)unicodeToEmoji:(NSString*)unicode {
    NSData *data = [unicode dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding]; // Add autorelease by ThaiTB
}

+ (NSString*)bytesInStringOFData:(NSData*)dt {
    const char* fileBytes = (const char*)[dt bytes];
    NSUInteger length = [dt length];
    NSUInteger index;
    
    NSMutableString *str = [[NSMutableString alloc] init];
    for (index = 0; index<length; index++)
    {
        char aByte = fileBytes[index];
        //Do something with each byte
        [str appendFormat:@" %d", aByte];
    }
    
    return str; // Add autorelease by ThaiTB
}

// Add by ThaiTB
+ (NSString *)updateName:(NSString *)orgName withMaxCharacters:(int)maxCharacters{
    if (orgName && orgName.length > maxCharacters) {
        return [NSString stringWithFormat:@"%@...", [orgName substringToIndex:(maxCharacters - 3)]];
    } else {
        return orgName;
    }
}

+ (void)stopTimer:(NSTimer**)timer {
    if (*timer != nil) {
        if ([*timer isValid]) {
            [*timer invalidate];
        }
        
        *timer = nil;
    }
}

+ (NSArray *)reversedArray:(NSArray*)inputArr {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[inputArr count]];
    NSEnumerator *enumerator = [inputArr reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

// Add by ThaiTB
+ (void)playSystemSoundWithFileName:(NSString *)fileName andFileType:(NSString *)fileType{
    CFBundleRef mainBundle = CFBundleGetMainBundle();
    CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, (CFStringRef) fileName, (CFStringRef) fileType, CFSTR("Resource"));
    UInt32 soundID;
    AudioServicesCreateSystemSoundID(soundFileURLRef, &soundID);
    AudioServicesPlaySystemSound(soundID);
    SAFE_CF_RELEASE(soundFileURLRef);
    AudioServicesRemoveSystemSoundCompletion(soundID);
}

+ (void)playAudioSoundWithFileName:(NSString *)fileName andFileType:(NSString *)fileType andDelegate:(id<AVAudioPlayerDelegate>)delegate{
    NSError *error = nil;
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:fileType];
    
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    if (!error && audioPlayer) {
        [audioPlayer setDelegate:delegate];
        [audioPlayer setVolume:1.0f];
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    } else {
        // Do nothing
    }
    
}

+ (AVAudioPlayer *)audioPlayerWithFilePath:(NSString *)filePath andDelegate:(id<AVAudioPlayerDelegate>)delegate{
    NSError *error = nil;
    NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir  = [documentPaths objectAtIndex:0];
    NSString *outputPath    = [documentsDir stringByAppendingPathComponent:filePath];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *audioPath = outputPath;
    AVAudioPlayer *audioPlayer;
    if ([fileManager fileExistsAtPath:audioPath])
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        
        // Set category of audio session
        // See handy chart on pg. 46 of the Audio Session Programming Guide for what the categories mean
        // Not absolutely required in this example, but good to get into the habit of doing
        // See pg. 10 of Audio Session Programming Guide for "Why a Default Session Usually Isn't What You Want"
        
        NSError *setCategoryError = nil;
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:&setCategoryError];
        
        if (setCategoryError) {
            NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
        }
        
        NSURL *soundURL = [NSURL fileURLWithPath:audioPath isDirectory:YES];
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
        if (!error && audioPlayer) {
            [audioPlayer setVolume:1.0f];
            [audioPlayer prepareToPlay];
        } else {
            // Do nothing
        }
    } else {
    }
    return audioPlayer;
}

+ (void)makeRoundView:(UIView *)view{
    view.contentMode = UIViewContentModeScaleAspectFill;
    
    [view.layer setCornerRadius:view.frame.size.width / 2.0f];
    [view.layer setMasksToBounds:YES];
    
    [view setClipsToBounds:YES];
}

+ (void)makeRoundView:(UIView *)view color:(UIColor*)color {
    view.contentMode = UIViewContentModeScaleAspectFill;
    [view.layer setCornerRadius:view.frame.size.width / 2.0f];
    [view.layer setMasksToBounds:YES];
    view.layer.borderColor = color.CGColor;
    view.layer.borderWidth = 1.0f;
    [view setClipsToBounds:YES];
}

+ (void)makeRoundView:(UIView *)view color:(UIColor*)color cornerRadius:(CGFloat)cornerRadius {
    view.contentMode = UIViewContentModeScaleAspectFill;
    [view.layer setCornerRadius:cornerRadius];
    [view.layer setMasksToBounds:YES];
    if (color) {
        view.layer.borderColor = color.CGColor;
        view.layer.borderWidth = 1.0f;
    }
    [view setClipsToBounds:YES];
}


+ (void)roundView:(UIView *)view radius:(float)radius shadowOffset:(CGSize)offset shadowOpacity:(float)opa{
    view.contentMode = UIViewContentModeScaleAspectFit;
    [view.layer setCornerRadius:radius];
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOffset = offset;
    view.layer.shadowOpacity = opa;
}

+ (void)ovalRoundView:(UIView *)view {
    CGRect bounds = view.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithOvalInRect:bounds];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    view.layer.mask = maskLayer;
}



+ (NSString*)appName {
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    NSString *name = [info objectForKey:(NSString*)kCFBundleNameKey];
    return name ? : @"";
}

+ (UIAlertView*)showingAlertView {
    if (IS_OS_7_OR_LATER == NO) {
        for (UIWindow* window in [UIApplication sharedApplication].windows){
            for (UIView *subView in [window subviews]){
                if ([subView isKindOfClass:[UIAlertView class]]) {
                    return (UIAlertView*)subView;
                }
            }
        }
    }
    
    return nil;
}

static UIView *actionSheet = nil;
+(void)findActionSheetInSubviewsOfView:(id)view
{
    if (actionSheet) {
        return;
    }
    if ([[view valueForKey:@"subviews"] count] != 0) {
        for (id subview in [view valueForKey:@"subviews"]) {
            if ([subview isKindOfClass:[UIActionSheet class]]) {
                actionSheet = subview;
            }
            else
                [self findActionSheetInSubviewsOfView:subview];
        }
    }
}

+(UIActionSheet*) actionSheetShowing {
    actionSheet = nil;
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        [self findActionSheetInSubviewsOfView:window];
    }
    
    if (actionSheet) {
        return (UIActionSheet*)actionSheet;
    }
    return nil;
}

+ (CGSize)sizeOfString:(NSString*)str withFont:(UIFont*)font constrainedToSize:(CGSize)constrainedToSize{
    if (str && font) {
        CGRect rect = [str boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
        return rect.size;
    } else {
        return CGSizeZero;
    }
}

+ (CGSize)sizeOfString:(NSString*)str withFont:(UIFont*)font constrainedToSize:(CGSize)constrainedToSize lineBreakMode:(NSLineBreakMode)lineBreakMode{
    if (str && font) {
        CGRect rect = [str boundingRectWithSize:constrainedToSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : font} context:nil];
        return rect.size;
    } else {
        return CGSizeZero;
    }
}

+ (NSString*)timeStringFromSecs:(int)secs {
    int hour = secs / 3600;
    int minute = (secs - hour * 3600) / 60;
    int sec = secs - hour * 3600 - minute * 60;
    
    if (hour == 0) {
        return [NSString stringWithFormat:@"%d:%.2d", minute, sec];
    } else {
        return [NSString stringWithFormat:@"%d:%d:%.2d", hour, minute, sec];
    }
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSString *) hexFromUIColor:(UIColor *)color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0] green:components[0] blue:components[0] alpha:components[1]];
    }
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    return [NSString stringWithFormat:@"#%02X%02X%02X", (int)((CGColorGetComponents(color.CGColor))[0]*255.0), (int)((CGColorGetComponents(color.CGColor))[1]*255.0), (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

+ (void)printAllFontNames {
    for(NSString *fontfamilyname in [UIFont familyNames])
    {
        NSLog(@"family:'%@'",fontfamilyname);
        for(NSString *fontName in [UIFont fontNamesForFamilyName:fontfamilyname])
        {
            NSLog(@"\tfont:'%@'",fontName);
        }
        NSLog(@"-------------");
    }
}

+ (UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (NSString *)hexStringForColor:(UIColor *)color {
    if (color == [UIColor whiteColor]) {
        return @"ffffff";
    } else if(color == [UIColor blackColor]) {
        return @"000000";
    }
    
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString=[NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    
    return hexString;
}

+ (BOOL)checkNetWork{
    NSURL *url=[NSURL URLWithString:@""];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];
    NSLog(@"%@",([response statusCode]== 200)?@"co mang":@"ko co mang");
    return ([response statusCode]==200)?YES:NO;
}

+ (BOOL)checkNetWorkAvailable{
    Reachability* reachManager = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [reachManager currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

+ (CGFloat)heightForString:(NSString*)str constrainWidth:(CGFloat)width withFont:(UIFont*)font
{
    if (str && ![str isEqualToString:@""])
    {
        CGRect rect = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                        options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
        return rect.size.height;
    }
    return 0.0;
}

+ (CGFloat)widthForString:(NSString*)str constrainHeight:(CGFloat)height withFont:(UIFont*)font
{
    if (str && ![str isEqualToString:@""])
    {
        CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX,height)
                                        options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
        return rect.size.width;
    }
    return 0.0;
}

+ (BOOL) IsValidEmail:(NSString *)checkString
{
    BOOL check = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = check ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}

+ (NSNumber *)roundedNumber:(NSNumber *)number toPositionRightOfDecimal:(int)position {
    float fnumber = [number floatValue];
    float result = 0;
    float t = powf(10.0f, position);
    result = roundf(fnumber * t) /t;
    return [NSNumber numberWithFloat:result];
}

+ (BOOL)checkPhoneNumber:(NSString *)phone {
    NSString *phoneNumber = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if([phoneNumber length] > 0) {
        NSString *phoneRegex = @"^[0-9]{2,13}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        
        BOOL phoneValidates = [predicate evaluateWithObject:phoneNumber];
        
        return phoneValidates;
        
    } else {
        return NO;
    }
}

+ (BOOL)checkLocation {
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if (locationAllowed) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusDenied: {
                return NO;
            }
                
            default: {
                return YES;
            }
        }
    } else {
        return NO;
    }
}

// Added by Tam CO
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// Added by Tam CO
+ (UIImage *)imageWithImage:(UIImage *) sourceImage maxWidth:(CGFloat) maxWidth maxHeight:(CGFloat) maxHeight
{
    CGFloat oldWidth = sourceImage.size.width;
    CGFloat oldHeight = sourceImage.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? maxWidth / oldWidth : maxHeight / oldHeight;
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    return [self imageWithImage:sourceImage scaledToSize:newSize];
    
}

+ (UIImage *)loadImageWithPath:(NSString *)path {
    UIImage *thumb;
    NSArray  *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir  = [documentPaths objectAtIndex:0];
    NSString *outputPath    = [documentsDir stringByAppendingPathComponent:path];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString *imgPath = outputPath;
    
    if ([fileManager fileExistsAtPath:imgPath])
    {
        NSData *imgData = [[NSData alloc] initWithContentsOfURL:[NSURL fileURLWithPath:imgPath]];
        thumb = [[UIImage alloc] initWithData:imgData];
    } else {
        NSLog(@"zzzzzzzzzzzz loadImageWithPath failed %@",path);
    }
    return thumb;
}

+ (void)removeRecourceWithPath:(NSString *)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:path];
    [fileManager removeItemAtPath: fullPath error:NULL];
}

+ (CGFloat)deviceSizeScale {
    float sizeScale = 1.0;
    if (IS_IPHONE_4_OR_LESS) {
        sizeScale = 0.7;
    } else if (IS_IPHONE_5) {
        sizeScale = 320.0/375.0;
    } else if (IS_IPHONE_6_PLUS){
        sizeScale = 1.1;// 540.0/375.0;
    }
    return sizeScale;
}

+ (float)roundToHalf:(float)val {
    float result = val;
    result = round(val * 2.0) / 2.0;
    return result;
}

+ (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

/*
 + (NSString *)userDefaultKey:(NSString *)key {
 NSString *result = key;
 HVUserModel *userInfo = [HVUserBusinessModel userInfo];
 if (userInfo) {
 result = [NSString stringWithFormat:@"%@_%@",key,[userInfo.iid stringValue]];
 }
 return result;
 }
 */

+ (NSString *)displayPhonetics:(NSString *)phonetics {
    NSError *error = nil;
    NSString* str = @"";
    if (phonetics.length > 0) {
        NSString *displayPhonetics = [NSString stringWithFormat:@"/%@/",phonetics];
        // Format to remove all special
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithData:[displayPhonetics dataUsingEncoding:NSUTF8StringEncoding]
                                                                      options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                                NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:&error];
        if (error == nil) {
            str = attStr.string;
        }
    }
    return str;
}
//##12290 ntq- redmine ntq: start- add a funtion strim space by thuydt
+ (NSString *)strimSpaceWithInput:(NSString *)input {
    /*
     Replace only space: [ ]+
     Replace space and tabs: [ \\t]+
     Replace space, tabs and newlines: \\s+
     */
    
    NSString *squashed = [input stringByReplacingOccurrencesOfString:@"\\s+"
                                                          withString:@" "
                                                             options:NSRegularExpressionSearch
                                                               range:NSMakeRange(0, input.length)];
    
    NSString *output = [squashed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return output;
}

+ (NSString *)japaneseCurrencyFormatStringWithNumber:(NSNumber *)priceValue {
    NSString *resultStr = @"";
    if (!priceValue) {
        priceValue = @(0);
    }
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.locale = [NSLocale localeWithLocaleIdentifier:@"ja_JP"];
    f.numberStyle = NSNumberFormatterCurrencyStyle;
    
    if([f.locale.localeIdentifier hasPrefix:@"ja"]) {
        f.positiveFormat = @"#,##0¤";
        if([f.currencyCode isEqualToString:@"JPY"])
            f.currencySymbol = @"円";
        else
            f.currencySymbol = [f.locale displayNameForKey:NSLocaleCurrencyCode
                                                     value:f.currencyCode];
    }
    resultStr = [f stringFromNumber:priceValue];
    return resultStr;
}

+ (NSString *)japanesCurrencyStringFromNumber:(NSNumber *)price {
    if (!price) {
        price = @(0);
    }
    NSString *resultStr = @"";
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.locale = [NSLocale localeWithLocaleIdentifier:@"ja_JP"];
    f.numberStyle = NSNumberFormatterCurrencyStyle;
    resultStr = [f stringFromNumber:price];
    return resultStr;
}

+ (void)openMapsWithLongitude:(CGFloat)lon latitude:(CGFloat)lat {
    NSString *mapUrl = @"";
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        mapUrl = [NSString stringWithFormat:@"comgooglemaps://?q=%f,%f&center=%f,%f&zoom=15",lat, lon,lat, lon];
    } else {
        mapUrl = [NSString stringWithFormat:@"http://maps.apple.com/?q=%f,%f",lat, lon];
    }
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: mapUrl]];
}

+ (NSString *)japaneseTimeFromMinute:(NSInteger)min {
    NSMutableString *times = [@"" mutableCopy];
    NSInteger hour = min/60;
    NSInteger minute = min%60;
    if (hour > 0) {
        [times appendString:[NSString stringWithFormat:@"%ld時間", (long)hour]];
    }
    
    if (min == 0 || minute > 0) {
        [times appendString:[NSString stringWithFormat:@"%ld分", (long)minute]];
    }
    return times;
}
@end
