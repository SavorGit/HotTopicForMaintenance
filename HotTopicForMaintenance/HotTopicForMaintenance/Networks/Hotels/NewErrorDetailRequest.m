//
//  NewErrorDetailRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "NewErrorDetailRequest.h"
#import "Helper.h"

@implementation NewErrorDetailRequest

- (instancetype)initWithErrorID:(NSString *)errorID pageNumber:(NSInteger)page pageSize:(NSInteger)size
{
    if (self = [super init]) {
        self.methodName = [@"Opclient20/ErrorReport/getNewErrorDetail?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:errorID forParamKey:@"error_id"];
        [self setValue:[NSString stringWithFormat:@"%ld", page] forParamKey:@"pageNum"];
        [self setValue:[NSString stringWithFormat:@"%ld", size] forParamKey:@"pageSize"];
    }
    return self;
}

@end
