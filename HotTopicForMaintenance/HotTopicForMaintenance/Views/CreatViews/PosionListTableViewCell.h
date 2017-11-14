//
//  PosionListTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantRankModel.h"

@interface PosionListTableViewCell : UITableViewCell

//@property (nonatomic, strong) UIImageView *selectImgView;
@property (nonatomic, strong) UIImageView *leftImage;

- (void)configWithModel:(RestaurantRankModel *)model;

@end
