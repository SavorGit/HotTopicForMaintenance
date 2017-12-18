//
//  SingleVRestaurantRankCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/12/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantRankModel.h"
#import "RepairRecordRankModel.h"

@interface SingleVRestaurantRankCell : UITableViewCell

//    点击按钮block回调
@property (nonatomic,copy) void(^btnClick)(RestaurantRankModel *);

@property (nonatomic,copy) void(^singleBtnClick)(NSIndexPath *);

- (void)configWithModel:(RestaurantRankModel *)model;

@end
