//
//  CHAudioQueue.m
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/17.
//

#import "CHAudioQueue.h"
#import <objc/runtime.h>
#import "CHAudioItem.h"
#import "NSTimer+CHAudioManager.h"

@interface CHAudioQueue ()
{
    CHAudioPlayer *_audioPlayer;
    NSTimer *_feedbackTimer;
    
    id _currentAudioInfo;
}

@end

@implementation CHAudioQueue

- (instancetype)init
{
    if (self = [super init]) {
        _audioPlayer = [[CHAudioPlayer alloc] init];
    }
    return self;
}

#pragma mark - 注册后台播放/远程控制
- (void) registerBackgroundPlay
{
    [_audioPlayer registerBackgroundPlay];
}
- (void) registerRemoteEventsWithController:(UIViewController *)remoteEventController
{
    [_audioPlayer registerRemoteEventsWithController:remoteEventController];
}

#pragma mark - Get
- (CHAudioPlayStatus)status
{
    return _audioPlayer.status;
}

- (CHAudioItem *)currentAudioItem
{
    return _audioPlayer.currentAudioItem;
}

#pragma mark - play
- (void) playStreamInfo:(id)audioInfo
{
    if ([_audioInfoArr containsObject:audioInfo]) {
        
        _currentAudioInfo = audioInfo;
        
        [_audioPlayer setAudioInfo:_currentAudioInfo];
        if (_audioPlayer.status == CHAudioPlayNone || _audioPlayer.status == CHAudioPlayPause || _audioPlayer.status == CHAudioPlayFinished) {
            [_feedbackTimer resumeTimer];
        }
        
        [_audioPlayer play];
    }
}

- (void) playStreamInfoAtIndex:(NSInteger)index
{
    if (index < _audioInfoArr.count && index >= 0) {
        [self playStreamInfo:_audioInfoArr[index]];
    }
}

- (void) playAtSecond:(NSInteger)second
{
    [_audioPlayer playAtSecond:second];
}

/*
- (void) initInSubThreadAndPlay:(id)audioInfo
{
    if ([_delegate respondsToSelector:@selector(audioPlayerManagerPrepareForPlay:)]) {
        [_delegate audioPlayerManagerPrepareForPlay:self];
    }
    [self prepareToPlay];
}

- (void) prepareToPlay
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CHAudioItem *playItem = objc_getAssociatedObject(_currentAudioInfo, &audioItemKey);
        [_audioPlayer setAudioItem:playItem];
        [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
    });
}
- (void) play
{
    if ([_delegate respondsToSelector:@selector(audioPlayerManagerReadyWillPlay:)]) {
        [_delegate audioPlayerManagerReadyWillPlay:self];
    }
    if (_audioPlayer.status == CHAudioPlayNone || _audioPlayer.status == CHAudioPlayPause || _audioPlayer.status == CHAudioPlayFinished){
        [_feedbackTimer resumeTimer];
    }
    [_audioPlayer play];
    //    [[MPRemoteCommandCenter sharedCommandCenter] playCommand];
}
 */

#pragma mark pause
- (void) pause
{
    [_audioPlayer pause];
    [_feedbackTimer pauseTimer];
}

#pragma mark resume
- (void) resume
{
    [_audioPlayer play];
    [_feedbackTimer resumeTimer];
}
#pragma mark 清空
- (void) clearQueue
{
    [_audioPlayer pause];
    [_feedbackTimer pauseTimer];
    _feedbackTimer = nil;
}

#pragma mark - toggle
- (void) playNextStreamInfo
{
    if ([_audioInfoArr containsObject:_currentAudioInfo]) {
        [self playStreamInfoAtIndex:([_audioInfoArr indexOfObject:_currentAudioInfo] + 1)];
        [_feedbackTimer resumeTimer];
    }
}

- (void) playPreviousStreamInfo
{
    if ([_audioInfoArr containsObject:_currentAudioInfo]) {
        [self playStreamInfoAtIndex:([_audioInfoArr indexOfObject:_currentAudioInfo] - 1)];
    }
}

#pragma mark - 播放回调
- (void) listenFeedbackUpdatesWithBlock:(feedbackBlock)block andFinishedBlock:(finishedBlock)finishedBlock
{
    [_audioPlayer listenFeedbackUpdatesWithBlock:block andFinishedBlock:finishedBlock];
}

- (void)dealloc
{
    NSLog(@"CHAudioQueue---dealloc");
}

@end
