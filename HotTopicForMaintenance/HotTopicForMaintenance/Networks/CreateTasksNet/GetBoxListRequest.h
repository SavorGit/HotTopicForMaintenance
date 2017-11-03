//
//  GetBoxListRequest.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetBoxListRequest : BGNetworkRequest

- (instancetype)initWithHotelId:(NSString *)hotelId;

@end
