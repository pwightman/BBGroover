//
//  BBGridView.h
//  BeatBuilder
//
//  Created by Parker Wightman on 7/26/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BBGridViewDelegate;

@interface BBGridView : UIView

@property (nonatomic, assign) IBOutlet id<BBGridViewDelegate> delegate;

@end

@protocol BBGridViewDelegate <NSObject>

- (NSUInteger) rowsForGridView:(BBGridView *)gridView;

- (NSUInteger) gridView:(BBGridView *)gridView columnsForRow:(NSUInteger)row;

- (void) gridView:(BBGridView *)gridView wasSelectedAtRow:(NSUInteger)row column:(NSUInteger)column;

- (BOOL) gridView:(BBGridView *)gridView isSelectedAtRow:(NSUInteger)row column:(NSUInteger)column;

@end