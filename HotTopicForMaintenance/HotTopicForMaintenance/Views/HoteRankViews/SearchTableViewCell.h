//
//  SearchTableViewCell.h
//  SavorX
//
//  Created by 王海朋 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantRankModel.h"

@interface SearchTableViewCell : UITableViewCell

- (void)configWithModel:(RestaurantRankModel *)model;
@end
