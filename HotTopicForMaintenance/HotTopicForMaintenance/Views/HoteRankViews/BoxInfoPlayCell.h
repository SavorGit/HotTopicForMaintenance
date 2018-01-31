//
//  BoxInfoPlayCell.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoxInfoPlayCell : UITableViewCell

@property (nonatomic, strong) UILabel * playTitleLabel;

- (void)configWithDict:(NSDictionary *)dict;

- (void)configNoFlagWithDict:(NSDictionary *)dict;

@end
