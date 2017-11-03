//
//  HotelGetIPRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HotelGetIPRequest.h"
#import "Helper.h"

@implementation HotelGetIPRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"basedata/Ip/getIp?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPGet;
    }
    return self;
}

@end
