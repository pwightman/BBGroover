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

    // Grooves simply hold all metadata related to playing a drum beat, including the
    // tempo, time signature, and any arbitrary number of voices.
    BBGroove *groove = [[BBGroove alloc] init];

    groove.tempo = 120;
    
    // 4/4 time
    groove.beats = 4;
    groove.beatUnit = BBGrooverBeatQuarter;
    
    // A voice is one logical set of beats and a sound, such as a bass drum, snare, or hihat.
    // A voice consists of a sound file related to the voice, a subdivision for how granular
    // it is (16th, 8th, etc.) and an array of boolean values indicating where the voice
    // should hit. The subdivision is inferred from the array length, which ought to be
    // length 4/8/16/32, which are the values of the BBGrooverBeat enum defined in BBGroover.h.
    NSArray *values = @[ @YES, @NO,  @NO,  @YES, @NO,  @YES, @NO,  @NO,
                         @YES, @NO,  @YES, @YES, @NO,  @YES, @YES, @NO  ];
    BBVoice *bass = [[BBVoice alloc] initWithValues:values];
    bass.name = @"Bass Drum";
    bass.audioPath = @"bassdrum.wav";
    
    values = @[ @NO,  @NO,  @YES, @YES ];
    BBVoice *snare = [[BBVoice alloc] initWithValues:values];
    snare.name = @"Snare drum";
    snare.audioPath = @"snare.wav";
    
    values = @[ @YES, @YES, @YES, @YES, @YES, @YES, @YES, @YES ];
    BBVoice *hihat = [[BBVoice alloc] initWithValues:values];
    hihat.name = @"Hi Hat";
    hihat.audioPath = @"hihat.wav";

    // Set the groove's voices array
    groove.voices = @[ bass, snare, hihat ];
    
    // The groover's job is to schedule each voice of the passed-in groove to play at the
    // appropriate time. The groove does not actually play the note, but just notifies a
    // delegate, who can play the audio if it wants.
    _groover = [[BBGroover alloc] initWithGroove:groove];
    _groover.delegate = self;
    
    // Use ObjectAL to preload the sound files for each voice so they're no delayed when
    // playing them for the first time.
    for (BBVoice *voice in groove.voices) {
        [[OALSimpleAudio sharedInstance] preloadEffect:voice.audioPath];
    }
    
    // Update the UI.
    _tempoSlider.value = groove.tempo;
    [self updateTempo:groove.tempo];

}




#pragma mark BBGroover delegate methods

// This method is called everytime the groover ticks. Ticks are determined by whichever
// voice has the highest sibdivision. For example, if the groove's tempo was 60, and the
// voice with the highest subdivision was 16th notes, then this delegate would be called
// 16 times every second.
- (void) groover:(BBGroover *)sequencer didTick:(NSNumber *)tick {
    // You could update the UI to reflect where the groover was in its ticking, for example.
}

// This method is similar to the one above, except it will only be called if voice(s) are
// ticking at a particular subdivision. Here, we're just playing the audio file related to
// each ticking voice.
- (void) groover:(BBGroover *)sequencer voicesDidTick:(NSArray *)voices {
    for (BBVoice *voice in voices) {
        [[OALSimpleAudio sharedInstance] playEffect:voice.audioPath];
    }
    
}




#pragma mark IBActions

- (IBAction)sliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
    _groover.groove.tempo = (NSUInteger)slider.value;
    
    NSLog(@"%d", _groover.groove.tempo);
    
    [self updateTempo:_groover.groove.tempo];
    
}

- (void) updateTempo:(NSUInteger)tempo {
    _tempoLabel.text = [NSString stringWithFormat:@"Tempo = %d", tempo];
}

- (IBAction)startTapped:(id)sender {
    [_groover resume];
}

- (IBAction)stopTapped:(id)sender {
    [_groover pause];
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
