//
//  SingleLookHotelInforRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SingleLookHotelInforRequest.h"
#import "Helper.h"

@implementation SingleLookHotelInforRequest

- (instancetype)initWithId:(NSString *)cid;
{
    if (self = [super init]) {
        self.methodName = [@"Tasksubcontract/Hotel/getHotelMacInfoById?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(cid)) {
            [self setValue:cid forParamKey:@"hotel_id"];
        }
    }
    return self;
}

@end
