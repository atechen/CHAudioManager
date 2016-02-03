//
//  NSTimer+CHAudioManager.m
//  CHAudioManager
//
//  Created by Alvaro Franco on 10/02/15.
//  Modify by 陈 斐 on 16/1/12.
//  
//

#import "NSTimer+CHAudioManager.h"
#import <objc/runtime.h>

@implementation NSTimer (CHAudioManager)

+(id)scheduledTimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats
{
    void (^block)() = [inBlock copy];
    NSTimer *ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    ret.fireDate = [NSDate distantFuture];
    return ret;
}

+(void)jdExecuteSimpleBlock:(NSTimer *)inTimer
{
    if([inTimer userInfo]) {
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

static NSString *const NSTimerPauseDate = @"CHAudioManagerTimerPauseDate";

- (void) pauseTimer
{
    objc_setAssociatedObject(self, (__bridge const void *)(NSTimerPauseDate), [NSDate date], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.fireDate = [NSDate distantFuture];
}

- (void) resumeTimer
{
    // 暂停时的本地时间
    NSDate *pauseDate = objc_getAssociatedObject(self, (__bridge const void *)NSTimerPauseDate);
    // 暂停时长
    const NSTimeInterval pauseTime = -[pauseDate timeIntervalSinceNow];
    
    self.fireDate = [NSDate dateWithTimeInterval:pauseTime sinceDate:pauseDate];
}

@end
