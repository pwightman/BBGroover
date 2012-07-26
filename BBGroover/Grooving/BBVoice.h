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

@property (nonatomic, strong, readonly) NSArray *values;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *audioPath;
@property (nonatomic, assign, readonly) BBGrooverBeat subdivision;

- (id) initWithValues:(NSArray *)values;

@end
