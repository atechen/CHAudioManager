//
//  CHAudioPlayer.h
//  CHAudioManager
//
//  Created by Alvaro Franco on 21/01/15.
//  Modify by 陈 斐 on 16/1/12.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CHAudioItem.h"

typedef enum {
    CHAudioPlayNone = 1,
    CHAudioPlayInit,// 并未使用
    CHAudioPlayStart,
    CHAudioPlayPause,
    CHAudioPlayResume,
    CHAudioPlayFinished,
    CHAudioPlayError
}CHAudioPlayStatus;

typedef void (^feedbackBlock)(CHAudioItem *item);
typedef void (^finishedBlock)(void);

extern NSString *const CHAudioPlayerStatus;
extern NSString *const CHAudioPlayerItemDuration;
extern NSString *const CHAudioPlayerItemTimeElapsed;

@interface CHAudioPlayer : NSObject

@property (nonatomic, assign, readonly) CHAudioPlayStatus status;
@property (nonatomic, assign, readonly) CHAudioItem *currentAudioItem;

// 设置播放源方法
- (void) setAudioInfo:(id)audioInfo;
- (void) registerBackgroundPlay;
- (void) registerRemoteEventsWithController:(UIViewController *)remoteEventController;

// play control
- (void) play;
- (void) playAtSecond:(NSInteger)second;
- (void) pause;
- (void) resume;

- (void) listenFeedbackUpdatesWithBlock:(feedbackBlock)block andFinishedBlock:(finishedBlock)finishedBlock;
@end
