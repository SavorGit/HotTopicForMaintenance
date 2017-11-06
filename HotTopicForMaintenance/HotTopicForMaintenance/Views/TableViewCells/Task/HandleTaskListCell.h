//
//  HandleTaskListCell.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandleTaskListCell : UITableViewCell

- (void)configWithInfo:(NSDictionary *)info date:(NSString *)date taskID:(NSString *)taskID;

@end
