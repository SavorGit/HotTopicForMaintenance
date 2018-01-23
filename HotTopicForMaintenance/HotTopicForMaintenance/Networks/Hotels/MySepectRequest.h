//
//  MySepectRequest.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/1/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface MySepectRequest : BGNetworkRequest

- (instancetype)initWithID:(NSString *)errorID pageNum:(NSString *)pagenum pageSize:(NSString *)pageSize;

@end
