//
//  Utils.h
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface Utils : NSObject
// Create UIViewController from className by use initWithNibName:bundle: method. Require: name of Nib = [className_iPhone] and [className_iPad]
+ (UIViewController*)newUniversalViewControllerWithClassName:(NSString*)className;
+ (UIViewController*)newAutoLayoutUniversalViewControllerWithClassName:(NSString*)className;
+ (NSString*)trimming:(NSString*)string;

// Add by ThaiTB
+ (void)moveUp:(BOOL)isMoveUp view:(UIView*)view deltaY:(double)height duration:(float)duration removeView:(BOOL)removeView hiddenWhenFinished:(BOOL)hiddenWhenFinished completion:(void (^)(BOOL finished))completion;

// Add by ThaiTB
+ (void)showAlerWithTitle:(NSString *)title andMessage:(NSString *)message andCancelTitle:(NSString *)cancelTitle;

// remove null in string
+ (NSString*)removeNull:(NSString*)string;
+ (BOOL)validateEmail:(NSString *)email;

//Add by LongNH
//Valid name and birthday when signup
//+ (BOOL) validateFieldsOfSingup:(NSString *)aName birthday:(NSString *)aBirthday;
+ (BOOL) verifyLoginWithEmail:(NSString *)aEmail andPassword:(NSString *)aPassword;
+ (BOOL) verifyLoginWithBirthDate:(NSString *)birthDate andGender:(NSInteger)gender;
//Respon error code from service
+ (void) responseErrorCode:(int) errCode;
//Show or hidden picker or picker date view
+ (void) animationHidenOrShowView:(UIView *)view;
//Load image by url

// Add by ThaiTB
//+ (NSURL *)imageUrlWithID:(NSString *)imageID andWidthSize:(float)widthSize;

//Update login time
+ (NSString *) formatLoginTime;
+(float) convertKilometToMiles:(float) kmValue;

// add by Khanh
+ (NSString *)trimString:(NSString *)sourceString reducedToWidth:(CGFloat)width withFont:(UIFont *)font;

// Add By ThaiTB
+ (NSNumber *)numberFromString:(NSString *)text;

// Add by Khanh

//+ (void)playVibrate;

//+ (void)playSound;

+ (void)performDelegateBlock:(dispatch_block_t)block;

+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (NSString*)removeEmoji:(NSString *)string didStop:(BOOL*)didStop ;

+ (NSString*)removeAllEmojiFromString:(NSString*)str;

+ (NSString*)emojiToUnicode:(NSString*)emoji;

+ (NSString*)unicodeToEmoji:(NSString*)unicode;

+ (NSString*)bytesInStringOFData:(NSData*)dt;

// Add by ThaiTB
+ (NSString *)updateName:(NSString *)orgName withMaxCharacters:(int)maxCharacters;

+ (void)stopTimer:(NSTimer**)timer;
+ (NSArray *)reversedArray:(NSArray*)inputArr;

// Add by ThaiTB
+ (void)playSystemSoundWithFileName:(NSString *)fileName andFileType:(NSString *)fileType;

+ (void)playAudioSoundWithFileName:(NSString *)fileName andFileType:(NSString *)fileType andDelegate:(id<AVAudioPlayerDelegate>)delegate;

+ (AVAudioPlayer *)audioPlayerWithFilePath:(NSString *)filePath andDelegate:(id<AVAudioPlayerDelegate>)delegate;

+ (void)makeRoundView:(UIView *)view;

+ (void)makeRoundView:(UIView *)view color:(UIColor*)color;

+ (void)makeRoundView:(UIView *)view color:(UIColor*)color cornerRadius:(CGFloat)cornerRadius;

+ (void)ovalRoundView:(UIView *)view;

+ (void)roundView:(UIView *)view radius:(float)radius shadowOffset:(CGSize)offset shadowOpacity:(float)opa;

+ (NSString*)appName;

+ (UIAlertView*)showingAlertView;

+(UIActionSheet*) actionSheetShowing;

+ (CGSize)sizeOfString:(NSString*)str withFont:(UIFont*)font constrainedToSize:(CGSize)constrainedToSize;

+ (NSString*)timeStringFromSecs:(int)secs;

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (CGSize)sizeOfString:(NSString*)str withFont:(UIFont*)font constrainedToSize:(CGSize)constrainedToSize lineBreakMode:(NSLineBreakMode)lineBreakMode;
+ (NSString *) hexFromUIColor:(UIColor *)color;
+ (void)printAllFontNames;
+ (UIColor*)colorWithHexString:(NSString*)hex;
+ (NSString *)hexStringForColor:(UIColor *)color;
+ (BOOL)checkNetWork;
+ (BOOL)checkNetWorkAvailable;
+ (CGFloat)heightForString:(NSString*)str constrainWidth:(CGFloat)width withFont:(UIFont*)font;

+ (CGFloat)widthForString:(NSString*)str constrainHeight:(CGFloat)height withFont:(UIFont*)font;
+ (BOOL) IsValidEmail:(NSString *)checkString;

+ (NSString *) md5:(NSString *) input;

// Add by NghiaNH
+ (NSNumber *)roundedNumber:(NSNumber *)number toPositionRightOfDecimal:(int)position;

+ (BOOL)checkPhoneNumber:(NSString *)phone;

+ (BOOL)checkLocation;

// Added by Tam CO
+ (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToSize:(CGSize)newSize;

// Added by Tam CO
+ (UIImage *)imageWithImage:(UIImage *) sourceImage maxWidth:(CGFloat) maxWidth maxHeight:(CGFloat) maxHeight;

+ (UIImage *)loadImageWithPath:(NSString *)path;
+ (void)removeRecourceWithPath:(NSString *)path;
+ (CGFloat)deviceSizeScale;

+ (float)roundToHalf:(float)val;
+ (NSString *)contentTypeForImageData:(NSData *)data;

+ (NSString *)displayPhonetics:(NSString *)phonetics;
+ (NSString *)strimSpaceWithInput:(NSString *)input;//##12290 ntq- redmine ntq: add a funtion strim space by thuydt

+ (NSString *)japaneseCurrencyFormatStringWithNumber:(NSNumber *)priceValue;
+ (NSString *)japanesCurrencyStringFromNumber:(NSNumber *)price;
+ (void)openMapsWithLongitude:(CGFloat)lon latitude:(CGFloat)lat;
+ (NSString *)japaneseTimeFromMinute:(NSInteger)min;
@end
