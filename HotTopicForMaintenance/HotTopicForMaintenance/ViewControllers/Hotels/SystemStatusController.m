//
//  SystemStatusController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SystemStatusController.h"
#import "SystemStatusHeaderView.h"
#import "SystemStatusSectionHeaderView.h"
#import "SystemStatusHotelCell.h"
#import "SystemStatusBoxCell.h"
#import <MJRefresh/MJRefreshNormalHeader.h>
#import "GetSystemStatusRequest.h"

@interface SystemStatusController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString * cityID;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) SystemStatusHeaderView * tableHeaderView;

@property (nonatomic, strong) NSDictionary * dataDict;

@end

@implementation SystemStatusController

- (instancetype)initWithCityID:(NSString *)cityID
{
    if (self = [super init]) {
        self.cityID = cityID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubViews];
    [self setupDatas];
}

- (void)setupSubViews
{
    self.dataDict = [NSDictionary new];
    self.tableHeaderView = [[SystemStatusHeaderView alloc] initWithFrame:CGRectZero];
    self.tableView.tableHeaderView = self.tableHeaderView;
}

- (void)setupDatas
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    GetSystemStatusRequest * request = [[GetSystemStatusRequest alloc] initWithCityID:self.cityID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary * list = [result objectForKey:@"list"];
            if ([list isKindOfClass:[NSDictionary class]]) {
                self.dataDict = list;
                [self reloadStatusController];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"网络连接失败" inView:self.view];
        
    }];
}

- (void)reloadStatusController
{
    __weak typeof(self) weakSelf = self;
    [self.tableHeaderView configWithDict:[self.dataDict objectForKey:@"heart"] reCheckHandle:^{
        [weakSelf setupDatas];
    }];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        NSDictionary * hotelInfo = [self.dataDict objectForKey:@"hotel"];
        if ([hotelInfo isKindOfClass:[NSDictionary class]]) {
            NSArray * list = [hotelInfo objectForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                return list.count;
            }
        }
        return 0;
    }else if (section == 2) {
        NSDictionary * boxInfo = [self.dataDict objectForKey:@"box"];
        if ([boxInfo isKindOfClass:[NSDictionary class]]) {
            NSArray * list = [boxInfo objectForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                return list.count;
            }
        }
        return 0;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SystemStatusHotelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SystemStatusHotelCell" forIndexPath:indexPath];
        
        NSDictionary * hotel = [self.dataDict objectForKey:@"hotel"];
        if ([hotel isKindOfClass:[NSDictionary class]]) {
            NSDictionary * list = [[hotel objectForKey:@"list"] objectAtIndex:indexPath.row];
            if ([list isKindOfClass:[NSDictionary class]]) {
                [cell configWithDict:list];
            }
        }
        
        return cell;
    }else if (indexPath.section == 2) {
        SystemStatusBoxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SystemStatusBoxCell" forIndexPath:indexPath];
        
        NSDictionary * box = [self.dataDict objectForKey:@"box"];
        if ([box isKindOfClass:[NSDictionary class]]) {
            NSDictionary * list = [[box objectForKey:@"list"] objectAtIndex:indexPath.row];
            if ([list isKindOfClass:[NSDictionary class]]) {
                [cell configWithDict:list];
            }
        }
        
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SystemStatusCell"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            return 90 * scale;
        }
        return 70 * scale;
    }else if (indexPath.section == 2){
        if (indexPath.row == 3) {
            return 90 * scale;
        }
        return 70 * scale;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SystemStatusSectionHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SystemStatusSectionHeaderView"];
    
    SystemStatusType type;
    NSDictionary * info;
    if (section == 0) {
        
        type = SystemStatusType_Hotel;
        info = [self.dataDict objectForKey:@"hotel"];
        
    }else if (section == 1) {
        
        type = SystemStatusType_Platform;
        info = [self.dataDict objectForKey:@"small"];
        
    }else{
        
        type = SystemStatusType_Box;
        info = [self.dataDict objectForKey:@"box"];
        
    }
    
    [headerView configWithType:type info:info];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 53 * kMainBoundsWidth / 375.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10 * kMainBoundsWidth / 375.f;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        CGFloat scale = kMainBoundsWidth / 375.f;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SystemStatusHotelCell class] forCellReuseIdentifier:@"SystemStatusHotelCell"];
        [_tableView registerClass:[SystemStatusBoxCell class] forCellReuseIdentifier:@"SystemStatusBoxCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SystemStatusCell"];
        [_tableView registerClass:[SystemStatusSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"SystemStatusSectionHeaderView"];
        _tableView.contentInset = UIEdgeInsetsMake(10 * scale, 0, 10 * scale, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _tableView;
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
