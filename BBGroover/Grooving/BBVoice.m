//
//  BBVoice.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/24/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBVoice.h"
#import "NSNumber+Utilities.h"

@interface BBVoice ()
@property (nonatomic, strong) NSMutableArray *mutValues;
@end

@implementation BBVoice

- (id) initWithValues:(NSArray *)values {
    self = [super init];
    
    if (self) {
        if (values.count < BBGrooverBeatMin ||
            values.count > BBGrooverBeatMax ||
            ![NSNumber isPowerOfTwo:values.count]) {
            @throw [NSException exceptionWithName:@"Invalid Values" reason:[NSString stringWithFormat:@"The values array of BBVoice object was %d, must match a length in BBGrooverBeat enum (4/8/16/32).", values.count] userInfo:nil];
        }
        _mutValues = [NSMutableArray arrayWithArray:values];
        _values = _mutValues;
        _subdivision = values.count;
    }
    
    return self;
}

- (id) initWithSubdivision:(BBGrooverBeat)subdivision {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:subdivision];
    
    for (NSUInteger i = 0; i < subdivision; i++) {
        array[i] = @NO;
    }
    
    return [self initWithValues:array];
}

- (void) setValue:(BOOL)value forIndex:(NSUInteger)index {
    _mutValues[index] = @(value);
}

@end
