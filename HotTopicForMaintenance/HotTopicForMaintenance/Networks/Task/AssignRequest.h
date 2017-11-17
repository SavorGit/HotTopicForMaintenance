//
//  AssignRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface AssignRequest : BGNetworkRequest

- (instancetype)initWithDate:(NSString *)date assginID:(NSString *)assignID handleID:(NSString *)handleID taskID:(NSString *)taskID isInstallTeam:(NSInteger)installTeam;

@end
