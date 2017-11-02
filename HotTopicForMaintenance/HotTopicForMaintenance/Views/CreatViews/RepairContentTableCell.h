//
//  RepairContentTableCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepairContentModel.h"

@protocol RepairContentDelegate<NSObject>

- (void)selectPosion:(UIButton *)btn;
- (void)addImgPress:(NSIndexPath *)index;

@end

@interface RepairContentTableCell : UITableViewCell

@property (nonatomic, weak) id <RepairContentDelegate> delegate;

@property (nonatomic, strong) UIImageView *fImageView;

- (void)configWithContent:(RepairContentModel *)model andIdexPath:(NSIndexPath *)index;

@end
