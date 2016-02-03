//
//  CHAudioItem.h
//  CHAudioManager
//
//  Created by Alvaro Franco on 20/01/15.
//  Modify by 陈 斐 on 16/1/13.
//

#import <AVFoundation/AVFoundation.h>
#import "CHAudioItem.h"

typedef NS_ENUM(NSInteger, CHAudioItemType) {
    CHAudioItemTypeLocal,
    CHAudioItemTypeStreaming
};

@interface CHAudioItem : NSObject

+ (id) audioItemWithUrlStr:(NSString *)urlStr;
- (id) initWithStreamUrlStr:(NSString *)urlStr;
- (id) initWithLocalResource:(NSString *)pathStr;
// 从自定义对象中获取音频信息
- (void) fetchDataWithCustomAudioInfo:(id)audioInfo;
// 从音频文件中获取信息
- (void) fetchMetadata;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat timePlayed;

@property (nonatomic, copy) NSString *audioTitle;
@property (nonatomic, copy) NSString *audioArtist;
@property (nonatomic, copy) NSString *albumTitle;
@property (nonatomic, strong) UIImage *frontcoverImage;

@property (nonatomic, assign, readonly) CHAudioItemType audioItemType;
@end
