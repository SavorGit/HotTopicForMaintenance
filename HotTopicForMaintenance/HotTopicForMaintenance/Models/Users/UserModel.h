//
//  UserModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

typedef enum : NSUInteger {
    UserRoleType_CreateTask = 1,
    UserRoleType_AssignTask = 2,
    UserRoleType_HandleTask = 3,
    UserRoleType_LookTask = 4
} UserRoleType;

@interface UserModel : Jastor

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, assign) UserRoleType roletype;
@property (nonatomic, copy) NSString * roleName;

@end
