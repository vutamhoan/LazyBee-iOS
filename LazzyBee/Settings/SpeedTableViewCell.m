//
//  SpeedTableViewCell.m
//  LazzyBee
//
//  Created by HuKhong on 9/10/15.
//  Copyright (c) 2015 Born2go. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "SpeedTableViewCell.h"
#import "Common.h"

@implementation SpeedTableViewCell

- (void)awakeFromNib {
    // Initialization code
    NSNumber *speedNumberObj = [[Common sharedCommon] loadDataFromUserDefaultStandardWithKey:@"SpeakingSpeed"];
    
    if (speedNumberObj) {
        [speedSlider setValue:[speedNumberObj floatValue]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)sliderchangeValue:(id)sender {
    NSNumber *speedNumberObj = [NSNumber numberWithFloat:[speedSlider value]];
    [[Common sharedCommon] saveDataToUserDefaultStandard:speedNumberObj withKey:@"SpeakingSpeed"];

}

- (IBAction)valueChangeEnd:(id)sender {
    
    AVSpeechSynthesizer *synthesizer = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"This is to adjust speaking speed. Thank you for using lazy bee application."];

    [utterance setRate:[speedSlider value]];
    [synthesizer speakUtterance:utterance];
}


@end
