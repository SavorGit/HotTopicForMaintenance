//
//  DeviceFaultModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface DeviceFaultModel : Jastor

@property (nonatomic, copy) NSString * box_name;
@property (nonatomic, copy) NSString * fault_desc;
@property (nonatomic, copy) NSString * fault_image_url;
@property (nonatomic, copy) NSString * box_id;

@end
