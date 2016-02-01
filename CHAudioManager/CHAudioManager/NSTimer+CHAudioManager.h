//
//  NSTimer+CHAudioManager.h
//  CHAudioManager
//
//  Created by Alvaro Franco on 10/02/15.
//
//

#import <Foundation/Foundation.h>

@interface NSTimer (CHAudioManager)

+ (id) scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+ (id) timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

- (void) pauseTimer;
- (void) resumeTimer;

@end
