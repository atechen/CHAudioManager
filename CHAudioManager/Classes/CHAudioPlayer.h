//
//  CHAudioPlayer.h
//  CHAudioManager
//
//  Created by Alvaro Franco on 21/01/15.
//  Modify by 陈 斐 on 16/1/12.
//  Copyright © 2016年 atechen. All rights reserved.
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

@interface CHAudioPlayer : NSObject

// 设置播放源方法
- (void) setAudioInfo:(id)audioInfo audioUrlKey:(NSString *)audioUrlKey;
- (void) setAudioItem:(CHAudioItem *)audioItem;

@property (nonatomic, assign, readonly) CHAudioPlayStatus status;
@end
