//
//  RestRankInforRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RestRankInforRequest.h"
#import "Helper.h"

@implementation RestRankInforRequest

- (instancetype)initWithId:(NSString *)cid;
{
    if (self = [super init]) {
        self.methodName = [@"Opclient/Hotel/getHotelVersionById?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(cid)) {
            [self setValue:cid forParamKey:@"hotel_id"];
        }
    }
    return self;
}

@end
