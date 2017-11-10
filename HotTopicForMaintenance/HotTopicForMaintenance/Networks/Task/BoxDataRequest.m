//
//  BoxDataRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/9.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BoxDataRequest.h"
#import "Helper.h"

@implementation BoxDataRequest

- (instancetype)initWithParamData:(NSDictionary *)dataDic{
    
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Mission/getexecutorInfo?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString([dataDic objectForKey:@"task_id"])) {
            [self setValue:[dataDic objectForKey:@"task_id"] forParamKey:@"task_id"];
        }
        if (!isEmptyString([dataDic objectForKey:@"task_type"])) {
            [self setValue:[dataDic objectForKey:@"task_type"] forParamKey:@"task_type"];
        }
        if (!isEmptyString([dataDic objectForKey:@"user_id"])) {
            [self setValue:[dataDic objectForKey:@"user_id"] forParamKey:@"user_id"];
        }
        
    }
    return self;
}

@end
