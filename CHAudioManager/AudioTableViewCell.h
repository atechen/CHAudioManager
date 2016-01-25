//
//  AudioTableViewCell.h
//  CHAudioManager
//
//  Created by 陈 斐 on 16/1/19.
//  Copyright © 2016年 atechen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *playIndicatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
- (void) setSelected:(BOOL)selected played:(BOOL)played;
@end
