//
//  RepairRecordDetailModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface RepairRecordDetailModel : Jastor

@property (nonatomic, copy) NSString * create_time;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * repair_error;
@property (nonatomic, copy) NSString * remark;

@end
