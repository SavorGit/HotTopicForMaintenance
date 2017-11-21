//
//  BindPositionTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BindDeviceModel.h"

extern NSString * const RDBoxDidBindMacNotification;

@interface BindPositionTableViewCell : UITableViewCell

- (void)configWithModel:(BindDeviceModel *)model andMacAddress:(NSString *)macAddress;

@end
