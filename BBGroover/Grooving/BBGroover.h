//
//  BBGroover
//  BeatBuilder
//
//  Created by Parker Wightman on 7/21/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum BBGrooverBeat : NSUInteger {
    BBGrooverBeatMin          = 4,
    BBGrooverBeatQuarter      = 4,
    BBGrooverBeatEighth       = 8,
    BBGrooverBeatSixteenth    = 16,
    BBGrooverBeatThirtySecond = 32,
    BBGrooverBeatMax          = 32
} BBGrooverBeat;

@protocol BBGrooverDelegate;

@class BBGroove;

@interface BBGroover : NSObject

@property (nonatomic, assign) NSObject<BBGrooverDelegate> *delegate;
@property (nonatomic, strong) BBGroove *groove;
@property (nonatomic, assign, readonly) BOOL running;
@property (nonatomic, readonly) NSUInteger currentTick;
@property (nonatomic, assign, readonly) BBGrooverBeat currentSubdivision;

#pragma mark Delegate Blocks
@property (nonatomic, strong) void (^didTickBlock)(NSUInteger tick);
@property (nonatomic, strong) void (^voicesDidTickBlock)(NSArray *voices);

#pragma mark Initializers
- (id)initWithGroove:(BBGroove *)groove;
+ (id) grooverWithGroove:(BBGroove *)groove;
	
#pragma mark Instance Methods
- (void) startGrooving;
- (void) stopGrooving;
- (void) pauseGrooving;
- (void) resumeGrooving;
- (NSUInteger) totalTicks;

@end


@protocol BBGrooverDelegate <NSObject>

- (void) groover:(BBGroover *)groover didTick:(NSUInteger)tick;
- (void) groover:(BBGroover *)groover voicesDidTick:(NSArray *)voices;

@end
