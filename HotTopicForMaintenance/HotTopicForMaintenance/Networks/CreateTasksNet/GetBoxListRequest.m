//
//  GetBoxListRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "GetBoxListRequest.h"
#import "Helper.h"

@implementation GetBoxListRequest

- (instancetype)initWithHotelId:(NSString *)hotelId
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Box/getBoxList?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(hotelId)) {
            [self setValue:hotelId forParamKey:@"hotel_id"];
        }
    }
    return self;
}

@end
