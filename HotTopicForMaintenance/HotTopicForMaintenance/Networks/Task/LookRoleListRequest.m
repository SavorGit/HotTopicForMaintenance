//
//  LookRoleListRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "LookRoleListRequest.h"
#import "Helper.h"
#import "UserManager.h"

@implementation LookRoleListRequest

- (instancetype)initWithPage:(NSInteger)page state:(NSInteger)state userID:(NSString *)userID
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/task/viewTaskList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setIntegerValue:page forParamKey:@"page"];
        [self setIntegerValue:state forParamKey:@"state"];
        [self setValue:userID forParamKey:@"user_id"];
        
        NSString * cityID = [UserManager manager].user.currentCity.cid;
        if (!isEmptyString(cityID)) {
            [self setValue:cityID forParamKey:@"city_id"];
        }
    }
    return self;
}

@end
