//
//  RepairRecordTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairRecordDetailModel.h"

@interface RepairRecordTableViewCell : UITableViewCell

- (void)configWithModel:(RepairRecordDetailModel *)model;

@end
