//
//  MyInspectModel.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/1/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface MyInspectModel : Jastor

@property (nonatomic, copy) NSString * cid;
@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) NSString * date;

@property (nonatomic, copy) NSString * box_info;
@property (nonatomic, copy) NSString * hotel_id;
@property (nonatomic, copy) NSString * hotel_info;
@property (nonatomic, copy) NSString * hotel_name;
@property (nonatomic, copy) NSString * small_palt_info;
@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSString * isNextPage;

@end
