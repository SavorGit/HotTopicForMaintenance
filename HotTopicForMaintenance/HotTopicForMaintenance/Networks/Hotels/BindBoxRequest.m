//
//  BindBoxRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/8.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BindBoxRequest.h"
#import "Helper.h"

@implementation BindBoxRequest

- (instancetype)initWithHotelID:(NSString *)hotelID roomID:(NSString *)roomID boxID:(NSString *)boxID mac:(NSString *)mac
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Bindbox/bindBox?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:hotelID forParamKey:@"hotel_id"];
        [self setValue:roomID forParamKey:@"room_id"];
        [self setValue:boxID forParamKey:@"box_id"];
        [self setValue:mac forParamKey:@"new_mac"];
    }
    return self;
}

@end
