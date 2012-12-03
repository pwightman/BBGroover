//
//  BBGroove.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/25/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBGroove.h"

@implementation BBGroove

#pragma mark Convenience Constructors
+ (id) groove {
	BBGroove *groove = [[BBGroove alloc] init];
	return groove;
}

#pragma mark Instance Methods
- (BBGrooverBeat) maxSubdivision {
    return [[_voices valueForKeyPath:@"@max.subdivision"] unsignedIntegerValue];
}

- (void) addVoice:(BBVoice *)object {
    NSMutableArray *newVoices = [NSMutableArray arrayWithArray:_voices];
    [newVoices addObject:newVoices];
    
    _voices = newVoices;
}

@end
