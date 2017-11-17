//
//  AssignRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AssignRequest.h"
#import "Helper.h"

@implementation AssignRequest

- (instancetype)initWithDate:(NSString *)date assginID:(NSString *)assignID handleID:(NSString *)handleID taskID:(NSString *)taskID isInstallTeam:(NSInteger)installTeam
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Task/appointTask?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:date forParamKey:@"appoint_exe_time"];
        [self setValue:assignID forParamKey:@"appoint_user_id"];
        [self setValue:handleID forParamKey:@"exe_user_id"];
        [self setValue:taskID forParamKey:@"task_id"];
        [self setIntegerValue:installTeam forParamKey:@"is_lead_install"];
    }
    return self;
}

@end
