//
//  DamageUploadModel.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/9/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface DamageUploadModel : Jastor

@property(nonatomic, copy) NSString *userid;
@property(nonatomic, copy) NSString *box_mac;
@property(nonatomic, copy) NSString *hotel_id;
@property(nonatomic, copy) NSString *repair_num_str;
@property(nonatomic, copy) NSString *state; //1已经解决 2未解决
@property(nonatomic, copy) NSString *type; //类型1小平台2机顶盒
@property(nonatomic, copy) NSString *remakr;

@end
