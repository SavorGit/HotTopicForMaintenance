//
//  RefuseRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RefuseRequest.h"
#import "Helper.h"

@implementation RefuseRequest

- (instancetype)initWithDesc:(NSString *)desc taskID:(NSString *)taskID userID:(NSString *)userID
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Task/refuseTask?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:userID forParamKey:@"user_id"];
        [self setValue:taskID forParamKey:@"task_id"];
        
        if (!isEmptyString(desc)) {
            [self setValue:desc forParamKey:@"refuse_desc"];
        }
    }
    return self;
}

@end
