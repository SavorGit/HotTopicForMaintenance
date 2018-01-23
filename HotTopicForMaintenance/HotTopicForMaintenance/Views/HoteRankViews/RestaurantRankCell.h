//
//  RestaurantRankCell.h
//  SavorX
//
//  Created by 王海朋 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantRankModel.h"
#import "RepairRecordRankModel.h"

@interface RestaurantRankCell : UITableViewCell

- (void)configWithModel:(RestaurantRankModel *)model;

@end
