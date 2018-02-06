//
//  PublisherInforRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/2/6.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "PublisherInforRequest.h"
#import "Helper.h"

@implementation PublisherInforRequest

- (instancetype)initWithId:(NSString *)cid;
{
    if (self = [super init]) {
        self.methodName = [@"Opclient20/Pubtask/getPubUser?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        if (!isEmptyString(cid)) {
            [self setValue:cid forParamKey:@"publish_user_id"];
        }
    }
    return self;
}

@end
