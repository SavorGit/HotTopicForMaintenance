//
//  BindBoxRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/8.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface BindBoxRequest : BGNetworkRequest

- (instancetype)initWithHotelID:(NSString *)hotelID roomID:(NSString *)roomID boxID:(NSString *)boxID mac:(NSString *)mac;

@end
