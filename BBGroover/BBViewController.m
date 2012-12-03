//
//  BBViewController.m
//  BeatBuilder
//
//  Created by Parker Wightman on 7/21/12.
//  Copyright (c) 2012 Parker Wightman. All rights reserved.
//

#import "BBViewController.h"
#import "BBVoice.h"
#import "BBGroove.h"
#import "OALSimpleAudio.h"

@interface BBViewController ()

@end

@implementation BBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    BBGroove *groove = [BBGroove groove];
    groove.tempo = 120;
    groove.beats = 4;
    groove.beatUnit = BBGrooverBeatQuarter;

    BBVoice *bass = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    bass.name = @"Bass Drum";
    bass.audioPath = @"bassdrum.wav";
    
    BBVoice *snare = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    snare.name = @"Snare drum";
    snare.audioPath = @"snare.wav";
    
    BBVoice *hihat = [BBVoice voiceWithSubdivision:BBGrooverBeatSixteenth];
    hihat.name = @"Hi Hat";
    hihat.audioPath = @"hihat.wav";
    
    groove.voices = @[ bass, snare, hihat ];
    
    _groover = [BBGroover grooverWithGroove:groove];

    _groover.delegate = self;
	
// If you want to use blocks instead, comment out the delegate above and use this instead.
//
//	__block BBTickView *blockTickView = _tickView;
//	
//	_groover.didTickBlock = ^(NSUInteger tick) {
//		blockTickView.currentTick = tick;
//		[blockTickView setNeedsLayout];
//	};
//	
//	_groover.voicesDidTickBlock = ^(NSArray *voices) {
//		for (BBVoice *voice in voices) {
//			[[OALSimpleAudio sharedInstance] playEffect:voice.audioPath];
//		}	
//	};
    
    for (BBVoice *voice in groove.voices) {
        [[OALSimpleAudio sharedInstance] preloadEffect:voice.audioPath];
    }
    
    _tempoSlider.value = groove.tempo;
    [self updateTempo:groove.tempo];
    
}


#pragma mark BBGrooverDelegate Methods
- (void) groover:(BBGroover *)sequencer didTick:(NSUInteger)tick {
    _tickView.currentTick = tick;
    [_tickView setNeedsLayout];
}

- (void) groover:(BBGroover *)sequencer voicesDidTick:(NSArray *)voices {
    for (BBVoice *voice in voices) {
        [[OALSimpleAudio sharedInstance] playEffect:voice.audioPath];
    }
    
}

#pragma mark BBGridViewDelegate Methods
- (NSUInteger) gridView:(BBGridView *)gridView columnsForRow:(NSUInteger)row {
    return [_groover.groove.voices[row] subdivision];
}

- (NSUInteger) rowsForGridView:(BBGridView *)gridView {
    return _groover.groove.voices.count;
}

- (void) gridView:(BBGridView *)gridView wasSelectedAtRow:(NSUInteger)row column:(NSUInteger)column {
    BBVoice *voice = _groover.groove.voices[row];
    
    if ([voice.values[column] boolValue]) {
        [voice setValue:NO forIndex:column];
    } else {
        [voice setValue:YES forIndex:column];
    }
    
    [gridView setNeedsDisplay];
}

- (BOOL) gridView:(BBGridView *)gridView isSelectedAtRow:(NSUInteger)row column:(NSUInteger)column {
    return [[_groover.groove.voices[row] values][column] boolValue];
}

#pragma mark BBTickViewDelegate methods
- (NSUInteger) ticksForTickView:(BBTickView *)tickView {
    return [_groover currentSubdivision];
}

#pragma mark Helper Methods
- (void) updateTempo:(NSUInteger)tempo {
    _tempoLabel.text = [NSString stringWithFormat:@"Tempo = %d", tempo];
}

#pragma mark IBActions
- (IBAction)sliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    _groover.groove.tempo = (NSUInteger)slider.value;
    
    [self updateTempo:_groover.groove.tempo];
    
}

- (IBAction)startTapped:(id)sender {
    [_groover resumeGrooving];
}

- (IBAction)stopTapped:(id)sender {
    [_groover pauseGrooving];
}

@end
