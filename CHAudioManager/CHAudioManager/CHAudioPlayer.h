//
//  CHAudioPlayer.h
//  CHAudioManager
//
//  Created by Alvaro Franco on 21/01/15.
//  Modify by 陈 斐 on 16/1/12.
//

#import <AVFoundation/AVFoundation.h>
#import "CHAudioItem.h"

typedef enum {
    CHAudioPlayNone = 1,
    CHAudioPlayInit,
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

// 设置播放源方法
- (void) setAudioItem:(CHAudioItem *)audioItem;

// play control
- (void) play;
- (void) playAtSecond:(NSInteger)second;
- (void) pause;
- (void) resume;

@property (nonatomic, assign, readonly) CHAudioPlayStatus status;
@end
