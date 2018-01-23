//
//  GetCityListRequest.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "GetCityListRequest.h"
#import "Helper.h"

@implementation GetCityListRequest

- (instancetype)init
{if (self = [super init]) {
    
    self.methodName = [@"Opclient20/City/getAreaList?" stringByAppendingString:[Helper getURLPublic]];
    self.httpMethod = BGNetworkRequestHTTPPost;
    
}
    return self;}

@end
