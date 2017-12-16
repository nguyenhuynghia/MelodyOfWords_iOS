//
//  SpellCorrectionResult.h
//  SoundBoard
//
//  Created by Gregory Klein on 3/15/15.
//  Copyright (c) 2015 Pure Virtual Studios, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// Private Class to wrap each pair in the map that is returned by the C++ spell corrector
@interface SpellCorrectionResult : NSObject

@property (nonatomic, copy) NSString* word;
@property (nonatomic) NSUInteger likelihood;
+ (instancetype)resultWithWord:(NSString*)word likelihood:(NSUInteger)likelihood;

@end;
