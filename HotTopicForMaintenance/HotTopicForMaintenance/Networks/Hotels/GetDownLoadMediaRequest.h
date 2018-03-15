//
//  GetDownLoadMediaRequest.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/22.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>

@interface GetDownLoadMediaRequest : BGNetworkRequest

- (instancetype)initWithMediaBoxMac:(NSString *)boxMac;

@end
