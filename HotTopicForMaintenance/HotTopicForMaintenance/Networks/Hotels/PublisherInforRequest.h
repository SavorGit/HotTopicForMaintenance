//
//  PublisherInforRequest.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/2/6.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface PublisherInforRequest : BGNetworkRequest

- (instancetype)initWithId:(NSString *)cid;

@end
