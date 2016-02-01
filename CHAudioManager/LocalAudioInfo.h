//
//  LocalAudioInfo.h
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/19.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

#import "NSObject+CHAudioManager.h"

@interface LocalAudioInfo : NSObject
@property (nonatomic, copy) NSString *audioPath;
@property (nonatomic, copy) NSString *audioName;
@end
