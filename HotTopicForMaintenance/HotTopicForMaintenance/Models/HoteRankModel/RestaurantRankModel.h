//
//  RestaurantRankModel.h
//  SavorX
//
//  Created by 王海朋 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface RestaurantRankModel : Jastor

@property (nonatomic, copy) NSString *string1;
@property (nonatomic, copy) NSString *string2;
@property (nonatomic, copy) NSString *string3;
@property (nonatomic, copy) NSString *string4;
@property (nonatomic, copy) NSString *string5;
@property (nonatomic, copy) NSString *string6;
@property (nonatomic, assign) NSInteger  stateType;

@property (nonatomic, assign) BOOL  selectType;

//搜索酒楼
@property (nonatomic, assign) NSInteger cid;//非服务器返回
@property(nonatomic, copy) NSString *name;

//酒楼版位信息
@property(nonatomic, copy) NSString *boxname;
@property(nonatomic, copy) NSString *last_heart_time;
@property(nonatomic, copy) NSString *mac;
@property(nonatomic, copy) NSString *rname;
@property(nonatomic, copy) NSString *ustate;
//酒楼版位信息(version)
@property(nonatomic, copy) NSString *lstate;
@property(nonatomic, copy) NSString *ltime;
@property(nonatomic, copy) NSString *last_small_pla;
@property(nonatomic, copy) NSString *last_small_state;
//酒楼版位信息(其他)
//@property(nonatomic, copy) NSString *new_small1;
@property(nonatomic, copy) NSString *banwei;

@property (nonatomic, strong) NSMutableArray * recordList;

@end
