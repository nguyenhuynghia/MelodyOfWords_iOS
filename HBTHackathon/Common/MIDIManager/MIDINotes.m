//
//  MIDINotes.m
//  HBTHackathon
//
//  Created by NghiaNH on 12/16/17.
//  Copyright © 2017 NghiaNH. All rights reserved.
//

#import "MIDINotes.h"

@implementation MIDINotes
+ (instancetype)sharedInstance
{
    static MIDINotes *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MIDINotes alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (instancetype) init {
    if (self == [super init]) {
        NSDictionary *notes = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"keyMap" ofType:@"plist"]];
        self.keyMap = notes;
    }
    return self;
}

- (void)addNote:(NSString *)text {
    NSArray *values = [self.keyMap safeObjectForKey:[text lowercaseString]];
    if (values.count > 0) {
        if (self.notes == nil) {
            self.notes = [NSMutableArray new];
        }
        NSInteger i = 0;
        if (values.count > 1) {
            i = arc4random() % values.count;
        }
        [self.notes addObject:[values objectAtIndex:i]];
    }
}

- (void)removeLastNote {
    if (self.notes.count > 0) {
        [self.notes removeObjectAtIndex:self.notes.count -1];
    }
}

- (void)clearNotes {
    self.notes = [NSMutableArray new];
}

@end
