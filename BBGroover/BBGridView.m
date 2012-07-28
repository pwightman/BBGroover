//
//  BBGridView.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/26/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBGridView.h"

@implementation BBGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSUInteger rows = [_delegate rowsForGridView:self];
    
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < rows; i++) {

        NSUInteger columns = [_delegate gridView:self columnsForRow:i];
        
        for (int j = 0; j < columns; j++) {
            float height = rect.size.height / rows;
            float width  = rect.size.width  / columns;
            float x      = j * width;
            float y      = i * height;

            if ([_delegate gridView:self isSelectedAtRow:i column:j]) {
                CGContextSetRGBFillColor(cxt, 0.4, 0.4, 0.4, 1);
                CGContextSetRGBStrokeColor(cxt, 1, 1, 1, 1);
            } else {
                CGContextSetRGBFillColor(cxt, 1, 1, 1, 1);
                CGContextSetRGBStrokeColor(cxt, 0, 0, 0, 1);
            }
            
            CGContextStrokeRect(cxt, CGRectMake(x, y, width, height));
            CGContextFillRect(cxt, CGRectMake(x, y, width, height));
        }
    }
    
    CGContextSetRGBStrokeColor(cxt, 0, 0, 0, 1);
    CGContextStrokeRect(cxt, rect);
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    NSUInteger row = (NSUInteger)(point.y / (self.bounds.size.height / [_delegate rowsForGridView:self]));
    NSUInteger column = (NSUInteger)(point.x / (self.bounds.size.width / [_delegate gridView:self columnsForRow:row]));
    
    [_delegate gridView:self wasSelectedAtRow:row column:column];

}

@end
