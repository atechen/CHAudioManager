//
//  NSDictionary+CHAudioManager.m
//  
//
//  Created by 陈 斐 on 16/1/28.
//
//

#import "NSDictionary+CHAudioManager.h"
#import <objc/runtime.h>

@implementation NSDictionary (CHAudioManager)

static NSString *CHAudioDicParamKey = @"CHAudioDicParamKey";

NSString *const CHAudioAddressKey = @"CHAudioAddressKey";
NSString *const CHAudioArtistKey = @"CHAudioArtistKey";
NSString *const CHAudioTitleKey = @"CHAudioTitleKey";
NSString *const CHAudioAlbumTitleKey = @"CHAudioTitleKey";
NSString *const CHAudioFrontcoverImageKey = @"CHAudioTitleKey";

#pragma mark 设置Dic中音频信息对应的key
- (void) registAudioInfoKeyWithDic:(NSDictionary *)audioInfoKeyDic
{
    objc_setAssociatedObject(self, &CHAudioDicParamKey, audioInfoKeyDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - delegate
// 获取音频地址
- (NSString *) ch_getAudioManagerAudioAddress
{
    NSDictionary *audioInfoKeyDic = objc_getAssociatedObject(self, &CHAudioDicParamKey);
    NSString *urlStr = [self valueForKey:audioInfoKeyDic[CHAudioAddressKey]];
    if ([urlStr hasPrefix:@"http://"] || [urlStr hasPrefix:@"https://"]) {
        return urlStr;
    }
    else{
        return [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:urlStr];
    }
}
// 音频名称
- (NSString *) ch_getAudioManagerAudioTitle
{
    NSDictionary *audioInfoKeyDic = objc_getAssociatedObject(self, &CHAudioDicParamKey);
    return [self valueForKey:audioInfoKeyDic[CHAudioTitleKey]];
}
// 音频演唱者
- (NSString *) ch_getAudioManagerAudioArtist
{
    NSDictionary *audioInfoKeyDic = objc_getAssociatedObject(self, &CHAudioDicParamKey);
    return [self valueForKey:audioInfoKeyDic[CHAudioArtistKey]];
}
// 音频封面
- (UIImage *) ch_getAudioManagerAudioFrontcoverImage
{
    NSDictionary *audioInfoKeyDic = objc_getAssociatedObject(self, &CHAudioDicParamKey);

    return [self valueForKey:audioInfoKeyDic[CHAudioFrontcoverImageKey]];
}
// 音频专辑名称
- (NSString *) ch_getAudioManagerAudioAlbumTitle
{
    NSDictionary *audioInfoKeyDic = objc_getAssociatedObject(self, &CHAudioDicParamKey);
    return [self valueForKey:audioInfoKeyDic[CHAudioAlbumTitleKey]];
}
@end
