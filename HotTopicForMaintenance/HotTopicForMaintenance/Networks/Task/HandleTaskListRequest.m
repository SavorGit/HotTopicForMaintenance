//
//  HandleTaskListRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HandleTaskListRequest.h"
#import "Helper.h"

@implementation HandleTaskListRequest

- (instancetype)initWithDate:(NSString *)date installTeam:(BOOL)isTeam taskID:(NSString *)taskID
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Task/getExeUserList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:date forParamKey:@"exe_date"];
        [self setValue:taskID forParamKey:@"task_id"];
        
        [self setBOOLValue:isTeam forParamKey:@"is_lead_install"];
    }
    return self;
}

@end
