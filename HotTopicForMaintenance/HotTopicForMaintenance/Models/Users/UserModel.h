//
//  UserModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"
#import "CityModel.h"
#import "SkillModel.h"

typedef enum : NSUInteger {
    UserRoleType_CreateTask = 1,
    UserRoleType_AssignTask = 2,
    UserRoleType_HandleTask = 3,
    UserRoleType_LookTask = 4
} UserRoleType;

extern NSString * const RDUserCityDidChangeNotification; //已经连接至设备

@interface UserModel : Jastor

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) UserRoleType roletype;
@property (nonatomic, copy) NSString * roleName;

@property (nonatomic, assign) NSInteger is_lead_install;

@property (nonatomic, strong) CityModel * currentCity;

@property (nonatomic, strong) NSMutableArray<CityModel *> * cityArray;
@property (nonatomic, strong) NSMutableArray<SkillModel *> * skillArray;

@end
