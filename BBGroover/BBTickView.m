//
//  BBTickView.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/27/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBTickView.h"

@interface BBTickView ()

@property (nonatomic, strong) UIView *tick;

@end

@implementation BBTickView

- (void) awakeFromNib
{
    _currentTick = 0;
    _tick = [[UIView alloc] init];
    _tick.backgroundColor = [UIColor blackColor];
    [self addSubview:_tick];
}

- (void) layoutSubviews {
    NSUInteger ticks = [_delegate ticksForTickView:self];
    
    CGRect rect = self.frame;
    
    float width  = rect.size.width / ticks;
    float height = rect.size.height;
    float x      = width * _currentTick;
    float y      = 0;
    
    _tick.frame = CGRectMake(x, y, width, height);
}

@end
