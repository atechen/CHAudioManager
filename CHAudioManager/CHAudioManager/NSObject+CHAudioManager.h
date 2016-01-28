//
//  NSObject+CHAudioManager.h
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/27.
//  Copyright © 2016年 atechen. All rights reserved.
//

/*
使用自定义音频数据模型：
 若为播放器赋值的音频数据，只是字符串或CHAudioItem，则不需要使用该协议。
 若为播放器赋值的音频数据，是一个自定义的数据模型，可以通过该协议为播放器提供音频的信息。
 */

#import <Foundation/Foundation.h>


@protocol CHAudioManagerAudioInfoParse <NSObject>

// 获取音频地址
- (NSString *) ch_getAudioManagerAudioAddress;

@optional
// 音频名称
- (NSString *) ch_getAudioManagerAudioTitle;
// 音频演唱者
- (NSString *) ch_getAudioManagerAudioArtist;
// 音频封面
- (NSString *) ch_getAudioManagerAudioFrontcoverImage;
// 音频专辑名称
- (NSString *) ch_getAudioManagerAudioAlbumTitle;

@end

@interface NSObject (CHAudioManager)<CHAudioManagerAudioInfoParse>

@end
