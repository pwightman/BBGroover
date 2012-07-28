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

    BBGroove *groove = [[BBGroove alloc] init];
    groove.tempo = 120;
    groove.beats = 4;
    groove.beatUnit = BBGrooverBeatQuarter;

    BBVoice *bass = [[BBVoice alloc] initWithSubdivision:BBGrooverBeatSixteenth];
    bass.name = @"Bass Drum";
    bass.audioPath = @"bassdrum.wav";
    
    BBVoice *snare = [[BBVoice alloc] initWithSubdivision:BBGrooverBeatSixteenth];
    snare.name = @"Snare drum";
    snare.audioPath = @"snare.wav";
    
    BBVoice *hihat = [[BBVoice alloc] initWithSubdivision:BBGrooverBeatSixteenth];
    hihat.name = @"Hi Hat";
    hihat.audioPath = @"hihat.wav";
    
    groove.voices = @[ bass, snare, hihat ];
    
    _groover = [[BBGroover alloc] initWithGroove:groove];
    _groover.delegate = self;
    
    for (BBVoice *voice in groove.voices) {
        [[OALSimpleAudio sharedInstance] preloadEffect:voice.audioPath];
    }
    
    _tempoSlider.value = groove.tempo;
    [self updateTempo:groove.tempo];
    
}

- (IBAction)sliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    _groover.groove.tempo = (NSUInteger)slider.value;
    
    [self updateTempo:_groover.groove.tempo];
    
}

- (void) updateTempo:(NSUInteger)tempo {
    _tempoLabel.text = [NSString stringWithFormat:@"Tempo = %d", tempo];
}

- (IBAction)startTapped:(id)sender {
    [_groover resumeGrooving];
}

- (IBAction)stopTapped:(id)sender {
    [_groover pauseGrooving];
}

- (void) groover:(BBGroover *)sequencer didTick:(NSUInteger)tick {
    _tickView.currentTick = tick;
    [_tickView setNeedsLayout];
}

- (void) groover:(BBGroover *)sequencer voicesDidTick:(NSArray *)voices {
    for (BBVoice *voice in voices) {
        [[OALSimpleAudio sharedInstance] playEffect:voice.audioPath];
    }
    
}

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

- (NSUInteger) ticksForTickView:(BBTickView *)tickView {
    return [_groover currentSubdivision];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
