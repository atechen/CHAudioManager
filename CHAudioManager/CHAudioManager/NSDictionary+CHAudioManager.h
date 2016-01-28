//
//  NSDictionary+CHAudioManager.h
//  
//
//  Created by 陈 斐 on 16/1/28.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+CHAudioManager.h"

extern NSString *const CHAudioAddressKey;
extern NSString *const CHAudioTitleKey;
extern NSString *const CHAudioAlbumTitleKey;
extern NSString *const CHAudioFrontcoverImageKey;

@interface NSDictionary (CHAudioManager)
- (void) registAudioInfoKeyWithDic:(NSDictionary *)audioInfoKeyDic;
@end
