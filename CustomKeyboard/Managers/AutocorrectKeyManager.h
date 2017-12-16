//
//  AutocorrectKeyManager.h
//  SoundBoard
//
//  Created by Gregory Klein on 3/14/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyboardTypedefs.h"

@class AutocorrectKeyController;
@interface AutocorrectKeyManager : NSObject

+ (instancetype)sharedManager;

- (void)setAutocorrectKeyController:(AutocorrectKeyController*)controller
                       withPriority:(AutocorrectKeyControllerPriority)priority;

- (void)updateControllersWithTextInput:(NSString*)text;
- (BOOL)triggerPrimaryKeyIfPossible;

@end
