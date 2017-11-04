//
//  CreateRoleTasklistRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CreateRoleTasklistRequest.h"
#import "Helper.h"

@implementation CreateRoleTasklistRequest

- (instancetype)initWithPage:(NSInteger)page state:(NSInteger)state userID:(NSString *)userID
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/task/pubTaskList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setIntegerValue:page forParamKey:@"page"];
        [self setIntegerValue:state forParamKey:@"state"];
        [self setValue:userID forParamKey:@"user_id"];
    }
    return self;
}

@end
