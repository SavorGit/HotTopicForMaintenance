//
//  InstallAlerTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RestaurantRankModel.h"

@protocol InstallCellDelegate<NSObject>

- (void)addImgPress:(NSIndexPath *)index;

@end

@interface InstallAlerTableViewCell : UITableViewCell

@property (nonatomic, weak) id <InstallCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *instaImg;
@property (nonatomic, strong) UIImageView *imgBgView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)configWithContent:(NSString *)titleString andIdexPath:(NSIndexPath *)index andDataModel:(RestaurantRankModel *)model;

@end
