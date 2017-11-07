//
//  GetTaskCountRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetTaskCountRequest.h"
#import "Helper.h"

@implementation GetTaskCountRequest

- (instancetype)initWithAreaID:(NSString *)areaID userID:(NSString *)userID
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Task/countTaskNums?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:areaID forParamKey:@"area_id"];
        [self setValue:userID forParamKey:@"user_id"];
    }
    return self;
}

@end
