//
//  MyInspectViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/1/23.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "MyInspectViewController.h"
#import "MySepectRequest.h"
#import "MyInspectTableViewCell.h"
#import "MJRefresh.h"
#import "HotTopicTools.h"
#import "MyInspectModel.h"
#import "RestaurantRankInforViewController.h"
#import "UserManager.h"


@interface MyInspectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger pageNum;

@end

@implementation MyInspectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的巡检";
    self.pageNum = 1;
    
    [self getErrorReportList];
    
    // Do any additional setup after loading the view.
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.tableView registerClass:[MyInspectTableViewCell class] forCellReuseIdentifier:@"myInseptCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMore)];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 10.f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, .1f)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInspectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myInseptCell" forIndexPath:indexPath];
    
    MyInspectModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInspectModel * model = [self.dataSource objectAtIndex:indexPath.row];
    NSString * info = [NSString stringWithFormat:@"%@\n%@", model.small_palt_info, model.box_info];
    CGFloat height = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 50 title:info font:kPingFangRegular(14)];
    return 41 + height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInspectModel * model = [self.dataSource objectAtIndex:indexPath.row];
    RestaurantRankInforViewController * vc = [[RestaurantRankInforViewController alloc] initWithDetaiID:model.hotel_id WithHotelNam:model.hotel_name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getErrorReportList
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在获取巡检信息" inView:self.view];
    
    [self requestWithID:[UserManager manager].user.userid success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"result"]) {
            NSDictionary * dataDict = [response objectForKey:@"result"];
            if ([dataDict objectForKey:@"list"]) {
                NSArray * array = [dataDict objectForKey:@"list"];
                if (array && array.count > 0) {
                    
                    [self.dataSource removeAllObjects];
                    NSString *count = [dataDict objectForKey:@"count"];
                    for (NSInteger i = 0; i < array.count; i++) {
                        NSDictionary * dict = [array objectAtIndex:i];
                        MyInspectModel * model = [[MyInspectModel alloc] initWithDictionary:dict];
                        model.count = count;
                        [self.dataSource addObject:model];
                    }
                    
                    [self createTableView];
                    
                    BOOL isNextPage = [[dataDict objectForKey:@"isNextPage"] boolValue];
                    if (!isNextPage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }
                }
            }
        }
        
        if (self.dataSource.count == 0) {
            [MBProgressHUD showTextHUDWithText:@"暂无巡检记录" inView:self.view];
        }
        
        [hud hideAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"获取失败，网络出现问题了~" inView:self.view];
        
    }];
}

- (void)refreshData
{
    self.pageNum = 1;
    [self requestWithID:[UserManager manager].user.userid success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"result"]) {
            NSDictionary * dataDict = [response objectForKey:@"result"];
            if ([dataDict objectForKey:@"list"]) {
                NSArray * array = [dataDict objectForKey:@"list"];
                if (array && array.count > 0) {
                    
                    [self.dataSource removeAllObjects];
                    
                    for (NSInteger i = 0; i < array.count; i++) {
                        NSDictionary * dict = [array objectAtIndex:i];
                        MyInspectModel * model = [[MyInspectModel alloc] initWithDictionary:dict];
                        [self.dataSource addObject:model];
                    }
                    
                    [self.tableView reloadData];
                    
                    BOOL isNextPage = [[dataDict objectForKey:@"isNextPage"] boolValue];
                    if (!isNextPage) {
                        [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    }else{
                        [self.tableView.mj_footer resetNoMoreData];
                    }
                }
            }
        }
        
        if (self.dataSource.count == 0) {
            [MBProgressHUD showTextHUDWithText:@"暂无异常报告" inView:self.view];
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"刷新失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"刷新失败" inView:self.view];
        
    }];
}

- (void)getMore
{
    self.pageNum ++;
    [self requestWithID:[UserManager manager].user.userid success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        if (dataDict) {
            NSDictionary * dataDict = [response objectForKey:@"result"];
            if ([dataDict objectForKey:@"list"]) {
                NSArray * array = [dataDict objectForKey:@"list"];
                if (array && array.count > 0) {
                    
                    for (NSInteger i = 0; i < array.count; i++) {
                        NSDictionary * dict = [array objectAtIndex:i];
                        MyInspectModel * model = [[MyInspectModel alloc] initWithDictionary:dict];
                        [self.dataSource addObject:model];
                    }
                    
                    [self.tableView reloadData];
                }
            }
        }
        
        BOOL isNextPage = [[dataDict objectForKey:@"isNextPage"] boolValue];
        if (isNextPage) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            self.pageNum --;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        self.pageNum --;
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        self.pageNum --;
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        
    }];
}

- (void)requestWithID:(NSString *)errorID success:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock
{
    MySepectRequest * request = [[MySepectRequest alloc] initWithID:errorID pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20"];
    [request sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
}

- (void)dealloc
{
    [MySepectRequest cancelRequest];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
