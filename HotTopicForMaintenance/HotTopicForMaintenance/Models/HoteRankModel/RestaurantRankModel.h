//
//  RestaurantRankModel.h
//  SavorX
//
//  Created by 王海朋 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface RestaurantRankModel : Jastor

@property (nonatomic, assign) NSInteger  stateType;

@property (nonatomic, assign) BOOL  selectType;

//搜索酒楼
@property (nonatomic, copy) NSString * cid;//非服务器返回
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *contractor;
@property(nonatomic, copy) NSString *mobile;
@property(nonatomic, copy) NSString *addr;
@property(nonatomic, copy) NSString *area_id;
@property(nonatomic, copy) NSString *tv_nums;

//酒楼版位列表
@property(nonatomic, copy) NSString *box_id;
@property(nonatomic, copy) NSString *box_name;
@property(nonatomic, copy) NSString *repair_img;
@property(nonatomic, strong) UIImage *seRepairImg;

//酒楼版位信息
@property(nonatomic, copy) NSString *boxname;
@property(nonatomic, copy) NSString *last_heart_time;
@property(nonatomic, copy) NSString *mac;
@property(nonatomic, copy) NSString *rname;
@property(nonatomic, assign) NSInteger ustate;
@property(nonatomic, copy) NSString *last_nginx;
//酒楼版位信息(version)
@property(nonatomic, assign) NSInteger lstate;
@property(nonatomic, copy) NSString *ltime;
@property(nonatomic, copy) NSString *last_small_pla;
@property(nonatomic, assign) NSInteger last_small_state;
//酒楼版位信息(其他)
@property(nonatomic, copy) NSString *neSmall;
@property(nonatomic, copy) NSString *small_mac;
@property(nonatomic, copy) NSString *banwei;

@property (nonatomic, strong) NSMutableArray * recordList;

//获取酒楼基本损坏配置表
@property(nonatomic, copy) NSString *reason;

@end
