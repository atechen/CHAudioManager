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
#import "NSDictionary+CHAudioManager.h"

@interface ViewController ()
{
    NSArray *_localAudioDicArr;
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
    _localAudioDicArr = jsonDic[@"data"];
}

- (IBAction)gotoInfoDataClick:(id)sender {
    DetailTableViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AudioListController"];
    detailViewController.audioInfoArr = [LocalAudioInfo mj_objectArrayWithKeyValuesArray:_localAudioDicArr];
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (IBAction)gotoDicDataClick:(id)sender {
    DetailTableViewController *detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AudioListController"];
    for (NSDictionary *audioDic in _localAudioDicArr) {
        [audioDic registAudioInfoKeyWithDic:@{
                                              CHAudioAddressKey:@"audioPath"
                                              }];
    }
    detailViewController.audioDicArr = _localAudioDicArr;
    [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
