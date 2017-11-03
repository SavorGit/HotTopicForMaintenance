//
//  BindPositionTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantRankModel.h"

@interface BindPositionTableViewCell : UITableViewCell

- (void)configWithModel:(RestaurantRankModel *)model;

@end