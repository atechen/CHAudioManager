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
- (id) initWithLocalResource:(NSString *)name atPath:(NSString *)path;

@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat timePlayed;
@property (nonatomic, assign, readonly) CHAudioItemType audioItemType;
@end
