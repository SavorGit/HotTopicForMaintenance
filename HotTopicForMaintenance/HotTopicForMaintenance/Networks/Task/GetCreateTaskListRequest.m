//
//  GetCreateTaskListRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/8.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetCreateTaskListRequest.h"
#import "Helper.h"

@implementation GetCreateTaskListRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Basedata/getTaskTypeList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
