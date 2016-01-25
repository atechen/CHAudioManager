//
//  AudioTableViewCell.m
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/19.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import "AudioTableViewCell.h"

@interface AudioTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelLeftSpaceConstraint;

@end

@implementation AudioTableViewCell

- (void) setSelected:(BOOL)selected played:(BOOL)played
{
    if (selected) {
        self.playIndicatorImageView.hidden = NO;
        self.contentLabelLeftSpaceConstraint.constant = 35;
        
        if (played) {// 播放
            self.playIndicatorImageView.image = [UIImage imageNamed:@"play"];
        }
        else {
            self.playIndicatorImageView.image = [UIImage imageNamed:@"pause"];
        }
    }
    else {
        self.playIndicatorImageView.hidden = YES;
        self.contentLabelLeftSpaceConstraint.constant = 0;
    }
}

@end
