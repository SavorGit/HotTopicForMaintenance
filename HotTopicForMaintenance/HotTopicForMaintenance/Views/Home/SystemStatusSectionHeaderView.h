//
//  SystemStatusSectionHeaderView.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/15.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SystemStatusType_Hotel,
    SystemStatusType_Platform,
    SystemStatusType_Box
} SystemStatusType;

@interface SystemStatusSectionHeaderView : UITableViewHeaderFooterView

- (void)configWithType:(SystemStatusType)type info:(NSDictionary *)info;

@end
