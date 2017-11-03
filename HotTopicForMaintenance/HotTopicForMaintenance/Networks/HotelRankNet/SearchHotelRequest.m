//
//  SearchHotelRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SearchHotelRequest.h"
#import "Helper.h"
#import "UserManager.h"

@implementation SearchHotelRequest

- (instancetype)initWithHotelName:(NSString *)hotelName;
{
    if (self = [super init]) {
        self.methodName = [@"Opclient11/Hotel/searchHotel?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(hotelName)) {
            [self setValue:hotelName forParamKey:@"hotel_name"];
        }
        [self setValue:[UserManager manager].user.currentCity.cid forParamKey:@"area_id"];
    }
    return self;
}

@end
