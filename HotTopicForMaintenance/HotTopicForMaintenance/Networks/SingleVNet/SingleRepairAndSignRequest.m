//
//  SingleRepairAndSignRequest.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/12/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SingleRepairAndSignRequest.h"
#import "Helper.h"
#import "UserManager.h"

@implementation SingleRepairAndSignRequest

- (instancetype)initWithModel:(DamageUploadModel *)model{
    
    if (self = [super init]) {
        self.methodName = [@"Tasksubcontract/Box/insertSingleBoxDamage?" stringByAppendingString:[Helper getURLPublic]];
        self.httpMethod = BGNetworkRequestHTTPPost;
        
        // 必填
        [self setValue:model.bid forParamKey:@"bid"];
        [self setValue:model.hotel_id forParamKey:@"hotel_id"];
        [self setValue:[UserManager manager].user.userid forParamKey:@"userid"];
        [self setValue:model.srtype forParamKey:@"srtype"];
        [self setValue:model.current_location forParamKey:@"current_location"];
        
        // 选填
        [self setValue:model.remakr forParamKey:@"remark"];
        [self setValue:model.imgUrl forParamKey:@"repair_img"];
        [self setValue:model.repair_num_str forParamKey:@"repair_type"];
        
    }
    return self;
}

@end
