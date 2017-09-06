//
//  ErrorReportRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface ErrorReportRequest : BGNetworkRequest

- (instancetype)initWithID:(NSString *)errorID pageSize:(NSString *)pageSize;

@end
