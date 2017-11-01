//
//  RepairTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RepairTableViewDelegate<NSObject>
- (void)addNPress;
- (void)reduceNPress;

@end

@interface RepairTableViewCell : UITableViewCell

- (void)configWithTitle:(NSString *)title andContent:(NSString *)contenStr andIdexPath:(NSIndexPath *)index;

@end
