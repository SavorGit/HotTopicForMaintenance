//
//  SingleGetHotelVRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/12/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SingleGetHotelVRequest.h"
#import "Helper.h"

@implementation SingleGetHotelVRequest

- (instancetype)initWithHotelId:(NSString *)hotelId{
    
    if (self = [super init]) {
        self.methodName = [@"Tasksubcontract/Hotel/getSingleHotelVersionById?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(hotelId)) {
            [self setValue:hotelId forParamKey:@"hotel_id"];
        }
    }
    return self;
}

@end
