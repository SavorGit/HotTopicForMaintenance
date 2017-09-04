//
//  UserManager.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

extern NSString * const RDUserLoginStatusDidChange; //已经连接至设备

@interface UserManager : NSObject

+ (UserManager *)manager;

@property (nonatomic, assign) BOOL isUserLoginStatusEnable;

@property (nonatomic, strong) UserModel * user;

@end
