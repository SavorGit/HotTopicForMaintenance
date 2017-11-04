//
//  TaskListDetailRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskListDetailRequest.h"
#import "Helper.h"

@implementation TaskListDetailRequest

- (instancetype)initWithTaskID:(NSString *)taskID
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/task/taskDetail?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:taskID forParamKey:@"task_id"];
    }
    return self;
}

@end
