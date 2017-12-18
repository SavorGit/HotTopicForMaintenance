//
//  UserManager.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "UserNotificationModel.h"

extern NSString * const RDUserLoginStatusDidChange; //用户登录状态改变
extern NSString * const RDTaskStatusDidChangeNotification; //用户任务状态改变

@interface UserManager : NSObject

+ (UserManager *)manager;

@property (nonatomic, assign) BOOL isUserLoginStatusEnable;

@property (nonatomic, strong) UserModel * user;

@property (nonatomic, strong) NSMutableArray * allUsers;

@property (nonatomic, strong) UserNotificationModel * notificationModel;

@property (nonatomic, assign) double latitude;

@property (nonatomic, assign) double longitude;

@property (nonatomic, copy) NSString * locationName;

@end
