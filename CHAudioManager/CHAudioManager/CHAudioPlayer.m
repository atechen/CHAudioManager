//
//  CHAudioPlayer.m
//  CHAudioManager
//
//  Created by Alvaro Franco on 21/01/15.
//  Modify by 陈 斐 on 16/1/12.
//

#import <MediaPlayer/MediaPlayer.h>
#import <objc/runtime.h>

#import "CHAudioPlayer.h"
#import "NSTimer+CHAudioManager.h"
#import "UIViewController+CHAudioManager.h"
#import "NSObject+CHAudioManager.h"


@interface CHAudioPlayer ()
{
    AVPlayer *_audioPlayer;
    NSTimer *_feedbackTimer;
    CHAudioItem *_currentAudioItem;
    
    __weak UIViewController *_remoteEventController;
    
//    UIBackgroundTaskIdentifier _playerBgTaskID;
}
@end

@implementation CHAudioPlayer

static NSString *const audioItemKey = @"CHAudioItemKey";

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
- (void) registerRemoteEventsWithController:(UIViewController *)remoteEventController
{
    _remoteEventController = remoteEventController;
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [remoteEventController becomeFirstResponder];
    
    Method originControlMethod = class_getInstanceMethod([remoteEventController class], @selector(remoteControlReceivedWithEvent:));
    IMP newControlImp = class_getMethodImplementation([self class], @selector(remoteControlReceivedWithEvent:));
    method_setImplementation(originControlMethod, newControlImp);
    
    Method originIsResponderMethod = class_getInstanceMethod([remoteEventController class], @selector(canBecomeFirstResponder));
    IMP newIsResponderImp = class_getMethodImplementation([self class], @selector(canBecomeFirstResponder));
    method_setImplementation(originIsResponderMethod, newIsResponderImp);
}

#pragma mark - Public 设置播放源方法
- (void) setAudioInfo:(id)audioInfo
{
    CHAudioItem *audioItem = objc_getAssociatedObject(audioInfo, &audioItemKey);
    if (!audioItem) {
        if ([audioInfo isKindOfClass:[CHAudioItem class]]) {
            audioItem = audioInfo;
        }
        else if ([audioInfo isKindOfClass:[NSString class]]) {
            audioItem = [CHAudioItem audioItemWithUrlStr:audioInfo];
        }
        else {
            NSString *urlStr = [audioInfo ch_getAudioManagerAudioAddress];
            audioItem = [CHAudioItem audioItemWithUrlStr:urlStr];
        }
        
        objc_setAssociatedObject(audioInfo, &audioItemKey, audioItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
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

#pragma mark - 远程控制
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void) remoteControlReceivedWithEvent:(UIEvent *)receivedEvent
{
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if ([self respondsToSelector:@selector(ch_audioManagerRemoteControlToTogglePlayPause)]) {
                    [self performSelector:@selector(ch_audioManagerRemoteControlToTogglePlayPause) withObject:nil];
                }
                break;
            case UIEventSubtypeRemoteControlPlay:
                if ([self respondsToSelector:@selector(ch_audioManagerRemoteControlToPlay)]) {
                    [self performSelector:@selector(ch_audioManagerRemoteControlToPlay) withObject:nil];
                }
                break;
            case UIEventSubtypeRemoteControlPause:
                if ([self respondsToSelector:@selector(ch_audioManagerRemoteControlToPause)]) {
                    [self performSelector:@selector(ch_audioManagerRemoteControlToPause) withObject:nil];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                if ([self respondsToSelector:@selector(ch_audioManagerRemoteControlToNextTrack)]) {
                    [self performSelector:@selector(ch_audioManagerRemoteControlToNextTrack) withObject:nil];
                }
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                if ([self respondsToSelector:@selector(ch_audioManagerRemoteControlToPreviousTrack)]) {
                    [self performSelector:@selector(ch_audioManagerRemoteControlToPreviousTrack) withObject:nil];
                }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingBackward:
                if ([self respondsToSelector:@selector(ch_audioManagerRemoteControlToBeginSeekingBackward)]) {
                    [self performSelector:@selector(ch_audioManagerRemoteControlToBeginSeekingBackward) withObject:nil];
                }
                break;
            case UIEventSubtypeRemoteControlEndSeekingBackward:
                if ([self respondsToSelector:@selector(ch_audioManagerRemoteControlToEndSeekingBackward)]) {
                    [self performSelector:@selector(ch_audioManagerRemoteControlToEndSeekingBackward) withObject:nil];
                }
                break;
            case UIEventSubtypeRemoteControlBeginSeekingForward:
                if ([self respondsToSelector:@selector(ch_audioManagerRemoteControlToBeginSeekingForward)]) {
                    [self performSelector:@selector(ch_audioManagerRemoteControlToBeginSeekingForward) withObject:nil];
                }
                break;
            case UIEventSubtypeRemoteControlEndSeekingForward:
                if ([self respondsToSelector:@selector(ch_audioManagerRemoteControlToEndSeekingForward)]) {
                    [self performSelector:@selector(ch_audioManagerRemoteControlToEndSeekingForward) withObject:nil];
                }
                break;
            default:
                break;
        }
    }
}



- (void)dealloc
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [_remoteEventController resignFirstResponder];
    NSLog(@"CHAudioPlayer---dealloc");
}

@end
