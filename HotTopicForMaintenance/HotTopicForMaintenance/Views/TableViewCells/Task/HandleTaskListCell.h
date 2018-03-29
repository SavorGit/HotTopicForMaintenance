//
//  HandleTaskListCell.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskAssinModel.h"

@protocol HandleTaskListCellDelegate<NSObject>

- (void)assignBtnClicked;

@end

@interface HandleTaskListCell : UITableViewCell

@property (nonatomic, assign) id<HandleTaskListCellDelegate> delegate;

- (void)configWithInfo:(NSDictionary *)info andModel:(TaskAssinModel *)model date:(NSString *)date taskID:(NSString *)taskID isInstallTeam:(NSInteger)installTeam;

@end
