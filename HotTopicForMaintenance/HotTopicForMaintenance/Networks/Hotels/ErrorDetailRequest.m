//
//  ErrorDetailRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ErrorDetailRequest.h"
#import "Helper.h"

@implementation ErrorDetailRequest

- (instancetype)initWithErrorID:(NSString *)errorID detailID:(NSString *)detailID pageSzie:(NSString *)pageSize
{
    if (self = [super init]) {
        self.methodName = [@"Opclient/ErrorReport/getErrorDetail?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:errorID forParamKey:@"error_id"];
        if (!isEmptyString(detailID)) {
            [self setValue:detailID forParamKey:@"detail_id"];
        }
        if (!isEmptyString(pageSize)) {
            [self setValue:pageSize forParamKey:@"pageSize"];
        }
    }
    return self;
}

@end
