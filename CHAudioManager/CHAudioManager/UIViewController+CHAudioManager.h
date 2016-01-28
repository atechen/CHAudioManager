//
//  UIViewController+CHAudioManager.h
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/27.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 注册远程控制后，重写下面的方法，实现点击锁频界面中控制按钮后的响应操作
 */

@protocol CHAudioManagerRemoteControl <NSObject>

@optional
// 远程点击播放按钮
- (void) ch_audioManagerRemoteControlToPlay;
// 远程点击暂停按钮
- (void) ch_audioManagerRemoteControlToPause;
// 远程点击下一首按钮
- (void) ch_audioManagerRemoteControlToNextTrack;
// 远程点击上一首按钮
- (void) ch_audioManagerRemoteControlToPreviousTrack;

- (void) ch_audioManagerRemoteControlToBeginSeekingBackward;
- (void) ch_audioManagerRemoteControlToEndSeekingBackward;
- (void) ch_audioManagerRemoteControlToBeginSeekingForward;
- (void) ch_audioManagerRemoteControlToEndSeekingForward;
- (void) ch_audioManagerRemoteControlToTogglePlayPause;
@end


@interface UIViewController (CHAudioManager)<CHAudioManagerRemoteControl>

@end
