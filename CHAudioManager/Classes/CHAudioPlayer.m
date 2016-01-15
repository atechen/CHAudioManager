//
//  CHAudioPlayer.m
//  CHAudioManager
//
//  Created by Alvaro Franco on 21/01/15.
//  Modify by 陈 斐 on 16/1/12.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import "CHAudioPlayer.h"
#import "NSTimer+CHAudioManager.h"

@interface CHAudioPlayer ()
{
    AVPlayer *_audioPlayer;
    NSTimer *_feedbackTimer;
    CHAudioItem *_currentAudioItem;
}
@end

@implementation CHAudioPlayer

- (instancetype)init
{
    if (self = [super init]) {
        _status = CHAudioPlayNone;
        _audioPlayer = [[AVPlayer alloc] initWithPlayerItem:nil];
    }
    return self;
}

#pragma mark - Public 设置播放源方法
- (void) setAudioInfo:(id)audioInfo audioUrlKey:(NSString *)audioUrlKey
{
    NSString *urlStr = nil;
    if ([audioInfo isKindOfClass:[NSString class]]) {
        urlStr = audioInfo;
    }
    urlStr = [audioInfo valueForKey:audioUrlKey];
    _currentAudioItem = [CHAudioItem audioItemWithUrlStr:urlStr];
    [_audioPlayer replaceCurrentItemWithPlayerItem:_currentAudioItem.playerItem];
}

- (void) setAudioItem:(CHAudioItem *)audioItem
{
    _currentAudioItem = audioItem;
    [_audioPlayer replaceCurrentItemWithPlayerItem:_currentAudioItem.playerItem];
}

#pragma mark - play control
#pragma mark play
- (void) play
{
    [_audioPlayer play];
    [_feedbackTimer resumeTimer];
//    [[MPRemoteCommandCenter sharedCommandCenter] playCommand];
    
    _status = CHAudioPlayStart;
}

- (void) playAtSecond:(NSInteger)second
{
    [_audioPlayer seekToTime:CMTimeMake(second, 1)];
}

#pragma mark pause
- (void) pause
{
    [_audioPlayer pause];
    [_feedbackTimer pauseTimer];
//    [[MPRemoteCommandCenter sharedCommandCenter] pauseCommand];
    
    _status = CHAudioPlayPause;
}

#pragma mark resume
- (void) resume
{
    [_audioPlayer seekToTime:CMTimeMake(0, 1)];
}

#pragma mark - 回调
-(void)listenFeedbackUpdatesWithBlock:(feedbackBlock)block andFinishedBlock:(finishedBlock)finishedBlock
{
    CGFloat updateRate = 1;
    
    if (_audioPlayer.rate > 0) {
        updateRate = 1 / _audioPlayer.rate;
    }
    
    _feedbackTimer = [NSTimer scheduledTimerWithTimeInterval:updateRate block:^{
        
        _currentAudioItem.timePlayed = CMTimeGetSeconds(_audioPlayer.currentTime);
        if (block) {
            block(_currentAudioItem);
        }
        
        if (self.statusDictionary[AFSoundStatusDuration] == self.statusDictionary[AFSoundStatusTimeElapsed]) {
            
            [_feedbackTimer pauseTimer];
            _status = CHAudioPlayFinished;
            if (finishedBlock) {
                finishedBlock();
            }
        }
    } repeats:YES];
}

-(NSDictionary *)statusDictionary {
    // 删除Duration和Elapsed的强制int类型转化
    return @{AFSoundStatusDuration: @(CMTimeGetSeconds(_player.currentItem.asset.duration)),
             AFSoundStatusTimeElapsed: @(CMTimeGetSeconds(_player.currentItem.currentTime)),
             AFSoundPlaybackStatus: @(_status)};
}

@end
