//
//  TaskListViewController.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    TaskListType_All,           //全部
    TaskListType_WaitAssign,    //待指派
    TaskListType_WaitHandle,    //待处理
    TaskListType_Completed      //已完成
} TaskListType;

@interface TaskListViewController : BaseViewController

- (instancetype)initWithTaskListType:(TaskListType)type;

@end
