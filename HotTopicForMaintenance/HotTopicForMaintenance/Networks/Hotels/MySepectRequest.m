//
//  MySepectRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/1/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "MySepectRequest.h"
#import "Helper.h"

@implementation MySepectRequest

- (instancetype)initWithID:(NSString *)errorID pageNum:(NSString *)pagenum pageSize:(NSString *)pageSize
{
    if (self = [super init]) {
        self.methodName = [@"Opclient20/Inspector/getMyInspect?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(errorID)) {
            [self setValue:errorID forParamKey:@"user_id"];
        }
        
        // 选填
        if (!isEmptyString(pagenum)) {
            [self setValue:pagenum forParamKey:@"pageNum"];
        }
        if (!isEmptyString(pageSize)) {
            [self setValue:pageSize forParamKey:@"pageSize"];
        }
    }
    return self;
}

@end

