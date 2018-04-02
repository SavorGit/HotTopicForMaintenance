//
//  MBProgressHUD+Custom.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Custom)

+ (MBProgressHUD *)showLoadingHUDWithText:(NSString *)text inView:(UIView *)view;

+ (MBProgressHUD *)showLoadingHUDWithText:(NSString *)text buttonTitle:(NSString *)buttonTitle inView:(UIView *)view target:(id)target action:(SEL)action;

+ (MBProgressHUD *)showTextHUDWithText:(NSString *)text inView:(UIView *)view;

+ (MBProgressHUD *)showTextHUDWithText:(NSString *)text inView:(UIView *)view andFont:(NSUInteger)font;

@end
