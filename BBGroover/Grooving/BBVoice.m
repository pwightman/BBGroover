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
@end

@implementation BBVoice

#pragma mark Initializers
- (id) initWithValues:(NSArray *)values {
    return [self initWithValues:values andVelocities:[self defaultVelocities:values.count]];
}

- (id) initWithValues:(NSArray *)values andVelocities:(NSArray *)velocities {
	self = [super init];
    
    if (self) {
        if (values.count < BBGrooverBeatMin ||
            values.count > BBGrooverBeatMax ||
            ![NSNumber isPowerOfTwo:values.count]) {
            @throw [NSException exceptionWithName:@"Invalid Values" reason:[NSString stringWithFormat:@"The values array of BBVoice object was %d, must match a length in BBGrooverBeat enum (4/8/16/32).", values.count] userInfo:nil];
        }
        _values = [NSMutableArray arrayWithArray:values];
		_velocities = [NSMutableArray arrayWithArray:velocities];
		
		// Just in case
		if (!_velocities) {
			_velocities = [self defaultVelocities:values.count];
		}
		
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

#pragma mark Convenience Contructors
+ (id) voiceWithValues:(NSArray *)values {
	BBVoice *voice = [[self alloc] initWithValues:values];
	return voice;
}

+ (id) voiceWithValues:(NSArray *)values andVelocities:(NSArray *)velocities {
	BBVoice *voice = [[self alloc] initWithValues:values andVelocities:velocities];
	return voice;
}

+ (id) voiceWithSubdivision:(BBGrooverBeat)subdivision {
	BBVoice *voice = [[self alloc] initWithSubdivision:subdivision];
	return voice;
}

#pragma mark Instance Methods
- (void) setValue:(BOOL)value forIndex:(NSUInteger)index {
    [self mutValues][index] = @(value);
}

- (void) setVelocity:(float)velocity forIndex:(NSUInteger)index {
	[self mutVelocities][index] = @(velocity);
}

#pragma mark Private Methods
- (NSMutableArray *) mutValues {
	return (NSMutableArray *)_values;
}

- (NSMutableArray *) mutVelocities {
	return (NSMutableArray *)_velocities;
}

- (NSMutableArray *) defaultVelocities:(NSInteger)count {
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
	
	for (NSUInteger i = 0; i < count; i++) {
		array[i] = @1.0f;
	}
	
	return array;
}

@end
