//
//  CHAudioItem.m
//  CHAudioManager
//
//  Created by Alvaro Franco on 20/01/15.
//  Modify by 陈 斐 on 16/1/13.
//

#import <UIKit/UIKit.h>

#import "CHAudioItem.h"
#import "NSObject+CHAudioManager.h"

@interface CHAudioItem ()
@property (nonatomic, strong, readonly) NSURL *URL;
@end

@implementation CHAudioItem

#pragma mark - 初始化创建
+ (id) audioItemWithUrlStr:(NSString *)urlStr
{
    CHAudioItem *audioItem = nil;
    if ([urlStr hasPrefix:@"http://"] || [urlStr hasPrefix:@"https://"]) {
        audioItem = [[CHAudioItem alloc] initWithStreamUrlStr:urlStr];
    }
    else{
        audioItem = [[CHAudioItem alloc] initWithLocalResource:urlStr];
    }
    
    return audioItem;
}

- (id) initWithLocalResource:(NSString *)pathStr
{
    if (self = [super init]) {
        
        _audioItemType = CHAudioItemTypeLocal;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:pathStr]) {
            _URL = [NSURL fileURLWithPath:pathStr];
            _playerItem = [[AVPlayerItem alloc] initWithURL:_URL];
        }
        else{
            return nil;
        }
    }
    
    return self;
}

- (id) initWithStreamUrlStr:(NSString *)urlStr
{
    if (self = [super init]) {
        _audioItemType = CHAudioItemTypeStreaming;
        _URL = [NSURL URLWithString:urlStr];
        _playerItem = [[AVPlayerItem alloc] initWithURL:_URL];
    }
    
    return self;
}

#pragma Mark - 获取自定义的音频信息
- (void) fetchDataWithCustomAudioInfo:(id)audioInfo
{
    if ([audioInfo respondsToSelector:@selector(ch_getAudioManagerAudioTitle)]) {
        _audioTitle = [audioInfo ch_getAudioManagerAudioTitle];
    }
    
    if ([audioInfo respondsToSelector:@selector(ch_getAudioManagerAudioAlbumTitle)]) {
        _albumTitle = [audioInfo ch_getAudioManagerAudioAlbumTitle];
    }
    
    if ([audioInfo respondsToSelector:@selector(ch_getAudioManagerAudioArtist)]) {
        _audioArtist = [audioInfo ch_getAudioManagerAudioArtist];
    }
    
    if ([audioInfo respondsToSelector:@selector(ch_getAudioManagerAudioFrontcoverImage)]) {
        _frontcoverImage = [audioInfo ch_getAudioManagerAudioFrontcoverImage];
    }
}

#pragma mark - 获取音频文件自带的信息
- (void) fetchMetadata
{
    //1.
    _duration = CMTimeGetSeconds(_playerItem.asset.duration);
    
    //2.
    NSArray *metadata = [_playerItem.asset commonMetadata];
    for (AVMetadataItem *metadataItem in metadata) {

        [metadataItem loadValuesAsynchronouslyForKeys:@[AVMetadataKeySpaceCommon] completionHandler:^{
            if (!_audioTitle &&  [metadataItem.commonKey isEqualToString:@"title"]) {
                _audioTitle = (NSString *)metadataItem.value;
            }
            else if (!_albumTitle && [metadataItem.commonKey isEqualToString:@"albumName"] ) {
                _albumTitle = (NSString *)metadataItem.value;
            }
            else if (!_audioArtist && [metadataItem.commonKey isEqualToString:@"artist"]) {
                _audioArtist = (NSString *)metadataItem.value;
            }
            else if (!_frontcoverImage && [metadataItem.commonKey isEqualToString:@"artwork"]) {
                _frontcoverImage = [UIImage imageWithData:[metadataItem.value copyWithZone:nil]];
//                if ([metadataItem.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
//                    _frontcoverImage = [UIImage imageWithData:[metadataItem.value copyWithZone:nil]];
//                }
//                else if ([metadataItem.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
//                    _frontcoverImage = [UIImage imageWithData:[metadataItem.value copyWithZone:nil]];
//                }
            }
        }];
    }
}

@end
