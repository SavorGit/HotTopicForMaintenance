//
//  GetBindListReuqest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/8.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetBindListReuqest.h"
#import "Helper.h"

@implementation GetBindListReuqest

- (instancetype)initWithHotelId:(NSString *)hotelId roomID:(NSString *)roomID
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Bindbox/getBoxList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:hotelId forParamKey:@"hotel_id"];
        [self setValue:roomID forParamKey:@"room_id"];
    }
    return self;
}

@end
