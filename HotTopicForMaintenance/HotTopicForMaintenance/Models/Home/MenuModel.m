//
//  MenuModel.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/26.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel

- (instancetype)initWithMenuType:(MenuModelType)type
{
    if (self = [super init]) {
        self.type = type;
        [self configWithType:type];
    }
    return self;
}

- (void)configWithType:(MenuModelType)type
{
    switch (type) {
        case MenuModelType_CreateTask:
            
            self.title = @"发布任务";
            self.imageName = @"ywsy_fb";
            
            break;
            
        case MenuModelType_TaskList:
            
            self.title = @"任务列表";
            self.imageName = @"ywsy_rw";
            
            break;
            
        case MenuModelType_MyTask:
            
            self.title = @"我的任务";
            self.imageName = @"ywsy_rw";
            
            break;
            
        case MenuModelType_SystemStatus:
            
            self.title = @"系统状态";
            self.imageName = @"ywsy_xt";
            
            break;
            
        case MenuModelType_ErrorReport:
            
            self.title = @"异常报告";
            self.imageName = @"ywsy_yc";
            
            break;
            
        case MenuModelType_RepairRecord:
            
            self.title = @"维修记录";
            self.imageName = @"ywsy_wx";
            
            break;
            
        case MenuModelType_BindDevice:
            
            self.title = @"绑定版位";
            self.imageName = @"ywsy_bd";
            
            break;
            
        case MenuModelType_SingleVersion:
            
            self.title = @"更新换画";
            self.imageName = @"ywsy_gh";
            
            break;
            
        case MenuModelType_Inspect:
            
            self.title = @"巡检酒楼";
            self.imageName = @"xunjian";
            
            break;
            
        case MenuModelType_Space:
            
            self.title = @"";
            self.imageName = @"";
            
            break;
            
        default:
            break;
    }
}

@end
