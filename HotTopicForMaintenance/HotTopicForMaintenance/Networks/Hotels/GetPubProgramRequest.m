//
//  GetPubProgramRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "GetPubProgramRequest.h"
#import "Helper.h"

@implementation GetPubProgramRequest

- (instancetype)initWithBoxID:(NSString *)boxID
{
    if (self = [super init]) {
        
        self.methodName = [@"Opclient20/Box/getPubProgram?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:boxID forParamKey:@"box_id"];
        
    }
    return self;
}


@end
