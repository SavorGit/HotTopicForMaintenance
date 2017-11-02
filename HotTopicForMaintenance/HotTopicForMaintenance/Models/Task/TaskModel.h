//
//  TaskModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

typedef enum : NSUInteger {
    TaskType_Install,
    TaskType_InfoCheck,
    TaskType_NetTransform,
    TaskType_Repair
} TaskType;

typedef enum : NSUInteger {
    TaskStatusType_WaitAssign = 1,
    TaskStatusType_WaitHandle = 2,
    TaskStatusType_Completed= 3,
    TaskStatusType_Refuse = 4
} TaskStatusType;

@interface TaskModel : Jastor

@property (nonatomic, assign) TaskType type;
@property (nonatomic, assign) TaskStatusType statusType;
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
@property (nonatomic, copy) NSString * refuseTime;

@property (nonatomic, copy) NSString * localtion;
@property (nonatomic, copy) NSString * contacts;
@property (nonatomic, copy) NSString * contactWay;

@end
