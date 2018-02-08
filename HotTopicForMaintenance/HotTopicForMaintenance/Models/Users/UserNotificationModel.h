//
//  UserNotificationModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/7.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    RDRemoteNotificationType_Error,
    RDRemoteNotificationType_Task
} RDRemoteNotificationType;

@interface UserNotificationModel : NSObject

@property (nonatomic, assign) RDRemoteNotificationType type;

@property (nonatomic, copy) NSString * error_id;
@property (nonatomic, copy) NSString * task_id;

@end
