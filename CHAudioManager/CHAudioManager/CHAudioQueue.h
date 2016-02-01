//
//  CHAudioQueue.h
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/17.
//

#import <Foundation/Foundation.h>
#import "CHAudioPlayer.h"

@class CHAudioItem;

@interface CHAudioQueue : NSObject

@property (nonatomic, assign) CHAudioPlayStatus status;
@property (nonatomic, strong, readonly) CHAudioItem *currentAudioItem;
@property (nonatomic, strong) NSArray *audioInfoArr;

// 注册后台播放
- (void) registerBackgroundPlay;
//远程控制
- (void) registerRemoteEventsWithController:(UIViewController *)remoteEventController;

- (void) playStreamInfoAtIndex:(NSInteger)index;
- (void) playStreamInfo:(id)audioInfo;
- (void) playAtSecond:(NSInteger)second;

- (void) pause;
- (void) resume;
- (void) clearQueue;

// toggle
- (void) playNextStreamInfo;
- (void) playPreviousStreamInfo;

// 播放进度
- (void) listenFeedbackUpdatesWithBlock:(feedbackBlock)block andFinishedBlock:(finishedBlock)finishedBlock;

@end
