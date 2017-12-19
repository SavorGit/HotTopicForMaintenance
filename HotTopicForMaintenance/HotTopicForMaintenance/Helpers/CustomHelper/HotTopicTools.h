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

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font lineModel:(NSLineBreakMode)model;

+ (UILabel *)labelWithFrame:(CGRect)frame TextColor:(UIColor *)textColor font:(UIFont *)font alignment:(NSTextAlignment)Alignment;

+ (UIButton *)buttonWithTitleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor title:(NSString *)title;

+ (UIButton *)buttonWithTitleColor:(UIColor *)titleColor font:(UIFont *)font backgroundColor:(UIColor *)backgroundColor title:(NSString *)title cornerRadius:(CGFloat)cornerRadius;

+ (void)callPhoneByNumber:(NSString *)num;

+ (void)checkUpdate;

+ (void)uploadImage:(UIImage *)image withBoxID:(NSString *)boxID progress:(void (^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))progress success:(void (^)(NSString *path))successBlock failure:(void (^)(NSError *error))failureBlock;

+ (void)uploadImageArray:(NSArray<UIImage *> *)images withBoxIDArray:(NSArray *)boxIDArray progress:(void (^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))progress success:(void (^)(NSString *path , NSInteger index))successBlock failure:(void (^)(NSError *error, NSInteger index))failureBlock;

+ (void)uploadImage:(UIImage *)image withHotelID:(NSString *)hotelID progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *))successBlock failure:(void (^)(NSError *))failureBlock;

+ (void)uploadImage:(UIImage *)image withImageName:(NSString *)name progress:(void (^)(int64_t, int64_t, int64_t))progress success:(void (^)(NSString *))successBlock failure:(void (^)(NSError *))failureBlock;

+ (void)uploadImageArray:(NSArray<UIImage *> *)images withHotelIDArray:(NSArray *)hotelIDArray progress:(void (^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))progress success:(void (^)(NSString *path , NSInteger index))successBlock failure:(void (^)(NSError *error, NSInteger index))failureBlock;

@end
