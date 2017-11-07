//
//  GetTaskCountRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetTaskCountRequest : BGNetworkRequest

- (instancetype)initWithAreaID:(NSString *)areaID userID:(NSString *)userID;
@end
