//
//  UserModel.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserModel.h"

NSString * const RDUserCityDidChangeNotification = @"RDUserCityDidChangeNotification";

@implementation UserModel

- (NSMutableArray<CityModel *> *)cityArray
{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}

- (NSMutableArray<SkillModel *> *)skillArray
{
    if (!_skillArray) {
        _skillArray = [[NSMutableArray alloc] init];
    }
    return _skillArray;
}

@end
