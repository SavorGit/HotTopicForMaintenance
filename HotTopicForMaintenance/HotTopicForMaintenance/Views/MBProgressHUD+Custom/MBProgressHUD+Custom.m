//
//  MBProgressHUD+Custom.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "MBProgressHUD+Custom.h"

@implementation MBProgressHUD (Custom)

+ (MBProgressHUD *)showLoadingHUDWithText:(NSString *)text inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    
    return hud;
}

+ (MBProgressHUD *)showLoadingHUDWithText:(NSString *)text buttonTitle:(NSString *)buttonTitle inView:(UIView *)view target:(id)target action:(SEL)action
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    
    [hud.button setTitle:buttonTitle forState:UIControlStateNormal];
    hud.button.titleLabel.font = kPingFangMedium(14);
    [hud.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return hud;
}

+ (MBProgressHUD *)showTextHUDWithText:(NSString *)text inView:(UIView *)view andFont:(NSUInteger)font
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:font];
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 0.f);
    
    [hud hideAnimated:YES afterDelay:1.f];
    return hud;
}

+ (MBProgressHUD *)showTextHUDWithText:(NSString *)text inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];

    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    // Move to bottm center.
    hud.offset = CGPointMake(0.f, 0.f);

    [hud hideAnimated:YES afterDelay:1.f];
    return hud;
}

@end
