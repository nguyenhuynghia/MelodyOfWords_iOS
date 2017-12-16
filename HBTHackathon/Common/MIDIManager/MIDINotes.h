//
//  MIDINotes.h
//  HBTHackathon
//
//  Created by NghiaNH on 12/16/17.
//  Copyright © 2017 NghiaNH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIDINotes : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSMutableArray *notes;
@property (nonatomic, strong) NSDictionary *keyMap;
- (void)addNote:(NSString *)text;
- (void)removeLastNote;
- (void)clearNotes;
@end
