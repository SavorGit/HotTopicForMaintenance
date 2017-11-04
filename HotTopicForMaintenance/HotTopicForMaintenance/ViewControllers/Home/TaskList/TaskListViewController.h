//
//  TaskListViewController.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    TaskListType_All        = 0,    //全部
    TaskListType_WaitAssign = 1,    //待指派
    TaskListType_WaitHandle = 2,    //待处理
    TaskListType_Completed  = 4     //已完成
} TaskListType;

@interface TaskListViewController : BaseViewController

- (instancetype)initWithTaskListType:(TaskListType)type;

@end
