//
//  RegDeviceToken.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/2/11.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "RegDeviceToken.h"
#import "Helper.h"
#import "UserManager.h"

@implementation RegDeviceToken

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/login/regDeviceToken?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:[UserManager manager].deviceToken forParamKey:@"device_token"];
        [self setValue:[UserManager manager].user.userid forParamKey:@"user_id"];
    }
    return self;
}

@end
