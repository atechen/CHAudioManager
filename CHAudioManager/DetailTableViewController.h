//
//  DetailTableViewController.h
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/19.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewController : UITableViewController
// model类型数据
@property (nonatomic, strong) NSArray *audioInfoArr;
// 字典类型数据
@property (nonatomic, strong) NSArray *audioDicArr;
@end
