//
//  GetRepairRecordListRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetRepairRecordListRequest.h"
#import "Helper.h"

@implementation GetRepairRecordListRequest

- (instancetype)initWithUserID:(NSString *)userID pageNum:(NSString *)pageNum
{
    if (self = [super init]) {
        self.methodName = [@"Opclient/Box/getRepairRecordListByUserid?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:userID forParamKey:@"userid"];
        [self setValue:pageNum forParamKey:@"page_num"];
    }
    return self;
}

@end
