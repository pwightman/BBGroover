//
//  BBVoice.h
//  BeatBuilder
//
//  Created by Parker Wightman on 7/24/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBGroover.h"

@interface BBVoice : NSObject

@property (nonatomic, strong, readonly) NSArray         *values;
@property (nonatomic, strong, readonly) NSArray         *velocities;
@property (nonatomic, strong) NSString                  *name;
@property (nonatomic, strong) NSString                  *audioPath;
@property (nonatomic, assign, readonly) BBGrooverBeat   subdivision;

#pragma mark Initializers
- (id) initWithValues:(NSArray *)values;
- (id) initWithValues:(NSArray *)values andVelocities:(NSArray *)velocities;
- (id) initWithSubdivision:(BBGrooverBeat)subdivision;

#pragma mark Convenience Contructors
+ (id) voiceWithValues:(NSArray *)values;
+ (id) voiceWithValues:(NSArray *)values andVelocities:(NSArray *)velocities;
+ (id) voiceWithSubdivision:(BBGrooverBeat)subdivision;

#pragma mark Instance Methods
- (void) setValue:(BOOL)value forIndex:(NSUInteger)index;
- (void) setVelocity:(float)velocity forIndex:(NSUInteger)index;

@end
