//
//  DamageUploadRequest.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/9/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <BGNetwork/BGNetwork.h>
#import "DamageUploadModel.h"

@interface DamageUploadRequest : BGNetworkRequest

- (instancetype)initWithModel:(DamageUploadModel *)model;

@end
