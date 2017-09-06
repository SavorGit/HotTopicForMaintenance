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

@end
