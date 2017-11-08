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
#import "Helper.h"
#import "AutoEnableView.h"

#import "HomeBadgeCollectionViewCell.h"

#import "RepairRecordViewController.h"
#import "SearchHotelViewController.h"
#import "ErrorReportViewController.h"
#import "ErrorDetailViewController.h"
#import "TaskChooseTypeController.h"
#import "TaskPageViewController.h"
#import "SystemStatusController.h"
#import "BindingPositionViewController.h"
#import "UserCityViewController.h"
#import "BaseNavigationController.h"
#import "GetTaskCountRequest.h"

@interface HomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) HomeUserInfoView * userInfoView;
@property (nonatomic, strong) UIButton * cityButton;
@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) HomeBadgeCollectionViewCell * badgeCell;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupDatas];
    
    UserLoginViewController * login = [[UserLoginViewController alloc] init];
    [self presentViewController:login animated:YES completion:^{
        
    }];
}

//检测用户当前登录状态
- (void)isUserLogin
{
    if (![UserManager manager].isUserLoginStatusEnable) {
        UserLoginViewController * login = [[UserLoginViewController alloc] init];
        [self presentViewController:login animated:YES completion:^{
            
        }];
    }else{
        [self cheakUserNotification];
    }
    [self.userInfoView reloadUserInfo];
    
    MenuModel * createModel = [[MenuModel alloc] initWithMenuType:MenuModelType_CreateTask];
    MenuModel * tasklistModel = [[MenuModel alloc] initWithMenuType:MenuModelType_TaskList];
    MenuModel * repairModel = [[MenuModel alloc] initWithMenuType:MenuModelType_RepairRecord];
    MenuModel * reportModel = [[MenuModel alloc] initWithMenuType:MenuModelType_ErrorReport];
    MenuModel * systemModel = [[MenuModel alloc] initWithMenuType:MenuModelType_SystemStatus];
    MenuModel * bindDeviceModel = [[MenuModel alloc] initWithMenuType:MenuModelType_BindDevice];
    MenuModel * myTaskModel = [[MenuModel alloc] initWithMenuType:MenuModelType_MyTask];
    
    self.badgeCell = nil;
    [self.dataSource removeAllObjects];
    switch ([UserManager manager].user.roletype) {
        case UserRoleType_CreateTask:
            
        {
            [self.dataSource addObjectsFromArray:@[createModel, tasklistModel, systemModel, reportModel, repairModel]];
        }
            
            break;
            
        case UserRoleType_AssignTask:
            
        {
            [self.dataSource addObjectsFromArray:@[tasklistModel, systemModel, reportModel, repairModel]];
        }
            
            break;
            
        case UserRoleType_HandleTask:
            
        {
            [self.dataSource addObjectsFromArray:@[myTaskModel, systemModel, reportModel, repairModel, bindDeviceModel]];
        }
            
            break;
            
        case UserRoleType_LookTask:
            
        {
            [self.dataSource addObjectsFromArray:@[tasklistModel, systemModel, reportModel, repairModel]];
        }
            
            break;
            
        default:
            break;
    }
    
    if (self.dataSource.count % 2 != 0) {
        [self.dataSource addObject:[[MenuModel alloc] initWithMenuType:MenuModelType_Space]];
    }
    
    [self.collectionView reloadData];
    [self autoCollectionViewSize];
    
    [self configCityName];
}

- (void)configCityName
{
    NSString * cityName = [UserManager manager].user.currentCity.region_name;
    
    cityName = [cityName stringByReplacingOccurrencesOfString:@"市" withString:@""];
    
    if (cityName.length == 3) {
        self.cityButton.titleLabel.font = kPingFangMedium(12);
    }else{
        self.cityButton.titleLabel.font = kPingFangMedium(16);
    }
    [self.cityButton setTitle:cityName forState:UIControlStateNormal];
}

//布局views
- (void)setupViews
{
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.navigationItem.leftBarButtonItem = nil;
    
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
    [self.cityButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 18)];
    [self.cityButton setImageEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    [self.cityButton addTarget:self action:@selector(cityButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
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
    
    //collectionView
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    layout.itemSize = CGSizeMake(kMainBoundsWidth / 2 - .5f, kMainBoundsWidth / 2 / 374 * 320);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight) collectionViewLayout:layout];
    [self.collectionView registerClass:[HomeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self.collectionView registerClass:[HomeBadgeCollectionViewCell class] forCellWithReuseIdentifier:@"HomeBadgeCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = UIColorFromRGB(0xeaeaea);
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kMainBoundsHeight - kStatusBarHeight - kNaviBarHeight - 50);
    }];
    
    self.userInfoView = [[HomeUserInfoView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.userInfoView];
    [self.userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}

- (void)cityButtonDidClicked
{
    if ([UserManager manager].user.cityArray.count >= 2) {
        UserCityViewController * vc = [[UserCityViewController alloc] init];
        BaseNavigationController * na = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:na animated:YES completion:^{
            
        }];
    }else{
        [MBProgressHUD showTextHUDWithText:@"您只拥有本城市权限" inView:self.view];
    }
}

- (void)autoCollectionViewSize
{
    if (self.dataSource.count == 0) {
        return;
    }
    
    NSInteger numberLines;
    if (self.dataSource.count % 2 == 0) {
        numberLines = self.dataSource.count / 2;
    }else{
        numberLines = self.dataSource.count / 2 + 1;
    }
    CGFloat totalHeight = (kMainBoundsWidth / 2 / 374 * 320 + 1.f) * numberLines - 1;
    CGFloat maxHeight = kMainBoundsHeight - kStatusBarHeight - kNaviBarHeight - 50;
    self.collectionView.bounces = YES;
    if (totalHeight > maxHeight) {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(maxHeight);
        }];
        self.collectionView.bounces = YES;
    }else{
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(totalHeight);
        }];
        self.collectionView.bounces = NO;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (model.type == MenuModelType_TaskList || model.type == MenuModelType_MyTask) {
        HomeBadgeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeBadgeCollectionViewCell" forIndexPath:indexPath];
        [cell configWithModel:model];
        self.badgeCell = cell;
        [self requestTaskCount];
        
        return cell;
    }else{
        HomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
        [cell configWithModel:model];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuModel * model = [self.dataSource objectAtIndex:indexPath.row];
    switch (model.type) {
        case MenuModelType_CreateTask:
        {
            TaskChooseTypeController * vc = [[TaskChooseTypeController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case MenuModelType_TaskList:
        {
            TaskPageViewController * vc = [[TaskPageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case MenuModelType_MyTask:
        {
            TaskPageViewController * vc = [[TaskPageViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case MenuModelType_ErrorReport:
        {
            ErrorReportViewController * vc = [[ErrorReportViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case MenuModelType_RepairRecord:
        {
            RepairRecordViewController * vc = [[RepairRecordViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case MenuModelType_SystemStatus:
        {
            SystemStatusController * vc = [[SystemStatusController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
         case MenuModelType_BindDevice:
        {
            BindingPositionViewController * vc = [[BindingPositionViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configCityName) name:RDUserCityDidChangeNotification object:nil];
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

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestTaskCount];
}

- (void)requestTaskCount
{
    GetTaskCountRequest * request = [[GetTaskCountRequest alloc] initWithAreaID:[UserManager manager].user.currentCity.cid userID:[UserManager manager].user.userid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            if (self.badgeCell) {
                [self.badgeCell setBadgeNumber:[[result objectForKey:@"nums"] integerValue]];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDUserLoginStatusDidChange object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDUserCityDidChangeNotification object:nil];
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
