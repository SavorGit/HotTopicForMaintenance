//
//  ErrorReportTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ErrorReportModel.h"

@interface ErrorReportTableViewCell : UITableViewCell

- (void)configWithModel:(ErrorReportModel *)model;

@end
