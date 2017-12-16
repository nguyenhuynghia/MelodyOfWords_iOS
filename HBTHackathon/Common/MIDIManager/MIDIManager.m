//
//  MIDIManager.m
//  HBTHackathon
//
//  Created by NghiaNH on 12/16/17.
//  Copyright © 2017 NghiaNH. All rights reserved.
//

#import "MIDIManager.h"

@implementation MIDIManager
+ (instancetype)sharedInstance
{
    static MIDIManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MIDIManager alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (instancetype) init {
    if (self == [super init]) {
        self.sequencer = [MIKMIDISequencer new];
    }
    return self;
}

- (void)playMIDIFileWithPath:(NSString *)filePath {
    if (self.sequencer && self.sequencer.isPlaying) {
        [self.sequencer stop];
    }
    NSError *error = nil;
    if (filePath.length == 0) {
        return;
    }
    
    MIKMIDISequence *sequence = [MIKMIDISequence sequenceWithFileAtURL:[NSURL fileURLWithPath: filePath] error:&error];
    self.sequencer = [MIKMIDISequencer sequencerWithSequence:sequence];
    [self configureSequencer:sequence];
    [self.sequencer startPlayback];
}

- (void)stop {
    if (self.sequencer && self.sequencer.isPlaying) {
        [self.sequencer stop];
    }
}

- (void) configureSequencer:(MIKMIDISequence *)sequence {
    NSURL * soundfontURL = [[NSBundle mainBundle] URLForResource:@"piano" withExtension:@"sf2"];
    NSError *err = nil;
    for (MIKMIDITrack* track in sequence.tracks) {
        if (!self.sequencer) {
            self.sequencer = [MIKMIDISequencer new];
        }
        self.sequencer.sequence = sequence;
        MIKMIDISynthesizer* synth =  [self.sequencer builtinSynthesizerForTrack:track];
        [synth loadSoundfontFromFileAtURL:soundfontURL error:&err];
    }
}

//- (void)playNoteWithValue:(int)noteValue {
//    NSDate *date = [NSDate date];
//    MIKMIDINoteOnCommand *noteOn = [MIKMIDINoteOnCommand noteOnCommandWithNote:60 velocity:127 channel:0 timestamp:date];
//    MIKMIDINoteOffCommand *noteOff = [MIKMIDINoteOffCommand noteOffCommandWithNote:60 velocity:0 channel:0 timestamp:[date dateByAddingTimeInterval:0.5]];
//    MIKMIDIDestinationEndpoint *endpoint = [MIKMIDIDestinationEndpoint ];
//
//    MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];
//    [dm sendCommands:@[noteOn, noteOff] toEndpoint:endpoint error:nil];
//}

- (void)playNoteOn:(NSInteger)note {
    MIKMutableMIDINoteOnCommand *noteOn = [MIKMutableMIDINoteOnCommand commandForCommandType:MIKMIDICommandTypeNoteOn];
    noteOn.note = (NSUInteger) note;
    noteOn.velocity = 100;
    NSDate *date = [NSDate date];

    noteOn.timestamp = [date dateByAddingTimeInterval:0.5];
    noteOn.midiTimestamp = [date dateByAddingTimeInterval:1.0];
    
    NSMutableArray *destinations = [NSMutableArray array];
    
    for (MIKMIDIDevice *device in [[MIKMIDIDeviceManager sharedDeviceManager] availableDevices]) {
        for (MIKMIDIEntity *entity in [device.entities valueForKeyPath:@"@unionOfArrays.destinations"]) {
            [destinations addObject:entity];
        }
    }
    
    //  NSArray *destinations = [self.device.entities valueForKeyPath:@"@unionOfArrays.destinations"];
    if (![destinations count]) return;
    for (MIKMIDIDestinationEndpoint *destination in destinations) {
        NSError *error = nil;
        MIKMIDIDeviceManager *dm = [MIKMIDIDeviceManager sharedDeviceManager];

        if(![dm sendCommands:@[noteOn] toEndpoint:destination error:&error]) {
            NSLog(@"Unable to send command %@ to endpoint %@: %@", noteOn, destination, error);
        }
    }
}

@end
