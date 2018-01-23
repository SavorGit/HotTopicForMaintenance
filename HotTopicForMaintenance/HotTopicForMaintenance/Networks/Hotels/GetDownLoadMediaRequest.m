//
//  GetDownLoadMediaRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "GetDownLoadMediaRequest.h"
#import "Helper.h"

@implementation GetDownLoadMediaRequest

- (instancetype)initWithMediaProID:(NSString *)proID
{
    if (self = [super init]) {
        
        self.methodName = [@"Opclient20/Box/getDownloadPro?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:proID forParamKey:@"pro_download_period"];
        
    }
    return self;
}

@end
