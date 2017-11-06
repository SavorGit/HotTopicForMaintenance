//
//  HandleTaskListRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface HandleTaskListRequest : BGNetworkRequest

- (instancetype)initWithDate:(NSString *)date installTeam:(BOOL)isTeam taskID:(NSString *)taskID;

@end
