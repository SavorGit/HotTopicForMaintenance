//
//  DeviceFaultModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface DeviceFaultModel : Jastor

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSString * imageURL;

@end
