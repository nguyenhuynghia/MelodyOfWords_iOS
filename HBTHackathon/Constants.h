//
//  Constants.h
//  App
//
//  Created by HBLab-NghiaNH on 6/3/16.
//  Copyright © 2016 HBLab. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#ifdef DEBUG
    // Development's server
    #define API_ROOT_URL        @"http://10.200.232.51:5000/api/v0/"
#else
    // Customer's server
    #define API_ROOT_URL        @"http://10.200.232.51:5000/api/v0/"
#endif

#define		STATUS_LOADING						1
#define		STATUS_SUCCEED						2
#define		STATUS_MANUAL						3

#define		COLOR_OUTGOING						[Utils colorWithHexString:@"F366B8"]
#define		COLOR_INCOMING						[Utils colorWithHexString:@"ffffff"]

#define TEXT_SENDING       @"SENDING"
#define TEXT_SENT          @"SENT"
#define TEXT_READ          @"READ"
#define INSERT_MESSAGES    10
#define FMESSAGE_PATH      @"Message"
#define FRECENT_PATH       @"Recent"

#define FMESSAGE_TYPE      @"type"
#define FMESSAGE_TEXT      @"text"
#define FMESSAGE_STATUS    @"status"

#define FMESSAGE_PICTURE   @"picture"
#define MESSAGE_TEXT       @"text"
#define MESSAGE_PICTURE    @"picture"
#define FMESSAGE_AUTHOR    @"author"
#define FMESSAGE_CREATEDAT @"createdAt"

#define _LOGGED_IN_USER_DATA                        @"_LOGGED_IN_USER_DATA"
#define _USER_DEFAULT_KEY_DEVICE_TOKEN              @"_USER_DEFAULT_KEY_DEVICE_TOKEN"
#define _USER_DEFAULT_KEY_DID_REGISTER_DEVICE_TOKEN @"_USER_DEFAULT_KEY_DID_REGISTER_DEVICE_TOKEN"
#define _USER_DEFAULT_KEY_DID_FINISH_FIRST_RUN      @"_USER_DEFAULT_KEY_DID_FINISH_FIRST_RUN"

#define _USER_GENDER_MALE           @"MALE"
#define _USER_GENDER_FEMALE         @"FEMALE"

#define _USER_TYPE_CUSTOMER         @"CUSTOMER"
#define _USER_TYPE_WORKER           @"WORKER"

#define _SALON_ALLOW_GENDER_MALE    @"MALE"
#define _SALON_ALLOW_GENDER_FEMALE  @"FEMALE"
#define _SALON_ALLOW_GENDER_ALL     @"ALL"


#define _SALON_ALLOW_OVERTIME_NIGHT @"NIGHT"
#define _SALON_ALLOW_OVERTIME_EARLY @"EARLY"
#define _SALON_ALLOW_OVERTIME_NONE  @"NONE"
#define _SALON_ALLOW_OVERTIME_ALL   @"ALL"

#define _SALON_FILTER_OPTION_YES    @"YES"
#define _SALON_FILTER_OPTION_NO     @"NO"

#define _MAX_IMAGE_SIZE 1024

typedef enum : NSUInteger {
    SignUpInfoViewSourceTypeFacebook,
    SignUpInfoViewSourceTypeGoogle,
    SignUpInfoViewSourceTypeMail,
    SignUpInfoViewSourceTypeMailSecondStep,
} SignUpInfoViewSourceType;


#define OVERTIME_START_TIME     22
#define OVERTIME_END_TIME       6

#define _API_PAGING_NUM         20
#define _TIME_OUT_PROCESS_BAR   30.f
#endif /* Constants_h */
