//
//  HotTopicTools.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotTopicTools : NSObject

+ (void)configApplication;

+ (void)saveFileOnPath:(NSString *)path withArray:(NSArray *)array;

+ (void)saveFileOnPath:(NSString *)path withDictionary:(NSDictionary *)dict;

+ (void)removeFileOnPath:(NSString *)path;

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font;

@end
