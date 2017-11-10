//
//  BoxDataRequest.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/9.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface BoxDataRequest : BGNetworkRequest

- (instancetype)initWithParamData:(NSDictionary *)dataDic;

@end
