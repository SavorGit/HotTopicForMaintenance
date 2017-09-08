//
//  ErrorReportViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ErrorReportViewController.h"
#import "ErrorReportRequest.h"
#import "ErrorReportTableViewCell.h"
#import "MJRefresh.h"
#import "HotTopicTools.h"
#import "ErrorDetailViewController.h"

@interface ErrorReportViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ErrorReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"异常报告";
    
    [self getErrorReportList];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.tableView registerClass:[ErrorReportTableViewCell class] forCellReuseIdentifier:@"ErrorReportCell"];
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
    ErrorReportTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ErrorReportCell" forIndexPath:indexPath];
    
    ErrorReportModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ErrorReportModel * model = [self.dataSource objectAtIndex:indexPath.row];
    CGFloat height = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 50 title:model.info font:kPingFangRegular(14)];
    return 41 + height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ErrorReportModel * model = [self.dataSource objectAtIndex:indexPath.row];
    ErrorDetailViewController * detail = [[ErrorDetailViewController alloc] initWithErrorID:model.cid];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)getErrorReportList
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在获取异常报告" inView:self.view];
    
    [self requestWithID:@"0" success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"result"]) {
            NSDictionary * dataDict = [response objectForKey:@"result"];
            if ([dataDict objectForKey:@"list"]) {
                NSArray * array = [dataDict objectForKey:@"list"];
                if (array && array.count > 0) {
                    
                    [self.dataSource removeAllObjects];
                    
                    for (NSInteger i = 0; i < array.count; i++) {
                        NSDictionary * dict = [array objectAtIndex:i];
                        ErrorReportModel * model = [[ErrorReportModel alloc] initWithDictionary:dict];
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
            [MBProgressHUD showTextHUDWithText:@"暂无异常报告" inView:self.view];
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
    [self requestWithID:0 success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"result"]) {
            NSDictionary * dataDict = [response objectForKey:@"result"];
            if ([dataDict objectForKey:@"list"]) {
                NSArray * array = [dataDict objectForKey:@"list"];
                if (array && array.count > 0) {
                    
                    [self.dataSource removeAllObjects];
                    
                    for (NSInteger i = 0; i < array.count; i++) {
                        NSDictionary * dict = [array objectAtIndex:i];
                        ErrorReportModel * model = [[ErrorReportModel alloc] initWithDictionary:dict];
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
    ErrorReportModel * lastModel = [self.dataSource lastObject];
    if (lastModel) {
        NSString * errorID = lastModel.cid;
        
        [self requestWithID:errorID success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            NSDictionary * dataDict = [response objectForKey:@"result"];
            if (dataDict) {
                NSDictionary * dataDict = [response objectForKey:@"result"];
                if ([dataDict objectForKey:@"list"]) {
                    NSArray * array = [dataDict objectForKey:@"list"];
                    if (array && array.count > 0) {
                        
                        for (NSInteger i = 0; i < array.count; i++) {
                            NSDictionary * dict = [array objectAtIndex:i];
                            ErrorReportModel * model = [[ErrorReportModel alloc] initWithDictionary:dict];
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
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [self.tableView.mj_footer endRefreshing];
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
            
        }];
        
    }else{
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestWithID:(NSString *)errorID success:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock
{
    ErrorReportRequest * request = [[ErrorReportRequest alloc] initWithID:errorID pageSize:@"15"];
    [request sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
}

- (void)dealloc
{
    [ErrorReportRequest cancelRequest];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
