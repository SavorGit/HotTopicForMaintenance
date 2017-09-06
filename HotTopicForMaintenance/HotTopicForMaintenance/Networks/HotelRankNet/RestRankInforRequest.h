//
//  RestRankInforRequest.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface RestRankInforRequest : BGNetworkRequest

- (instancetype)initWithId:(NSString *)cid;

@end
