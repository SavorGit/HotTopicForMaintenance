//
//  SingleSearchHotelRequest.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/12/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface SingleSearchHotelRequest : BGNetworkRequest

- (instancetype)initWithHotelName:(NSString *)hotelName;

@end
