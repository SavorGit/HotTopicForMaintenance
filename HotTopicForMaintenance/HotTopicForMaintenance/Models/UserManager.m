//
//  UserManager.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserManager.h"

NSString * const RDUserLoginStatusDidChange = @"RDUserLoginStatusDidChange";
NSString * const RDTaskStatusDidChangeNotification = @"RDTaskStatusDidChangeNotification";

@implementation UserManager

+ (UserManager *)manager
{
    static UserManager * manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
        manager.longitude = 0.f;
        manager.latitude = 0.f;
        manager.locationName = @"位置获取失败";
    });
    return manager;
}

- (BOOL)isUserLoginStatusEnable
{
    return _user != nil;
}

- (void)setUser:(UserModel *)user
{
    if (_user != user) {
        _user = user;
        [[NSNotificationCenter defaultCenter] postNotificationName:RDUserLoginStatusDidChange object:nil];
    }
}

@end
