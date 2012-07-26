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

- (void) startGrooving;
- (void) stopGrooving;
- (void) pauseGrooving;
- (void) resumeGrooving;
- (NSUInteger) totalTicks;
- (id)initWithGroove:(BBGroove *)groove;

@end

@protocol BBGrooverDelegate <NSObject>

- (void) groover:(BBGroover *)groover didTick:(NSNumber *)tick;
- (void) groover:(BBGroover *)groover voicesDidTick:(NSArray *)voices;

@end
