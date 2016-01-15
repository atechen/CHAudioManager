//
//  AFCHSoundQueue.m
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/12.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import "AFCHSoundQueue.h"
#import "AFSoundPlayback.h"
#import "NSTimer+AFSoundManager.h"

@interface AFCHSoundQueue ()
{
    AFSoundPlayback *_soundPlayer;
    NSTimer *_feedbackTimer;
    AudioStreamInfo *_playingAudioInfo;
}
@property (nonatomic, strong) NSMutableArray *audioItemArr;

@end

@implementation AFCHSoundQueue
- (instancetype)init
{
    if (self = [super init]) {
//        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    return self;
}

-(void)clearQueue
{
    _playingAudioInfo = nil;
    [_soundPlayer pause];
    [_audioStreaminfoArr removeAllObjects];
    [_feedbackTimer pauseTimer];
    _feedbackTimer = nil;
}

-(void)pause
{
    [_soundPlayer pause];
    //    [[MPRemoteCommandCenter sharedCommandCenter] pauseCommand];
    [_feedbackTimer pauseTimer];
}

-(void)playCurrentAudioStream
{
    [_soundPlayer play];
    //    [[MPRemoteCommandCenter sharedCommandCenter] playCommand];
    [_feedbackTimer resumeTimer];
}

-(void)playStreamInfoAtIndex:(NSInteger)index
{
    if (index < _audioStreaminfoArr.count && index > 0) {
        [self playStreamInfo:_audioStreaminfoArr[index]];
    }
}

-(void)playStreamInfo:(AudioStreamInfo *)audioStreamInfo
{
    if ([_audioStreaminfoArr containsObject:audioStreamInfo]) {
        
        _playingAudioInfo = audioStreamInfo;
        
        if ([_delegate respondsToSelector:@selector(audioPlayerManagerPrepareForPlay:)]) {
            [_delegate audioPlayerManagerPrepareForPlay:self];
        }
        
        [self prepareToPlay];
    }
}

- (void) prepareToPlay
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _soundPlayer = [[AFSoundPlayback alloc] initWithItem:_playingAudioInfo.afSounItem];
        [self performSelectorOnMainThread:@selector(play) withObject:nil waitUntilDone:NO];
    });
}
- (void) play
{
    if ([_delegate respondsToSelector:@selector(audioPlayerManagerReadyWillPlay:)]) {
        [_delegate audioPlayerManagerReadyWillPlay:self];
    }
    
    if (_soundPlayer.status == AFSoundStatusNotStarted || _soundPlayer.status == AFSoundStatusPaused || _soundPlayer.status == AFSoundStatusFinished)
    {
        [_feedbackTimer resumeTimer];
    }
    
    [_soundPlayer play];
    //    [[MPRemoteCommandCenter sharedCommandCenter] playCommand];
}

-(void)playAtSecond:(NSInteger)second {
    [_soundPlayer.player seekToTime:CMTimeMake(second, 1)];
}

//-(void)playNextStreamInfo
//{
//    if ([_audioStreaminfoArr containsObject:_playingAudioInfo]) {
//
//        [self playStreamInfoAtIndex:([_audioStreaminfoArr indexOfObject:_playingAudioInfo] + 1)];
//        [[MPRemoteCommandCenter sharedCommandCenter] nextTrackCommand];
//
//        [_feedbackTimer resumeTimer];
//    }
//}
//
//-(void)playPreviousStreamInfo
//{
//    if ([_audioStreaminfoArr containsObject:_playingAudioInfo]) {
//        [self playStreamInfoAtIndex:([_audioStreaminfoArr indexOfObject:_playingAudioInfo] - 1)];
//        [[MPRemoteCommandCenter sharedCommandCenter] previousTrackCommand];
//    }
//}

-(void)listenFeedbackUpdatesWithBlock:(feedbackBlock)block andFinishedBlock:(itemFinishedBlock)finishedBlock
{
    CGFloat updateRate = 1;
    
    if (_soundPlayer.player.rate > 0) {
        updateRate = 1 / _soundPlayer.player.rate;
    }
    __unsafe_unretained CHAudioPlayerManager *blockSelf = self;
    _feedbackTimer = [NSTimer scheduledTimerWithTimeInterval:updateRate block:^{
        if (block) {
            blockSelf->_soundPlayer.currentItem.timePlayed = (int)CMTimeGetSeconds(blockSelf->_soundPlayer.player.currentTime);
            block(blockSelf->_soundPlayer.currentItem);
        }
        if (blockSelf->_soundPlayer.currentItem.timePlayed == blockSelf->_soundPlayer.currentItem.duration) {
            [blockSelf->_feedbackTimer pauseTimer];
            if (finishedBlock) {
                NSInteger currentIndex = [blockSelf->_audioStreaminfoArr indexOfObject:blockSelf->_playingAudioInfo];
                if ( currentIndex + 1 < blockSelf->_audioStreaminfoArr.count) {
                    finishedBlock(blockSelf->_audioStreaminfoArr[currentIndex + 1]);
                }
                else {
                    finishedBlock(nil);
                }
            }
        }
    } repeats:YES];
}
-(void)removeListenFeedback
{
    if ([_feedbackTimer isValid]) {
        [_feedbackTimer invalidate];
    }
    _feedbackTimer = nil;
}

//-(void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
//
//    if (receivedEvent.type == UIEventTypeRemoteControl) {
//
//        switch (receivedEvent.subtype) {
//
//            case UIEventSubtypeRemoteControlPreviousTrack:
//                [self playPreviousStreamInfo];
//                break;
//
//            case UIEventSubtypeRemoteControlNextTrack:
//                [self playNextStreamInfo];
//                break;
//
//            default:
//                break;
//        }
//    }
//}
@end
