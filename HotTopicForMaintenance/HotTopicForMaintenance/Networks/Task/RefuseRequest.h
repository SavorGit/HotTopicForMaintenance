//
//  RefuseRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface RefuseRequest : BGNetworkRequest

- (instancetype)initWithDesc:(NSString *)desc taskID:(NSString *)taskID userID:(NSString *)userID;

@end
