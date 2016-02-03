//
//  ViewController.m
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/13.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import "ViewController.h"
#import "LocalAudioInfo.h"
#import "DetailTableViewController.h"

@interface ViewController ()
{
    NSArray *_localAudioInfoArr;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *bundleStr = [[NSBundle mainBundle] pathForResource:@"BundleAudio" ofType:@"bundle"];
    NSString *audioInfoArrPath = [[NSBundle bundleWithPath:bundleStr] pathForResource:@"AudioInfoArr" ofType:@"json"];
    NSData  *jsonData = [NSData dataWithContentsOfFile:audioInfoArrPath];
    NSError *error = nil;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    _localAudioInfoArr = [LocalAudioInfo mj_objectArrayWithKeyValuesArray:jsonDic[@"data"]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ViewToAudioDetailSegue"]) {
        DetailTableViewController *detailViewController = segue.destinationViewController;
        detailViewController.audioInfoArr = _localAudioInfoArr;
    }
}

@end
