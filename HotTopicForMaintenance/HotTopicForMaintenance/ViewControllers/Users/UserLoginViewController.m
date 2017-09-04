//
//  UserLoginViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserLoginViewController.h"

@interface UserLoginViewController ()

@property (nonatomic, strong) UIView * loginView;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews
{
    self.loginView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.loginView];
    
    UILabel * versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    versionLabel.font = kPingFangRegular(16);
    versionLabel.textColor = UIColorFromRGB(0x333333);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = [@"v" stringByAppendingString:kSoftwareVersion];
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
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
