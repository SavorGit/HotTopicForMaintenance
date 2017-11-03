//
//  RepairHeaderTableCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RepairHeaderTableDelegate<NSObject>
- (void)addNPress;
- (void)reduceNPress;
- (void)hotelPress:(NSIndexPath *)index;

@end

@interface RepairHeaderTableCell : UITableViewCell

@property (nonatomic, weak) id <RepairHeaderTableDelegate> delegate;

@property (nonatomic, strong) UIButton *hotelBtn;
@property (nonatomic, strong) UITextField *inPutTextField;

- (void)configWithTitle:(NSString *)title andContent:(NSString *)contenStr andIdexPath:(NSIndexPath *)index;

@end
