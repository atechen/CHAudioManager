//
//  CHAudioManagerTests.m
//  CHAudioManagerTests
//
//  Created by 陈 斐 on 16/1/25.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CHAudioPlayer.h"

@interface CHAudioManagerTests : XCTestCase

@end

@implementation CHAudioManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    NSLog(@"-------------testExample");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testAudioPlay
{
    NSLog(@"-------------");
    CHAudioPlayer *audioPlayer = [[CHAudioPlayer alloc] init];
    NSBundle *resourceBundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"Resourse" ofType:@"bundle"]];
    XCTAssertNil(resourceBundle, @"resourceBundle没有加载");
    NSString *audioPath = [resourceBundle pathForResource:@"3" ofType:@"mp3"];
//
//    CHAudioItem *audioItem = [[CHAudioItem alloc] initWithLocalResource:audioPath atPath:nil];
//    [audioPlayer setAudioItem:audioItem];
//    [audioPlayer play];
}

@end
