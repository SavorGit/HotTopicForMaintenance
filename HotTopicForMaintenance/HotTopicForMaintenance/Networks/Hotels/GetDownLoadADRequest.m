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

- (instancetype)initWithMediaADBoxMac:(NSString *)boxMac
{
    if (self = [super init]) {
        
        self.methodName = [@"Opclient20/BoxContent/getDownloadAds?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        [self setValue:boxMac forParamKey:@"box_mac"];
        
    }
    return self;
}

@end
