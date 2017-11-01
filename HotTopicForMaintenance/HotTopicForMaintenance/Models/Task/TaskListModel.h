//
//  TaskListModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

typedef enum : NSUInteger {
    TaskListType_All,           //全部
    TaskListType_WaitAssign,    //待指派
    TaskListType_WaitHandle,    //待处理
    TaskListType_Completed      //已完成
} TaskListType;

@interface TaskListModel : Jastor

@property (nonatomic, assign) TaskListType type;
@property (nonatomic, copy) NSString * handleName;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * remark;
@property (nonatomic, copy) NSString * cityName;
@property (nonatomic, copy) NSString * hotelName;
@property (nonatomic, copy) NSString * deviceNumber;
@property (nonatomic, copy) NSString * assignHandleTime;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * assignTime;
@property (nonatomic, copy) NSString * completeTime;

@end
