//
//  UserLoginRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserLoginRequest.h"
#import "Helper.h"
#import "UserManager.h"

@implementation UserLoginRequest

- (instancetype)initWithName:(NSString *)name password:(NSString *)password
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/login/doLogin?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:name forParamKey:@"username"];
        [self setValue:password forParamKey:@"password"];
    }
    return self;
}

@end
