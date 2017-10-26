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
#import "RepairRecordViewController.h"
#import "SearchHotelViewController.h"
#import "ErrorReportViewController.h"
#import "ErrorDetailViewController.h"
#import "Helper.h"
#import "AutoEnableView.h"

@interface HomeViewController ()

@property (nonatomic, strong) HomeUserInfoView * userInfoView;
@property (nonatomic, strong) UIButton * cityButton;
@property (nonatomic, strong) UICollectionView * collectionView;

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
    }else{
        [self cheakUserNotification];
    }
    [self.userInfoView reloadUserInfo];
}

//布局views
- (void)setupViews
{
    self.navigationItem.leftBarButtonItem = nil;
    
    self.userInfoView = [[HomeUserInfoView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
//    self.hotelInfoView = [[HomeHotelInfoView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:self.hotelInfoView];
//    [self.hotelInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(10);
//        make.bottom.equalTo(self.userInfoView.mas_top).offset(-20);
//        make.right.mas_equalTo(-10);
//        make.height.mas_equalTo(kMainBoundsHeight / 2);
//    }];
    
    AutoEnableView * searchView = [[AutoEnableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 30 - 60 - 15, 30)];
    searchView.backgroundColor = UIColorFromRGB(0x00a8e0);
    searchView.layer.cornerRadius = 5.f;
    searchView.layer.masksToBounds = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchView];
    
    UIImageView * searchImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    searchImageView.contentMode = UIViewContentModeScaleAspectFit;
    [searchImageView setImage:[UIImage imageNamed:@"sousuo"]];
    [searchView addSubview:searchImageView];
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(18);
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(10);
    }];
    
    UILabel * searchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    searchLabel.font = kPingFangRegular(14);
    searchLabel.text = @"搜索酒楼";
    searchLabel.textColor = kNavTitleColor;
    [searchView addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(searchImageView.mas_right).offset(8);
        make.right.mas_equalTo(-20);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTextFieldDidBeClicked)];
    tap.numberOfTapsRequired = 1;
    [searchView addGestureRecognizer:tap];
    
    self.cityButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cityButton setFrame:CGRectMake(0, 0, 60, 30)];
    [self.cityButton setTitleColor:kNavTitleColor forState:UIControlStateNormal];
    self.cityButton.titleLabel.font = kPingFangMedium(16);
    [self.cityButton setTitle:@"北京" forState:UIControlStateNormal];
    [self.cityButton setImage:[UIImage imageNamed:@"ywsy_csxl"] forState:UIControlStateNormal];
    [self.cityButton setAdjustsImageWhenHighlighted:NO];
    [self.cityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -7, 0, 18)];
    [self.cityButton setImageEdgeInsets:UIEdgeInsetsMake(0, 44, 0, 0)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.cityButton];
    
//    UIView * handleView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.view addSubview:handleView];
//    [handleView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(self.hotelInfoView.mas_top);
//    }];
//
//    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftButton setImage:[UIImage imageNamed:@"weixiujilu"] forState:UIControlStateNormal];
//    [leftButton setTitle:@"维修记录" forState:UIControlStateNormal];
//    leftButton.titleLabel.font = kPingFangRegular(15);
//    [leftButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15.5, 30, 0)];
//    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(65, -68, 0, 0)];
//    [handleView addSubview:leftButton];
//    [leftButton addTarget:self action:@selector(leftButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
//    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(100, 120));
//        make.centerX.mas_equalTo(-kMainBoundsWidth /  5);
//        make.centerY.mas_equalTo(0);
//    }];
//
//    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setImage:[UIImage imageNamed:@"yichangbaogao"] forState:UIControlStateNormal];
//    [rightButton setTitle:@"异常报告" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = kPingFangRegular(15);
//    [rightButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//    [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 15.5, 30, 0)];
//    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(65, -68, 0, 0)];
//    [handleView addSubview:rightButton];
//    [rightButton addTarget:self action:@selector(rightButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(100, 120));
//        make.centerX.mas_equalTo(kMainBoundsWidth /  5);
//        make.centerY.mas_equalTo(0);
//    }];
    
    
}

- (void)leftButtonDidBeClicked
{
    RepairRecordViewController * repair = [[RepairRecordViewController alloc] init];
    [self.navigationController pushViewController:repair animated:YES];
}

- (void)rightButtonDidBeClicked
{
    ErrorReportViewController * error = [[ErrorReportViewController alloc] init];
    [self.navigationController pushViewController:error animated:YES];
}

- (void)searchTextFieldDidBeClicked
{
    SearchHotelViewController *shVC = [[SearchHotelViewController alloc] init];
    [self.navigationController pushViewController:shVC animated:YES];
}

- (void)setupDatas
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isUserLogin) name:RDUserLoginStatusDidChange object:nil];
}

- (void)cheakUserNotification
{
    if ([UserManager manager].notificationModel) {
        if (self.navigationController.topViewController == self) {
            NSString * errorID = [UserManager manager].notificationModel.error_id;
            ErrorDetailViewController * detail = [[ErrorDetailViewController alloc] initWithErrorID:errorID];
            [self.navigationController pushViewController:detail animated:YES];
            [UserManager manager].notificationModel = nil;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
