//
//  MenuModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/26.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MenuModelType_CreateTask,
    MenuModelType_TaskList,
    MenuModelType_MyTask,
    MenuModelType_SystemStatus,
    MenuModelType_ErrorReport,
    MenuModelType_RepairRecord,
    MenuModelType_BindDevice
} MenuModelType;

@interface MenuModel : NSObject

- (instancetype)initWithMenuType:(MenuModelType)type;

@property (nonatomic, assign) MenuModelType type;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * imageName;

@end
