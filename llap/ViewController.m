//
//  ViewController.m
//  llap
//
//  Created by Ke Sun on 5/18/17.
//  Copyright © 2016 Nanjing University. All rights reserved.
//

#import "ViewController.h"
#import "AudioController.h"


@interface ViewController (){
    AudioController *audioController;
    AVAudioPlayer *musicPlayer;
}

@property (weak, nonatomic) IBOutlet UILabel *gesture;

@property (weak, nonatomic) IBOutlet UILabel *distanceRead;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@end
int lastTime = 0;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString *file = [NSString stringWithFormat:@"%@/summer.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *music = [NSURL fileURLWithPath:file];
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL: music error: nil];
    audioController = [[AudioController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(performDisUpdate:) name:@"AudioDisUpdate" object:nil];
    [_slider setValue: 0.0];
    [_distanceRead setText: @"0"];
    _gesture.text = @"Ready for Playing Music";
    [self.view addSubview: _slider];
}
- (IBAction)playbutton:(UIButton *)sender {
    [musicPlayer play];
    _gesture.text = @"Ready for Controlling Music Playing";
    audioController.audiodistance=0;
    [audioController startIOUnit];
    
}
- (IBAction)stopbutton:(UIButton *)sender {
    [musicPlayer stop];
    _gesture.text = @"Ready for Playing Music";
    [audioController stopIOUnit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)performDisUpdate:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        int tempdis=(int) audioController.audiodistance/DISPLAY_SCALE;
        if ((audioController.audiodistance-lastTime)>5) {
            _gesture.text = @"Music Paused";
            [musicPlayer pause];
        }
        _slider.value=(audioController.audiodistance-DISPLAY_SCALE*tempdis)/DISPLAY_SCALE;
        NSString* myNewString = [NSString stringWithFormat:@"%.01f", audioController.audiodistance];
        _distanceRead.text=myNewString;
        lastTime = audioController.audiodistance;
    });

}

@end
