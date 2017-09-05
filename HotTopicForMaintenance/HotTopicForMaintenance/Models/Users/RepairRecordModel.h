//
//  RepairRecordModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface RepairRecordModel : Jastor

@property (nonatomic, copy) NSString * nickname;
@property (nonatomic, copy) NSString * datetime;
@property (nonatomic, copy) NSString * hotel_name;

@property (nonatomic, strong) NSMutableArray * recordList;

@end
