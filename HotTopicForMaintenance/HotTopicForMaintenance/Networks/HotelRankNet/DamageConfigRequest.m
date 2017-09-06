//
//  DamageConfigRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "DamageConfigRequest.h"
#import "Helper.h"

@implementation DamageConfigRequest

- (instancetype)init;
{
    if (self = [super init]) {
        self.methodName = [@"Opclient/Box/getHotelBoxDamageConfig?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
    }
    return self;
}

@end
