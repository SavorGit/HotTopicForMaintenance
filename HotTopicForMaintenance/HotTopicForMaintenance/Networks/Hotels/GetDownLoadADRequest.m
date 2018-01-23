//
//  GetDownLoadADRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "GetDownLoadADRequest.h"
#import "Helper.h"

@implementation GetDownLoadADRequest

- (instancetype)initWithMediaADID:(NSString *)ADID boxID:(NSString *)boxID
{
    if (self = [super init]) {
        
        self.methodName = [@"Opclient20/Box/getDownloadAds?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:ADID forParamKey:@"ads_download_period"];
        [self setValue:boxID forParamKey:@"box_id"];
        
    }
    return self;
}

@end
