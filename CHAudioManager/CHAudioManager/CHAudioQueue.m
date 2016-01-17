//
//  CHAudioQueue.m
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/17.
//

#import "CHAudioQueue.h"

@implementation CHAudioQueue
- (void) setAudioInfo:(id)audioInfo audioUrlKey:(NSString *)audioUrlKey
{
    NSString *urlStr = nil;
    if ([audioInfo isKindOfClass:[NSString class]]) {
        urlStr = audioInfo;
    }
    urlStr = [audioInfo valueForKey:audioUrlKey];
//    _currentAudioItem = [CHAudioItem audioItemWithUrlStr:urlStr];
//#warning 不确定是否耗时
//    [_audioPlayer replaceCurrentItemWithPlayerItem:_currentAudioItem.playerItem];
}
@end
