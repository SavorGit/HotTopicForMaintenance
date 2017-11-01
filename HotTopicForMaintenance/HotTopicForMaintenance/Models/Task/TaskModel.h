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

@interface TaskModel : Jastor

- (instancetype)initWithType:(TaskType)type;

@property (nonatomic, assign) TaskType type;
@property (nonatomic, copy) NSString * type_Desc;
@property (nonatomic, copy) NSString * logo_Desc;

@end
