//
//  BBGroove.h
//  BeatBuilder
//
//  Created by Parker Wightman on 7/25/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBVoice.h"
#import "BBGroover.h"

@interface BBGroove : NSObject

@property (nonatomic, strong) NSArray *voices;

@property (nonatomic, assign) NSUInteger tempo;
@property (nonatomic, assign) BBGrooverBeat beatUnit;
@property (nonatomic, assign) NSUInteger beats;


- (void) addVoice:(BBVoice *)object;
- (BBGrooverBeat) maxSubdivision;

@end
