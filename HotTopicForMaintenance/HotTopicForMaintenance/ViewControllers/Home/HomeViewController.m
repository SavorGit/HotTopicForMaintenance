//
//  HomeViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeViewController.h"
#import "UserManager.h"
#import "UserLoginViewController.h"
#import "HomeUserInfoView.h"
#import "HomeHotelInfoView.h"
#import "RepairRecordViewController.h"

@interface HomeViewController ()

@property (nonatomic, strong) HomeUserInfoView * userInfoView;
@property (nonatomic, strong) HomeHotelInfoView * hotelInfoView;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupDatas];
    
    [self isUserLogin];
}

//检测用户当前登录状态
- (void)isUserLogin
{
    if (![UserManager manager].isUserLoginStatusEnable) {
        UserLoginViewController * login = [[UserLoginViewController alloc] init];
        [self.navigationController presentViewController:login animated:YES completion:^{
            
        }];
    }
    [self.userInfoView reloadUserInfo];
}

//布局views
- (void)setupViews
{
    self.userInfoView = [[HomeUserInfoView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    self.hotelInfoView = [[HomeHotelInfoView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.hotelInfoView];
    [self.hotelInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.equalTo(self.userInfoView.mas_top).offset(-20);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(300);
    }];
    
    UILabel * searchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    searchLabel.font = kPingFangRegular(15);
    searchLabel.userInteractionEnabled = YES;
    searchLabel.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    searchLabel.layer.borderWidth = .5f;
    searchLabel.text = @" 搜索酒楼";
    searchLabel.textColor = UIColorFromRGB(0x666666);
    [self.view addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTextFieldDidBeClicked)];
    tap.numberOfTapsRequired = 1;
    [searchLabel addGestureRecognizer:tap];
    
    UIView * handleView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:handleView];
    [handleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(searchLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.hotelInfoView.mas_top);
    }];
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"weixiujilu"] forState:UIControlStateNormal];
    [leftButton setTitle:@"维修记录" forState:UIControlStateNormal];
    leftButton.titleLabel.font = kPingFangRegular(15);
    [leftButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15.5, 30, 0)];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(65, -50, 0, 0)];
    [handleView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 120));
        make.centerX.mas_equalTo(-kMainBoundsWidth /  5);
        make.centerY.mas_equalTo(0);
    }];
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"yichangbaogao"] forState:UIControlStateNormal];
    [rightButton setTitle:@"异常报告" forState:UIControlStateNormal];
    rightButton.titleLabel.font = kPingFangRegular(15);
    [rightButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15.5, 30, 0)];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(65, -50, 0, 0)];
    [handleView addSubview:rightButton];
    [leftButton addTarget:self action:@selector(rightButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 120));
        make.centerX.mas_equalTo(kMainBoundsWidth /  5);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)leftButtonDidBeClicked
{
    RepairRecordViewController * repair = [[RepairRecordViewController alloc] init];
    [self.navigationController pushViewController:repair animated:YES];
}

- (void)rightButtonDidBeClicked
{
    
}

- (void)searchTextFieldDidBeClicked
{
    NSLog(@"在这里添加搜索代码");
}

- (void)setupDatas
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isUserLogin) name:RDUserLoginStatusDidChange object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDUserLoginStatusDidChange object:nil];
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
