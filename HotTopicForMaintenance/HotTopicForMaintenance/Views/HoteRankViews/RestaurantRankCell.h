//
//  RestaurantRankCell.h
//  SavorX
//
//  Created by 王海朋 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantRankModel.h"

@interface RestaurantRankCell : UITableViewCell

//	点击按钮block回调
@property (nonatomic,copy) void(^btnClick)(RestaurantRankModel *);

- (void)configWithModel:(RestaurantRankModel *)model;

@end
