//
//  SingleLookHotelInforRequest.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface SingleLookHotelInforRequest : BGNetworkRequest

- (instancetype)initWithId:(NSString *)cid;

@end
