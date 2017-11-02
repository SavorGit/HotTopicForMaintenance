//
//  TaskTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskListModel.h"

@interface TaskTableViewCell : UITableViewCell

- (void)configWithModel:(TaskListModel *)model;

@end
