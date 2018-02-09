//
//  NewErrorDetailRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface NewErrorDetailRequest : BGNetworkRequest

- (instancetype)initWithErrorID:(NSString *)errorID pageNumber:(NSInteger)page pageSize:(NSInteger)size;

@end