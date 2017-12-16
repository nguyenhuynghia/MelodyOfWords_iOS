//
//  MIDIManager.h
//  HBTHackathon
//
//  Created by NghiaNH on 12/16/17.
//  Copyright © 2017 NghiaNH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MIKMIDI/MIKMIDI.h>

@interface MIDIManager : NSObject
@property (nonatomic, strong) MIKMIDISequencer *sequencer;
+ (instancetype)sharedInstance;
- (void)playMIDIFileWithPath:(NSString *)filePath;
- (void)playNoteWithValue:(int)noteValue;
- (void)playNoteOn:(NSInteger)note;
- (void)stop;
@end
