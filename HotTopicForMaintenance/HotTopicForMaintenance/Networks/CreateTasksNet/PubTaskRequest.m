//
//  PubTaskRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "PubTaskRequest.h"
#import "Helper.h"

@implementation PubTaskRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic;
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Task/pubTask?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString([dataDic objectForKey:@"hotel_id"])) {
            [self setValue:[dataDic objectForKey:@"hotel_id"] forParamKey:@"hotel_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"task_emerge"])) {
            [self setValue:[dataDic objectForKey:@"task_emerge"] forParamKey:@"task_emerge"];
        }
        if (!isEmptyString([dataDic objectForKey:@"task_type"])) {
            [self setValue:[dataDic objectForKey:@"task_type"] forParamKey:@"task_type"];
        }
        
        // 选填
        if (!isEmptyString([dataDic objectForKey:@"addr"])) {
            [self setValue:[dataDic objectForKey:@"addr"] forParamKey:@"addr"];
        }
        if (!isEmptyString([dataDic objectForKey:@"contractor"])) {
            [self setValue:[dataDic objectForKey:@"contractor"] forParamKey:@"contractor"];
        }
        if (!isEmptyString([dataDic objectForKey:@"mobile"])) {
            [self setValue:[dataDic objectForKey:@"mobile"] forParamKey:@"mobile"];
        }
        if (!isEmptyString([dataDic objectForKey:@"repair_info"])) {
            [self setValue:[dataDic objectForKey:@"repair_info"] forParamKey:@"repair_info"];
        }
        if (!isEmptyString([dataDic objectForKey:@"tv_nums"])) {
            [self setValue:[dataDic objectForKey:@"tv_nums"] forParamKey:@"tv_nums"];
        }
    }
    return self;
}

@end
