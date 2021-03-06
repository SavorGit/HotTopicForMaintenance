//
//  BaseViewController.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+Custom.h"

@interface BaseViewController : UIViewController

/**
 *  @brief 初始化View
 */
-(void)setupViews;
/**
 *  @brief 初始化Data
 */
-(void)setupDatas;

- (void)navBackButtonClicked:(UIButton *)sender;

@end
