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

@property (nonatomic, assign) NSInteger type_id;
@property (nonatomic, copy) NSString * type_name;
@property (nonatomic, copy) NSString * bref;

@end
