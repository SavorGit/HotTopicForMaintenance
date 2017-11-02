//
//  DeviceFaultTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceFaultModel.h"

@interface DeviceFaultTableViewCell : UITableViewCell

- (void)configWithDeviceFaultModel:(DeviceFaultModel *)model;

@end
