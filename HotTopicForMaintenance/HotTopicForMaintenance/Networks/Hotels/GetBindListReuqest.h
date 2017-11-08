//
//  GetBindListReuqest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/8.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetBindListReuqest : BGNetworkRequest

- (instancetype)initWithHotelId:(NSString *)hotelId roomID:(NSString *)roomID;

@end
