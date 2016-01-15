//
//  CHAudioItem.m
//  CHAudioManager
//
//  Created by Alvaro Franco on 20/01/15.
//  Modify by 陈 斐 on 16/1/13.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import "CHAudioItem.h"

@interface CHAudioItem ()
@end

@implementation CHAudioItem

+ (id) audioItemWithUrlStr:(NSString *)urlStr
{
    urlStr = [urlStr lowercaseString];
    CHAudioItem *audioItem = nil;
    if ([urlStr hasPrefix:@"http://"] || [urlStr hasPrefix:@"https://"]) {
        audioItem = [[CHAudioItem alloc] initWithStreamUrlStr:urlStr];
    }
    else{
        audioItem = [[CHAudioItem alloc] initWithLocalResource:urlStr atPath:nil];
    }
    return audioItem;
}

- (id) initWithLocalResource:(NSString *)name atPath:(NSString *)path
{
    
    if (self == [super init]) {
        
        _audioItemType = CHAudioItemTypeLocal;
        
        NSString *itemPath;
        if (!path) {
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            itemPath = [resourcePath stringByAppendingPathComponent:name];
        }
        else {
            itemPath = [path stringByAppendingPathComponent:name];
        }
        
        _URL = [NSURL fileURLWithPath:itemPath];
        _playerItem = [[AVPlayerItem alloc] initWithURL:_URL];
    }
    
    return self;
}

- (id) initWithStreamUrlStr:(NSString *)urlStr
{
    
    if (self == [super init]) {
        _audioItemType = CHAudioItemTypeStreaming;
        _URL = [NSURL URLWithString:urlStr];
        _playerItem = [[AVPlayerItem alloc] initWithURL:_URL];
    }
    
    return self;
}

-(void)fetchMetadata
{
    // chenEdit 添加
    _duration = CMTimeGetSeconds(_playerItem.asset.duration);
    // chenEdit end
    
    // chenEdit 注释
    NSArray *metadata = [_playerItem.asset commonMetadata];

    for (AVMetadataItem *metadataItem in metadata) {

        [metadataItem loadValuesAsynchronouslyForKeys:@[AVMetadataKeySpaceCommon] completionHandler:^{
//            if ([metadataItem.commonKey isEqualToString:@"title"]) {
//                _title = (NSString *)metadataItem.value;
//            }
//            else if ([metadataItem.commonKey isEqualToString:@"albumName"]) {
//                _album = (NSString *)metadataItem.value;
//            }
//            else if ([metadataItem.commonKey isEqualToString:@"artist"]) {
//                _artist = (NSString *)metadataItem.value;
//            }
//            else if ([metadataItem.commonKey isEqualToString:@"artwork"]) {
//                if ([metadataItem.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
//                    _artwork = [UIImage imageWithData:[[metadataItem.value copyWithZone:nil] objectForKey:@"data"]];
//                }
//                else if ([metadataItem.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
//                    _artwork = [UIImage imageWithData:[metadataItem.value copyWithZone:nil]];
//                }
//            }
        }];
    }
    // chenEdit end
}

-(void)setInfoFromItem:(AVPlayerItem *)item
{
    _duration = CMTimeGetSeconds(item.duration);
    _timePlayed = CMTimeGetSeconds(item.currentTime);
}
@end
