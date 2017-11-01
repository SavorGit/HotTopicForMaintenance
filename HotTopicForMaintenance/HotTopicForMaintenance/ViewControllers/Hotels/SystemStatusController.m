//
//  SystemStatusController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SystemStatusController.h"
#import "HomeHotelInfoView.h"

@interface SystemStatusController ()

@end

@implementation SystemStatusController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"系统状态";
    
    HomeHotelInfoView * info = [[HomeHotelInfoView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:info];
    [info mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-40);
        make.right.mas_equalTo(-15);
    }];
    
    UIButton * refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    refreshButton.frame = CGRectMake(0, 0, 40, 30);
    [refreshButton addTarget:info action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
