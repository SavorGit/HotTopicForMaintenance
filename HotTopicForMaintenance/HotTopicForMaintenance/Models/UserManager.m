//
//  UserManager.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserManager.h"

NSString * const RDUserLoginStatusDidChange = @"RDUserLoginStatusDidChange";

@implementation UserManager

+ (UserManager *)manager
{
    static UserManager * manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)setUser:(UserModel *)user
{
    if (_user != user) {
        _user = user;
        
        if (user) {
            _isUserLoginStatusEnable = YES;
        }else{
            _isUserLoginStatusEnable = NO;
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:RDUserLoginStatusDidChange object:nil];
    }
}

@end
