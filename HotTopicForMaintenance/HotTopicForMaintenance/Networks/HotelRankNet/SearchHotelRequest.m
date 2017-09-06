//
//  SearchHotelRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SearchHotelRequest.h"
#import "Helper.h"

@implementation SearchHotelRequest

- (instancetype)initWithHotelName:(NSString *)hotelName
{
    if (self = [super init]) {
        self.methodName = [@"Opclient/hotel/searchHotel?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(hotelName)) {
            [self setValue:hotelName forParamKey:@"hotel_name"];
        }
    }
    return self;
}

@end
