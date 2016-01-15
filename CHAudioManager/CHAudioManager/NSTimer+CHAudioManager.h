//
//  NSTimer+CHAudioManager.h
//  CHAudioManager
//
//  Created by Alvaro Franco on 10/02/15.
//  Modify by 陈 斐 on 16/1/14.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (CHAudioManager)

+ (id) scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;
+ (id) timerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

- (void) pauseTimer;
- (void) resumeTimer;

@end
