//
//  ErrorDetailModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface ErrorDetailModel : Jastor

@property (nonatomic, copy) NSString * detail_id;
@property (nonatomic, copy) NSString * hotel_id;
@property (nonatomic, copy) NSString * hotel_info;
@property (nonatomic, copy) NSString * small_palt_info;
@property (nonatomic, copy) NSString * box_info;

@end
