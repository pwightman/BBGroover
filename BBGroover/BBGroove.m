//
//  BBGroove.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/25/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBGroove.h"

@implementation BBGroove

- (BBGrooverBeat) maxSubdivision {
    return [[_voices valueForKeyPath:@"@max.subdivision"] unsignedIntegerValue];
}

- (void) addVoice:(BBVoice *)object {
    NSMutableArray *newVoices = [NSMutableArray arrayWithArray:_voices];
    [newVoices addObject:newVoices];
    
    _voices = newVoices;
}

@end
