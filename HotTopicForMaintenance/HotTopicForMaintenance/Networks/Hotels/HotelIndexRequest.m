//
//  HotelIndexRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HotelIndexRequest.h"
#import "Helper.h"

@implementation HotelIndexRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.methodName = [@"Opclient/index/index?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
