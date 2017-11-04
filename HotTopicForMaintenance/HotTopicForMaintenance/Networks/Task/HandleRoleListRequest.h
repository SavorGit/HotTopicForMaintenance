//
//  HandleRoleListRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface HandleRoleListRequest : BGNetworkRequest

- (instancetype)initWithPage:(NSInteger)page state:(NSInteger)state userID:(NSString *)userID;

@end
