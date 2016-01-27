//
//  UIViewController+CHAudioManager.h
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/27.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHAudioManagerRemoteControl <NSObject>

@optional
- (void) ch_audioManagerRemoteControlToPlay;
- (void) ch_audioManagerRemoteControlToPause;
- (void) ch_audioManagerRemoteControlToNextTrack;
- (void) ch_audioManagerRemoteControlToPreviousTrack;

- (void) ch_audioManagerRemoteControlToBeginSeekingBackward;
- (void) ch_audioManagerRemoteControlToEndSeekingBackward;
- (void) ch_audioManagerRemoteControlToBeginSeekingForward;
- (void) ch_audioManagerRemoteControlToEndSeekingForward;
- (void) ch_audioManagerRemoteControlToTogglePlayPause;
@end


@interface UIViewController (CHAudioManager)<CHAudioManagerRemoteControl>

@end
