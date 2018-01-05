//
//  ViewController.m
//  AVAudioPlayer
//
//  Created by Matthew S. Hill on 12/10/14.
//  Copyright (c) 2014 Matthew S. Hill. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@import MediaPlayer;

@interface ViewController (){
    IBOutlet UILabel *_volumeLabel;
    IBOutlet UILabel *_rateLabel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AVAudioSession sharedInstance] outputVolume];
    
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    MPVolumeView *volumeView = [MPVolumeView new];
    for (UIView *view in volumeView.subviews){
        if ([view isKindOfClass:[UISlider class]]) {
            UISlider *volumeSlider = (UISlider *)view;
            volumeSlider.value = 1.0f;
            break;
        }
    }
    // Do any additional setup after loading the view, typically from a nib.
    NSString *path = [NSString stringWithFormat:@"%@/mozart_23_piano_orchestra.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    NSError *error;
    
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:&error];
    
    if (error) {
        NSLog(@"Error in audioPlayer: %@", [error localizedDescription]);
    } else {
        [_audioPlayer prepareToPlay];
        //_audioPlayer.enableRate = YES;
        //_audioPlayer.volume = 0.5f;
        //_audioPlayer.rate = 1.0f;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark AVAudioPlayerDelegate Protocol Methods
- (IBAction)adjustVol:(id)sender {
    _audioPlayer.volume = ((UISlider *)sender).value;
    _volumeLabel.text = [NSString stringWithFormat:@"Volume : %.0f %%", _audioPlayer.volume * 100];
}

- (IBAction)play:(id)sender{
    if(_audioPlayer.playing == YES) {
        [((UIButton *)sender) setTitle:@"Play" forState:UIControlStateNormal];
        [_audioPlayer stop];
    } else {
        [((UIButton *)sender) setTitle:@"Stop" forState:UIControlStateNormal];
        [_audioPlayer play];
    }
}

- (IBAction)chandeRate:(id)sender {
    if (fabs(_audioPlayer.rate - ((UISlider *)sender).value) >= 0.1) {
        _audioPlayer.rate = ((UISlider *)sender).value;
        _rateLabel.text = [NSString stringWithFormat:@"Rate : %.1f x", _audioPlayer.rate];
    }
}

@end
