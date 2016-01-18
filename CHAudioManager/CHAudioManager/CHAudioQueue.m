//
//  CHAudioQueue.m
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/17.
//

#import "CHAudioQueue.h"
#import <objc/runtime.h>
#import "CHAudioItem.h"
#import "CHAudioPlayer.h"
#import "NSTimer+CHAudioManager.h"

@interface CHAudioQueue ()
{
    CHAudioPlayer *_audioPlayer;
    NSArray *_audioInfoArr;
    NSTimer *_feedbackTimer;
    id _currentAudioInfo;
}

@end

@implementation CHAudioQueue

static NSString *const audioItemKey = @"CHAudioItemKey";

- (instancetype)init
{
    if (self = [super init]) {
        _audioPlayer = [[CHAudioPlayer alloc] init];
    }
    return self;
}

- (void) setAudioInfoArr:(NSArray *)audioInfoArr audioUrlKey:(NSString *)audioUrlKey
{
    if (audioInfoArr.count <= 0) return;
    
    _audioInfoArr = audioInfoArr;
    for (id audioInfo in audioInfoArr) {
        CHAudioItem *audioItem;
        
        if ([audioInfo isKindOfClass:[CHAudioItem class]]) {
            audioItem = audioInfo;
        }
        else if ([audioInfo isKindOfClass:[NSString class]]) {
            NSString *urlStr = [audioInfo valueForKey:audioUrlKey];
            audioItem = [CHAudioItem audioItemWithUrlStr:urlStr];
        }
        else{
            NSString *urlStr = [audioInfo valueForKey:audioUrlKey];
            audioItem = [CHAudioItem audioItemWithUrlStr:urlStr];
        }
        
        objc_setAssociatedObject(audioInfo, &audioItemKey, audioItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
}

- (void) clearQueue
{
    [_audioPlayer pause];
    [_feedbackTimer pauseTimer];
    _feedbackTimer = nil;
}

#pragma mark - play
- (void) playStreamInfo:(id)audioInfo
{
    if ([_audioInfoArr containsObject:audioInfo]) {
        
        _currentAudioInfo = audioInfo;
        
        CHAudioItem *playItem = objc_getAssociatedObject(_currentAudioInfo, &audioItemKey);
        [_audioPlayer setAudioItem:playItem];
        if (_audioPlayer.status == CHAudioPlayNone || _audioPlayer.status == CHAudioPlayPause || _audioPlayer.status == CHAudioPlayFinished) {
            [_feedbackTimer resumeTimer];
        }
        [_audioPlayer play];
        
//        if ([_delegate respondsToSelector:@selector(audioPlayerManagerPrepareForPlay:)]) {
//            [_delegate audioPlayerManagerPrepareForPlay:self];
//        }
//        [self prepareToPlay];
    }
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
    //    if ([_delegate respondsToSelector:@selector(audioPlayerManagerReadyWillPlay:)]) {
    //        [_delegate audioPlayerManagerReadyWillPlay:self];
    //    }
    
    if (_audioPlayer.status == CHAudioPlayNone || _audioPlayer.status == CHAudioPlayPause || _audioPlayer.status == CHAudioPlayFinished)
    {
        [_feedbackTimer resumeTimer];
    }
    
    [_audioPlayer play];
    //    [[MPRemoteCommandCenter sharedCommandCenter] playCommand];
}

- (void) playStreamInfoAtIndex:(NSInteger)index
{
    if (index < _audioInfoArr.count && index > 0) {
        [self playStreamInfo:_audioInfoArr[index]];
    }
}

- (void) playAtSecond:(NSInteger)second
{
    [_audioPlayer playAtSecond:second];
}

#pragma mark - pause
- (void) pause
{
    [_audioPlayer pause];
    //    [[MPRemoteCommandCenter sharedCommandCenter] pauseCommand];
    [_feedbackTimer pauseTimer];
}

#pragma mark resume
- (void) resume
{
    [_audioPlayer play];
    //    [[MPRemoteCommandCenter sharedCommandCenter] playCommand];
    [_feedbackTimer resumeTimer];
}

#pragma mark - toggle
- (void) playNextStreamInfo
{
    if ([_audioInfoArr containsObject:_currentAudioInfo]) {

        [self playStreamInfoAtIndex:([_audioInfoArr indexOfObject:_currentAudioInfo] + 1)];
//        [[MPRemoteCommandCenter sharedCommandCenter] nextTrackCommand];
        [_feedbackTimer resumeTimer];
    }
}

- (void) playPreviousStreamInfo
{
    if ([_audioInfoArr containsObject:_currentAudioInfo]) {
        [self playStreamInfoAtIndex:([_audioInfoArr indexOfObject:_currentAudioInfo] - 1)];
//        [[MPRemoteCommandCenter sharedCommandCenter] previousTrackCommand];
    }
}

@end
