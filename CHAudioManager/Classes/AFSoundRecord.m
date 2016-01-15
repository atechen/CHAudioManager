//
//  AFSoundRecord.m
//  AFSoundManager-Demo
//
//  Created by Alvaro Franco on 10/02/15.
//  Copyright (c) 2015 AlvaroFranco. All rights reserved.
//

#import "AFSoundRecord.h"
#import <AVFoundation/AVFoundation.h>

@interface AFSoundRecord ()

@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation AFSoundRecord

-(id)initWithFilePath:(NSString *)filePath {
    
    if (self == [super init]) {
        // chenEdit 添加
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
        [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
        [settings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
        [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
        // chenEdit end
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:filePath] settings:0 error:nil];
        // chenEdit 添加
        _recorder.meteringEnabled = YES;
        // chenEdit end
        [_recorder prepareToRecord];
    }
    
    return self;
}

-(void)startRecording {
    
    [_recorder record];
}

-(void)saveRecording {
    
    [_recorder stop];
}

-(void)cancelCurrentRecording {
    
    [_recorder stop];
    [_recorder deleteRecording];
}

@end
