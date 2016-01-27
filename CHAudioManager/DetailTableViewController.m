//
//  DetailTableViewController.m
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/19.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import "DetailTableViewController.h"
#import "AudioTableViewCell.h"
#import "LocalAudioInfo.h"
#import "CHAudioQueue.h"
#import "UIViewController+CHAudioManager.h"

@interface DetailTableViewController ()
{
    NSIndexPath *_selectedIndexPath;
    CHAudioQueue *_playerQueue;
}
@end

@implementation DetailTableViewController

//- (void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
//    [self becomeFirstResponder];
//}
//
//- (void) viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
//    [self resignFirstResponder];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"AudioTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"AudioTableViewCellID"];
    
    _playerQueue = [[CHAudioQueue alloc] init];
    [_playerQueue setAudioInfoArr:_audioInfoArr audioUrlKey:@"audioPath"];
    [_playerQueue registerBackgroundPlay];
    [_playerQueue registerRemoteEventsWithController:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _audioInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AudioTableViewCellID"];
    LocalAudioInfo *localAudioInfo = _audioInfoArr[indexPath.row];
    cell.contentLabel.text = localAudioInfo.audioName;
    
    if (indexPath == _selectedIndexPath) {
        BOOL isPlayed = YES;
        if (_playerQueue.status == CHAudioPlayStart || _playerQueue.status == CHAudioPlayResume) {
            isPlayed = YES;
        }
        else {
            isPlayed = NO;
        }
        [cell setSelected:YES played:isPlayed];
    }
    else {
        [cell setSelected:NO played:NO];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioTableViewCell *selectedCell = (AudioTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (_selectedIndexPath == indexPath) {// 播放或暂停 当前选中行
        if (_playerQueue.status == CHAudioPlayStart || _playerQueue.status == CHAudioPlayResume) {// 当前正在播放，暂停
            [selectedCell setSelected:YES played:NO];
            [_playerQueue pause];
        }
        else if(_playerQueue.status == CHAudioPlayFinished) {// 当前完成，重新播放
            [selectedCell setSelected:YES played:YES];
            [_playerQueue playStreamInfoAtIndex:indexPath.row];
        }
        else {// 当前暂停，播放
            [selectedCell setSelected:YES played:YES];
            [_playerQueue resume];
        }
    }
    else {// 暂停当前的行、播放选中选中行
        if (_selectedIndexPath) {
            AudioTableViewCell *beforCell = (AudioTableViewCell *)[tableView cellForRowAtIndexPath:_selectedIndexPath];
            [beforCell setSelected:NO played:NO];
        }
        [selectedCell setSelected:YES played:YES];
        [_playerQueue playStreamInfoAtIndex:indexPath.row];
        _selectedIndexPath = indexPath;
    }
}

#pragma mark - 远程控制
//- (void) ch_audioManagerRemoteControlToPlay
//{
//    [_playerQueue resume];
//}
//- (void) ch_audioManagerRemoteControlToPause
//{
//    [_playerQueue pause];
//}
//- (void) ch_audioManagerRemoteControlToNextTrack
//{
//    [_playerQueue playNextStreamInfo];
//}
//- (void) ch_audioManagerRemoteControlToPreviousTrack
//{
//    [_playerQueue playPreviousStreamInfo];
//}


@end
