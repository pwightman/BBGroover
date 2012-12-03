//
//  BBGroover.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/21/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBGroover.h"
#import "BBGroove.h"
#import "BBVoice.h"
#include <mach/mach_time.h>

@interface BBGroover ()

@end


@implementation BBGroover

#pragma mark Initializers
- (id) initWithGroove:(BBGroove *)groove {
    self = [super init];
    
    if (self) {
        _running = NO;
        _groove = groove;
        _currentSubdivision = [groove maxSubdivision];
        _currentTick = 0;
    }
    
    return self;
}

+ (id) grooverWithGroove:(BBGroove *)groove {
	BBGroover *groover = [[self alloc] initWithGroove:groove];
	return groover;
}

#pragma mark Instance Methods
- (void) startGrooving {
    [self startAtTick:0];
}

- (void) startAtTick:(NSUInteger)tick {
    if (!_running) {
        _running = YES;
        [NSThread detachNewThreadSelector:@selector(run:) toTarget:self withObject:@(tick)];
    }
}

- (void) pauseGrooving {
    _running = NO;
}

- (void) resumeGrooving {
    if (_currentTick) {
        [self startAtTick:_currentTick];
    } else {
        [self startGrooving];
    }
	
}

- (void) stopGrooving {
    _running = NO;
    _currentTick = 0;
}

- (NSUInteger) totalTicks {
    return (_groove.beats * _currentSubdivision)/_groove.beatUnit;
    
}


#pragma mark Private Methods
- (uint64_t) computeInterval {
    // The default interval we're working with is 1 second (1 billion nanoseconds)
    uint64_t interval = 1000 * 1000 * 1000;
    
    // We find what fraction of a second the tempo really is. For example, a tempo of 60
    // would be 60/60 == 1 second, a tempo of 61 would be 60/61 == 0.984, etc.
    double intervalFraction = 60.0/_groove.tempo;
    
    // Turn this back into nanoseconds
    interval = (uint64_t)(interval * intervalFraction);
    
    return interval;
}

- (void) run:(NSNumber *)tick {
    
    _currentTick = [tick unsignedIntValue];
    
    NSLog(@"%ui", _currentSubdivision);
    
    
    uint64_t interval = [self computeInterval];
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    uint64_t currentTime = mach_absolute_time();
    
    currentTime *= info.numer;
    currentTime /= info.denom;
    
    // totalTicks is the number of
    NSUInteger totalTicks = [self totalTicks];
    if (totalTicks == 0) {
        @throw [NSException exceptionWithName:@"Invalid Subdivision" reason:[NSString stringWithFormat:@"Subdivision %ui is too large to be expressed in %ui/%ui time.", _currentSubdivision, _groove.beats, _groove.beatUnit] userInfo:nil];
        
        
    }
    
    uint64_t nextTime = currentTime;
    
    // Save ourselves a function call within the loop
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    while (_running) {
        if (currentTime >= nextTime) {
            
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                
                /*
                 
                 Each voice could have a different subdivision, though the subdivision is
                 guaranteed to be less than or equal to _currentSubdivision, which is derived
                 from the voice with the highest subdivision. So if the _currentSubdivision
                 were 16th notes, and the voice we're evaluating is quarter notes, we want
                 to space the quarter notes out to their correct place within the 16th note
                 subdivision (specifically, 0, 4, 8, 12).
                 
                 */
                
                // Grab out the subdivision of the current voice
                BBGrooverBeat subdivision = [evaluatedObject subdivision];
                
                // Create a factor.
                NSUInteger divisor = _currentSubdivision / subdivision;
                
                // We only want the voice to play on the correct tick. Following the above
                // example, You would only want 0, 4, 8, 12, or in other words, if the
                // _currentTick % 4 == 0. 4 being the divisor obtained above.
                if ( (_currentTick) % divisor == 0) {
                    return [[evaluatedObject values][(_currentTick) / divisor] boolValue];
                } else {
                    return FALSE;
                }
            }];
            
            NSArray *tickingVoices = [_groove.voices filteredArrayUsingPredicate:predicate];
            
            NSUInteger blockTick = _currentTick;
            
            dispatch_async(mainQueue, ^{
                
                [_delegate groover:self didTick:blockTick];
				
				if (_didTickBlock) {
					_didTickBlock(blockTick);
				}
                
                if (tickingVoices.count > 0) {
                    [_delegate groover:self voicesDidTick:tickingVoices];
					
					if (_voicesDidTickBlock) {
						_voicesDidTickBlock(tickingVoices);
					}
                }
                
            });
            
            _currentTick = (_currentTick + 1) % (totalTicks);
            interval = [self computeInterval];
            nextTime += interval / (_currentSubdivision / 4);
        }
        
        currentTime = mach_absolute_time();
        currentTime *= info.numer;
        currentTime /= info.denom;
        
        
    }
}



#pragma mark Utilities

@end