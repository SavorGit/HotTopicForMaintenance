//
//  SingleSearchHotelRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/12/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SingleSearchHotelRequest.h"
#import "Helper.h"
#import "UserManager.h"

@implementation SingleSearchHotelRequest

- (instancetype)initWithHotelName:(NSString *)hotelName;
{
    if (self = [super init]) {
        self.methodName = [@"Tasksubcontract/hotel/searchHotel?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(hotelName)) {
            [self setValue:hotelName forParamKey:@"hotel_name"];
        }
       [self setValue:[UserManager manager].user.currentCity.cid forParamKey:@"area_id"];
    }
    return self;
}

@end
