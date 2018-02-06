//
//  MyHotelInforRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/2/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "MyHotelInforRequest.h"
#import "Helper.h"

@implementation MyHotelInforRequest

- (instancetype)initWithID:(NSString *)pUserId pageNum:(NSString *)pagenum pageSize:(NSString *)pageSize
{
    if (self = [super init]) {
        self.methodName = [@"Opclient20/Pubtask/getMytaskHotel?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(pUserId)) {
            [self setValue:pUserId forParamKey:@"publish_user_id"];
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
