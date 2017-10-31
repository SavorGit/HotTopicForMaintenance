//
//  TaskModel.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel

- (instancetype)initWithType:(TaskType)type
{
    if (self = [super init]) {
        
        [self configWithType:type];
        
    }
    return self;
}

- (void)configWithType:(TaskType)type
{
    self.type = type;
    switch (type) {
        case TaskType_Install:
        {
            self.type_Desc = @"安装与验收";
            self.logo_Desc = @"安";
        }
            break;
            
        case TaskType_InfoCheck:
        {
            self.type_Desc = @"信息检测";
            self.logo_Desc = @"检";
        }
            break;
            
        case TaskType_NetTransform:
        {
            self.type_Desc = @"网络改造";
            self.logo_Desc = @"网";
        }
            break;
            
        case TaskType_Repair:
        {
            self.type_Desc = @"维修";
            self.logo_Desc = @"修";
        }
            break;
            
        default:
            break;
    }
}

@end
