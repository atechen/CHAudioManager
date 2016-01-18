//
//  CHAudioPlayer.m
//  CHAudioManager
//
//  Created by Alvaro Franco on 21/01/15.
//  Modify by 陈 斐 on 16/1/12.
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
NSString * const CHAudioPlayerStatus = @"status";
NSString * const CHAudioPlayerItemDuration = @"duration";
NSString * const CHAudioPlayerItemTimeElapsed = @"timeElapsed";

- (instancetype)init
{
    if (self = [super init]) {
        _status = CHAudioPlayNone;
#warning 使用nil创建AVPlayer是否可以
        _audioPlayer = [[AVPlayer alloc] initWithPlayerItem:nil];
    }
    return self;
}

#pragma mark - Public 设置播放源方法
- (void) setAudioItem:(CHAudioItem *)audioItem
{
    _currentAudioItem = audioItem;
#warning 不确定是否耗时
    [_audioPlayer replaceCurrentItemWithPlayerItem:_currentAudioItem.playerItem];
}

#pragma mark - Play control
#pragma mark play
- (void) play
{
    _status = CHAudioPlayStart;
    [_audioPlayer play];
    [_feedbackTimer resumeTimer];
    [self fetchPlayerItemInfo];
//    [[MPRemoteCommandCenter sharedCommandCenter] playCommand];
}

- (void) playAtSecond:(NSInteger)second
{
    [_audioPlayer seekToTime:CMTimeMake(second, 1)];
}

#pragma mark pause
- (void) pause
{
    _status = CHAudioPlayPause;
    [_audioPlayer pause];
    [_feedbackTimer pauseTimer];
//    [[MPRemoteCommandCenter sharedCommandCenter] pauseCommand];
}

#pragma mark resume
- (void) resume
{
    _status = CHAudioPlayResume;
    [_audioPlayer seekToTime:CMTimeMake(0, 1)];
    // 不知都该用什么？
//    [[MPRemoteCommandCenter sharedCommandCenter] playCommand];
}

#pragma mark - 回调
-(void)listenFeedbackUpdatesWithBlock:(feedbackBlock)block andFinishedBlock:(finishedBlock)finishedBlock
{
    CGFloat updateRate = 1;
    
    if (_audioPlayer.rate > 0) {
        updateRate = 1 / _audioPlayer.rate;
    }
    
    _feedbackTimer = [NSTimer scheduledTimerWithTimeInterval:updateRate block:^{
        //1.
        _currentAudioItem.timePlayed = CMTimeGetSeconds(_audioPlayer.currentTime);
        //2.
        if (block) {
            block(_currentAudioItem);
        }
        //3.
        if (_currentAudioItem.duration == _currentAudioItem.timePlayed) {
            
            [_feedbackTimer pauseTimer];
            _status = CHAudioPlayFinished;
            if (finishedBlock) {
                finishedBlock();
            }
        }
    } repeats:YES];
}

- (void) fetchPlayerItemInfo
{
    _currentAudioItem.duration = CMTimeGetSeconds(_audioPlayer.currentItem.asset.duration);
}

-(NSDictionary *)statusDictionary
{
    return @{CHAudioPlayerItemDuration: @(_currentAudioItem.duration),
             CHAudioPlayerItemTimeElapsed: @(_currentAudioItem.timePlayed),
             CHAudioPlayerStatus: @(_status)};
}

- (void) removeListenFeedback
{
    if ([_feedbackTimer isValid]) {
        [_feedbackTimer invalidate];
    }
    _feedbackTimer = nil;
}

@end
