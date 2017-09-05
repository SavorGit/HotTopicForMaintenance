//
//  HotTopicTools.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HotTopicTools.h"
#import "BGNetWorkManager.h"
#import "NetworkConfiguration.h"
#import "UserManager.h"
#import "GetAllUserRequest.h"

@implementation HotTopicTools

+ (void)configApplication
{
    [[BGNetworkManager sharedManager] setNetworkConfiguration:[NetworkConfiguration configuration]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:UserInfoCachePath]) {
        NSDictionary * userInfo = [NSDictionary dictionaryWithContentsOfFile:UserInfoCachePath];
        [UserManager manager].user = [[UserModel alloc] initWithDictionary:userInfo];
    }
}

+ (void)saveFileOnPath:(NSString *)path withArray:(NSArray *)array
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:FileCachePath]) {
        [manager createDirectoryAtPath:FileCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
    BOOL temp = [array writeToFile:path atomically:YES];
    if (temp) {
        NSLog(@"缓存成功");
    }else{
        NSLog(@"缓存失败");
    }
}

+ (void)saveFileOnPath:(NSString *)path withDictionary:(NSDictionary *)dict
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:FileCachePath]) {
        [manager createDirectoryAtPath:FileCachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
    BOOL temp = [dict writeToFile:path atomically:YES];
    if (temp) {
        NSLog(@"缓存成功");
    }else{
        NSLog(@"缓存失败");
    }
}

+ (void)removeFileOnPath:(NSString *)path
{
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        [manager removeItemAtPath:path error:nil];
    }
}

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

@end
