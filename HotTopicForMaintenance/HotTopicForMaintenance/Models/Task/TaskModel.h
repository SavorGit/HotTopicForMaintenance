//
//  TaskModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

typedef enum : NSUInteger {
    TaskType_InfoCheck = 1,     //信息检测
    TaskType_Install = 2,       //安装验收
    TaskType_Repair = 4,        //维修
    TaskType_NetTransform = 8   //网络改造
} TaskType;

typedef enum : NSUInteger {
    TaskStatusType_WaitAssign = 1,  //待指派
    TaskStatusType_WaitHandle = 2,  //待处理
    TaskStatusType_Completed= 4,    //已完成
    TaskStatusType_Refuse = 5       //已拒绝
} TaskStatusType;

typedef enum : NSUInteger {
    TaskEmergeType_Urgent,  //紧急
    TaskEmergeType_Normal   //正常
} TaskEmergeType;

@interface TaskModel : Jastor

@property (nonatomic, assign) NSInteger task_type_id;
@property (nonatomic, assign) NSInteger state_id;
@property (nonatomic, assign) NSInteger task_emerge_id;

@property (nonatomic, copy) NSString * cid;
@property (nonatomic, copy) NSString * hotel_id;
@property (nonatomic, copy) NSString * task_type;
@property (nonatomic, copy) NSString * task_type_desc;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * task_emerge;
@property (nonatomic, copy) NSString * region_name;
@property (nonatomic, copy) NSString * hotel_name;
@property (nonatomic, copy) NSString * tv_nums;

@property (nonatomic, copy) NSString * appoint_exe_time;
@property (nonatomic, copy) NSString * exeuser;

@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * publish_user;

@property (nonatomic, copy) NSString * appoint_time;
@property (nonatomic, copy) NSString * appoint_user;

@property (nonatomic, copy) NSString * complete_time;

@property (nonatomic, copy) NSString * refuse_time;
@property (nonatomic, copy) NSString * refuse_desc;

@property (nonatomic, copy) NSString * hotel_address;

@property (nonatomic, copy) NSString * hotel_linkman;
@property (nonatomic, copy) NSString * hotel_linkman_tel;

@property (nonatomic, assign) NSInteger is_lead_install;

@end
