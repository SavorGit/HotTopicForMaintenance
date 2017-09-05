//
//  GetRepairRecordListRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetRepairRecordListRequest : BGNetworkRequest

- (instancetype)initWithUserID:(NSString *)userID pageNum:(NSString *)pageNum;

@end
