//
//  OneKeyCheckRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "OneKeyCheckRequest.h"
#import "Helper.h"

@implementation OneKeyCheckRequest

- (instancetype)initWithBoxID:(NSString *)boxID
{
    if (self = [super init]) {
        
        self.methodName = [@"Opclient20/Box/oneKeyCheck?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:boxID forParamKey:@"box_id"];
        
    }
    return self;
}

@end
