//
//  LocalAudioInfo.m
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/19.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import "LocalAudioInfo.h"

@implementation LocalAudioInfo
// 获取音频地址
- (NSString *) ch_getAudioManagerAudioAddress
{
//    NSString *audioBundlePath = [[NSBundle mainBundle].bundlePath pathForResource:@"BundleAudio" ofType:@"bundle"];
//    NSString *audioPath = [NSString stringWithFormat:@"%@/%@", [NSBundle mainBundle].bundlePath, _audioPath];
    NSString *audioPath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:_audioPath];
    return audioPath;
}
@end
