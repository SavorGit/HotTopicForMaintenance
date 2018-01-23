//
//  GetSystemStatusRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "GetSystemStatusRequest.h"
#import "Helper.h"

@implementation GetSystemStatusRequest

- (instancetype)initWithCityID:(NSString *)cityID
{
    if (self = [super init]) {
        
        self.methodName = [@"Opclient20/System/index?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:cityID forParamKey:@"city_id"];
        
    }
    return self;
}

@end
