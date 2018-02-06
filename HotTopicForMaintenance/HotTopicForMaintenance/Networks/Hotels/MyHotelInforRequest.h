//
//  MyHotelInforRequest.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/2/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface MyHotelInforRequest : BGNetworkRequest

- (instancetype)initWithID:(NSString *)pUserId pageNum:(NSString *)pagenum pageSize:(NSString *)pageSize;

@end
