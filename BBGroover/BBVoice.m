//
//  BBVoice.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/24/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBVoice.h"
#import "NSNumber+Utilities.h"

@implementation BBVoice

- (id) initWithValues:(NSArray *)values {
    self = [super init];

    if (self) {
        if (values.count < BBGrooverBeatMin ||
            values.count > BBGrooverBeatMax ||
            ![NSNumber isPowerOfTwo:values.count]) {
            @throw [NSException exceptionWithName:@"Invalid Values" reason:[NSString stringWithFormat:@"The values array of BBVoice object was %d, must match a length in BBGrooverBeat enum (4/8/16/32).", values.count] userInfo:nil];
        }
        
        _values = values;
        _subdivision = values.count;
    }
    
    return self;

}

@end
