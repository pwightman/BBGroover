# BBGroover

An easy-to-use scheduling/sequencing library for drum beats. [See a video](http://www.youtube.com/watch?v=gFfUUjgRQvE) of it in action (and excuse the out-of-sync audio).

## Installation

Copy all files from the `BBGroover/Grooving` folder into your project. BBGroover uses ARC so be sure to include the `-fobjc-arc` compiler flag to each file in the `Grooving` folder if your project does not use ARC. I plan on creating a CocoaPods spec at some point soon.

This project uses Objective-C features available in the latest LLVM compiler, such as object literals and automagic synthesizing. Only compatible with Xcode 4.5+.

## Usage

The example code below is pulled from the example project included in this repo.

### BBVoice

A voice is a logical playing unit, such as a bass drum, snare, or hihat. Create as many voices as you want with an array of values indicating where the voice "hits":

```
NSArray *values = @[ @NO,  @NO,  @YES, @YES ];
BBVoice *snare = [[BBVoice alloc] initWithValues:values];
snare.name = @"Snare drum";
snare.audioPath = @"snare.wav";
```

You can also create an empty voice and just indicate the subdivision.

```
BBVoice *hihat = [[BBVoice alloc] initWithSubdivision:BBGrooverBeatEighth];
hihat.name = @"Hi Hat";
hihat.audioPath = @"hihat.wav";
```

### BBGroove

A groove stores a collection of voices, as well as other relevant meta data like tempo and time signature:

```
BBGroove *groove = [[BBGroove alloc] init];

groove.voices = @[ snare, hihat ];
groove.tempo = 120;
    
// 4/4 time
groove.beats = 4;
groove.beatUnit = BBGrooverBeatQuarter;
```

### BBGroover

The groover's job is to schedule each voice of the passed-in groove to play at the appropriate time. The groove does not actually play the note, but just notifies a delegate, who can play the audio if it wants.

```
BBGroover *groover = [[BBGroover alloc] initWithGroove:groove];
[groover startGrooving];
```

### BBGrooverDelegate

This method is called every time the groover ticks. Ticks are determined by whichever voice has the highest sibdivision. For example, if the groove's tempo was 60, and the voice with the highest subdivision was 16th notes, then this delegate would be called 16 times every second, whether a voice is actually playing or not.

```
- (void) groover:(BBGroover *)groover didTick:(NSNumber *)tick {
    // You could update the UI to reflect where the groover was ticking, for example.
}
```

This method is similar to the one above, except it will only be called if voice(s) are ticking at a particular subdivision. Here, we're just playing the audio file related to each ticking voice.

```
- (void) groover:(BBGroover *)groover voicesDidTick:(NSArray *)voices {
    for (BBVoice *voice in voices) {
        // Using ObjectAL to play the audio here.
        [[OALSimpleAudio sharedInstance] playEffect:voice.audioPath];
    }
    
}
```

### Block Alternative to Delegate

If you'd prefer, there's also block versions of each delegate method if that's more your thing.

```
groover.didTickBlock = ^(NSUInteger tick) {
    // Update UI
};

groover.voicesDidTickBlock = ^(NSArray *voices) {
    for (BBVoice *voice in voices) {
        [[OALSimpleAudio sharedInstance] playEffect:voice.audioPath];
    }
};
```

Run the project to see it in action. Happy Grooving!

## Contributors

[Parker Wightman](https://github.com/pwightman) ([@parkerwightman](http://twitter.com/parkerwightman))  
