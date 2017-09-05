//
//  GetAllUserRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetAllUserRequest.h"
#import "Helper.h"

@implementation GetAllUserRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"Opclient/Box/getAllRepairUser?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
