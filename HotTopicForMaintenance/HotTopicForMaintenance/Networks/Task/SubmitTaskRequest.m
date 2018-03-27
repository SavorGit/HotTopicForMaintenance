//
//  SubmitTaskRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SubmitTaskRequest.h"
#import "Helper.h"

@implementation SubmitTaskRequest

- (instancetype)initWithPubData:(NSDictionary *)dataDic;
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Mission/reportMission?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString([dataDic objectForKey:@"box_id"])) {
            [self setValue:[dataDic objectForKey:@"box_id"] forParamKey:@"box_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"state"])) {
            [self setValue:[dataDic objectForKey:@"state"] forParamKey:@"state"];
        }
        if (!isEmptyString([dataDic objectForKey:@"task_id"])) {
            [self setValue:[dataDic objectForKey:@"task_id"] forParamKey:@"task_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"task_type"])) {
            [self setValue:[dataDic objectForKey:@"task_type"] forParamKey:@"task_type"];
        }
        if (!isEmptyString([dataDic objectForKey:@"user_id"])) {
            [self setValue:[dataDic objectForKey:@"user_id"] forParamKey:@"user_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"repair_img"])) {
            [self setValue:[dataDic objectForKey:@"repair_img"] forParamKey:@"repair_img"];
        }
        
        // 选填
        if (!isEmptyString([dataDic objectForKey:@"remark"])) {
            [self setValue:[dataDic objectForKey:@"remark"] forParamKey:@"remark"];
        }
        if (!isEmptyString([dataDic objectForKey:@"real_tv_nums"])) {
            [self setValue:[dataDic objectForKey:@"real_tv_nums"] forParamKey:@"real_tv_nums"];
        }
        
    }
    return self;
}

@end
