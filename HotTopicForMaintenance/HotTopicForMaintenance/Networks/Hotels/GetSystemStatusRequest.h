//
//  GetSystemStatusRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetSystemStatusRequest : BGNetworkRequest

- (instancetype)initWithCityID:(NSString *)cityID;

@end
