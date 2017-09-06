//
//  ErrorReportRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ErrorReportRequest.h"
#import "Helper.h"

@implementation ErrorReportRequest

- (instancetype)initWithID:(NSString *)errorID pageSize:(NSString *)pageSize
{
    if (self = [super init]) {
        self.methodName = [@"Opclient/hotel/searchHotel?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(errorID)) {
            [self setValue:errorID forParamKey:@"id"];
        }
        if (!isEmptyString(pageSize)) {
            [self setValue:pageSize forParamKey:@"pageSize"];
        }
    }
    return self;
}

@end
