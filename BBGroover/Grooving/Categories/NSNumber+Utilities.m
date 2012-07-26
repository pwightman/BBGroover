//
//  NSNumber+Utilities.m
//  BBGroover
//
//  Created by Parker Wightman on 7/26/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "NSNumber+Utilities.h"

@implementation NSNumber (Utilities)

+ (BOOL) isPowerOfTwo:(NSUInteger)x {
    return (x != 0) && ((x & (x - 1)) == 0);
}

@end
