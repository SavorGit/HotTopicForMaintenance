//
//  StateConfigRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/1/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "StateConfigRequest.h"
#import "Helper.h"

@implementation StateConfigRequest

- (instancetype)init;
{
    if (self = [super init]) {
        self.methodName = [@"Opclient20/Box/stateConf?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
