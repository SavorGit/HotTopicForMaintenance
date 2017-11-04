//
//  NetworkTranTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NetworkTranDelegate<NSObject>

- (void)hotelPress:(NSIndexPath *)index;
- (void)Segmented:(NSInteger )segTag;

@end

@interface NetworkTranTableViewCell : UITableViewCell

@property (nonatomic, weak) id <NetworkTranDelegate> delegate;

- (void)configWithTitle:(NSString *)title andContent:(NSString *)contenStr andIdexPath:(NSIndexPath *)index;

@end
