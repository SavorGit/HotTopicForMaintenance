//
//  LookHotelInforModel.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface LookHotelInforModel : Jastor

@property(nonatomic, copy) NSString *hotel_name;
@property(nonatomic, copy) NSString *hotel_addr;

@property(nonatomic, copy) NSString *area_name;
@property(nonatomic, copy) NSString *level;
@property(nonatomic, copy) NSString *install_date;
@property(nonatomic, copy) NSString *contractor;//酒楼联系人
@property(nonatomic, copy) NSString *maintainer;//合作维护人
@property(nonatomic, copy) NSString *tel;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *tech_maintainer;//技术运维人

@property(nonatomic, copy) NSString *is_key;
@property(nonatomic, copy) NSString *state_change_reason;//状态变更说明
@property(nonatomic, copy) NSString *hotel_state;
@property(nonatomic, copy) NSString *hotel_box_type;
@property(nonatomic, copy) NSString *server_location;
@property(nonatomic, copy) NSString *mac_addr;
@property(nonatomic, copy) NSString *remote_id;//小平台远程ID
@property(nonatomic, copy) NSString *hotel_wifi_pas;

@property(nonatomic, copy) NSString *gps;
@property(nonatomic, copy) NSString *hotel_wifi;
@property(nonatomic, copy) NSString *menu_name;//节目单名称

@property(nonatomic, copy) NSString *room_num;
@property(nonatomic, copy) NSString *box_num;
@property(nonatomic, copy) NSString *tv_num;

@property(nonatomic, copy) NSString *bmac_addr;
@property(nonatomic, copy) NSString *bmac_name;//机顶盒名称
@property(nonatomic, copy) NSString *room_name;
@property(nonatomic, copy) NSString *bstate;

@end
