//
//  DamageUploadRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/9/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "DamageUploadRequest.h"
#import "Helper.h"

@implementation DamageUploadRequest

- (instancetype)initWithModel:(DamageUploadModel *)model{
    
    if (self = [super init]) {
        self.methodName = [@"Opclient/Box/InsertBoxDamage?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        [self setValue:model.userid forParamKey:@"userid"];
        [self setValue:model.box_mac forParamKey:@"box_mac"];
        [self setValue:model.hotel_id forParamKey:@"hotel_id"];
        [self setValue:model.type forParamKey:@"type"];
        [self setValue:model.state forParamKey:@"state"];
        [self setValue:model.repair_num_str forParamKey:@"repair_num_str"];
        [self setValue:model.remakr forParamKey:@"remakr"];
    }
    return self;
}

@end
