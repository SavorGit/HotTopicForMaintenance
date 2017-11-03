//
//  TaskListModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"
#import "TaskModel.h"

@interface TaskListModel : Jastor

- (instancetype)initWithType:(TaskType)type;

@property (nonatomic, assign) TaskType type;
@property (nonatomic, copy) NSString * type_Desc;
@property (nonatomic, copy) NSString * logo_Desc;

@end
