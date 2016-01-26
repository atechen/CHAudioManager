//
//  CHAudioPlayer.m
//  CHAudioManager
//
//  Created by Alvaro Franco on 21/01/15.
//  Modify by 陈 斐 on 16/1/12.
//

#import "CHAudioPlayer.h"
#import "NSTimer+CHAudioManager.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface CHAudioPlayer ()
{
    AVPlayer *_audioPlayer;
    NSTimer *_feedbackTimer;
    CHAudioItem *_currentAudioItem;
    
//    UIBackgroundTaskIdentifier _playerBgTaskID;
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
        _audioPlayer = [[AVPlayer alloc] init];
        
        
//        _playerBgTaskID = 0;
    }
    return self;
}

#pragma mark - 后台播放和远程控制
- (void) registerBackgroundPlay
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}
- (void) registerRemoteControlEvents
{
/*
 1.定义个fatherController
 2.使用运行时重写 - (void) remoteControlReceivedWithEvent:(UIEvent *)receivedEvent 方法
 */
}


#pragma mark - Public 设置播放源方法
- (void) setAudioItem:(CHAudioItem *)audioItem
{
    _currentAudioItem = audioItem;
    [self playAtSecond:0];
    [_audioPlayer replaceCurrentItemWithPlayerItem:_currentAudioItem.playerItem];
}

#pragma mark - Play control
#pragma mark play
- (void) play
{
//    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {// 后台播放
//        UIApplication *application = [UIApplication sharedApplication];
//        UIBackgroundTaskIdentifier newTask = [application beginBackgroundTaskWithExpirationHandler:nil];
//        if (_playerBgTaskID != UIBackgroundTaskInvalid) {
//            [application endBackgroundTask: _playerBgTaskID];
//        }
//        _playerBgTaskID = newTask;
//    }
    
    _status = CHAudioPlayStart;
    [_audioPlayer play];
    [_feedbackTimer resumeTimer];
    // 此时获取音频数据，耗时少
    [_currentAudioItem fetchMetadata];
    [self configNowPlayingInfoCenter];
}

- (void) playAtSecond:(NSInteger)second
{
    [_audioPlayer seekToTime:CMTimeMake(second, 1)];
}

#pragma mark pause
- (void) pause
{
//    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {// 后台播放
//        UIApplication *application = [UIApplication sharedApplication];
//        UIBackgroundTaskIdentifier newTask = [application beginBackgroundTaskWithExpirationHandler:nil];
//        if (_playerBgTaskID != UIBackgroundTaskInvalid) {
//            [application endBackgroundTask: _playerBgTaskID];
//        }
//        _playerBgTaskID = newTask;
//    }
    
    _status = CHAudioPlayPause;
    [_audioPlayer pause];
    [_feedbackTimer pauseTimer];
}

#pragma mark resume
- (void) resume
{
//    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {// 后台播放
//        UIApplication *application = [UIApplication sharedApplication];
//        UIBackgroundTaskIdentifier newTask = [application beginBackgroundTaskWithExpirationHandler:nil];
//        if (_playerBgTaskID != UIBackgroundTaskInvalid) {
//            [application endBackgroundTask: _playerBgTaskID];
//        }
//        _playerBgTaskID = newTask;
//    }
    
    _status = CHAudioPlayResume;
    [_audioPlayer seekToTime:CMTimeMake(0, 1)];
}

#pragma mark finish
- (void) finish
{
//    if([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {// 后台播放
//        UIApplication *application = [UIApplication sharedApplication];
//        if (_playerBgTaskID != UIBackgroundTaskInvalid) {
//            [application endBackgroundTask: _playerBgTaskID];
//        }
//    }
    
    [_feedbackTimer pauseTimer];
    _status = CHAudioPlayFinished;
}

#pragma mark - 回调
- (void) listenFeedbackUpdatesWithBlock:(feedbackBlock)block andFinishedBlock:(finishedBlock)finishedBlock
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
            
            [self finish];
            if (finishedBlock) {
                finishedBlock();
            }
        }
    } repeats:YES];
}

//一般在每次切换歌曲或者更新信息的时候要调用这个方法
- (void)configNowPlayingInfoCenter
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        
        NSMutableDictionary *playingAudioDic = [[NSMutableDictionary alloc] init];
        [playingAudioDic setObject:_currentAudioItem.audioTitle forKey:MPMediaItemPropertyTitle];
        [playingAudioDic setObject:_currentAudioItem.audioArtist forKey:MPMediaItemPropertyArtist];
        [playingAudioDic setObject:_currentAudioItem.albumTitle forKey:MPMediaItemPropertyAlbumTitle];
        
//        UIImage *newImage = [UIImage imageNamed:@"pause.png"];
        MPMediaItemArtwork *mArt = [[MPMediaItemArtwork alloc] initWithImage:_currentAudioItem.frontcoverImage];
        [playingAudioDic setObject:mArt forKey:MPMediaItemPropertyArtwork];
        
//        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:playingAudioDic];
    }
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

#pragma mark - 
// 退到后台响应
- (void) resignActiveNotificationResponse
{
    
}

// 回到前台响应
- (void) becomeActiveNotificationResponse
{
    
}


- (void) remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause");
                [self play];
                break;
            case UIEventSubtypeRemoteControlPlay:
                NSLog(@"UIEventSubtypeRemoteControlPlay");
                [self play];
                break;
            case UIEventSubtypeRemoteControlPause:
                NSLog(@"UIEventSubtypeRemoteControlPause");
                [self pause];
                break;
            default:
                break;
        }
    }
}

- (void)dealloc
{
    NSLog(@"CHAudioPlayer---dealloc");
}

@end
