//
//  CHAudioQueue.h
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/17.
//

#import <Foundation/Foundation.h>

@interface CHAudioQueue : NSObject
- (void) setAudioInfoArr:(NSArray *)audioInfoArr audioUrlKey:(NSString *)audioUrlKey;

- (void) clearQueue;

- (void) playStreamInfoAtIndex:(NSInteger)index;
- (void) playStreamInfo:(id)audioInfo;
- (void) playAtSecond:(NSInteger)second;

- (void) pause;
- (void) resume;

-(void)playNextStreamInfo;
-(void)playPreviousStreamInfo;

@end
