//
//  SingleDemageListRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/12/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SingleDemageListRequest.h"
#import "Helper.h"

@implementation SingleDemageListRequest

- (instancetype)init;
{
    if (self = [super init]) {
        self.methodName = [@"Tasksubcontract/Box/getHotelBoxDamageConfig?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
