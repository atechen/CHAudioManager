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

- (void) setAudioInfoArr:(NSArray *)audioInfoArr audioUrlKey:(NSString *)audioUrlKey;
- (void) registerBackgroundPlay;
- (void) registerRemoteEventsWithController:(UIViewController *)remoteEventController;

- (void) playStreamInfoAtIndex:(NSInteger)index;
- (void) playStreamInfo:(id)audioInfo;
- (void) playAtSecond:(NSInteger)second;

- (void) pause;
- (void) resume;
- (void) clearQueue;

- (void) playNextStreamInfo;
- (void) playPreviousStreamInfo;

- (void) listenFeedbackUpdatesWithBlock:(feedbackBlock)block andFinishedBlock:(finishedBlock)finishedBlock;

@end
