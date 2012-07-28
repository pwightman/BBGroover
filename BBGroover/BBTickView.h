//
//  BBTickView.h
//  BeatBuilder
//
//  Created by Parker Wightman on 7/27/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBTickViewDelegate;

@interface BBTickView : UIView

@property (nonatomic, assign) IBOutlet id<BBTickViewDelegate> delegate;
@property (nonatomic, assign) NSUInteger currentTick;

@end

@protocol BBTickViewDelegate <NSObject>
    
- (NSUInteger) ticksForTickView:(BBTickView *)tickView;

@end
