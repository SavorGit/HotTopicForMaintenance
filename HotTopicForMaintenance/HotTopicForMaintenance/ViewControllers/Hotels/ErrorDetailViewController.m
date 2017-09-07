//
//  ErrorDetailViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ErrorDetailViewController.h"
#import "ErrorDetailRequest.h"
#import "ErrorDetailTableViewCell.h"
#import "MJRefresh.h"
#import "HotTopicTools.h"
#import "RestaurantRankInforViewController.h"

@interface ErrorDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString * errorID;

@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) NSString * date;

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation ErrorDetailViewController

- (instancetype)initWithErrorID:(NSString *)errorID
{
    if (self = [super init]) {
        self.errorID = errorID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"异常详细信息";
    
    [self requestErrorDetail];
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.tableView registerClass:[ErrorDetailTableViewCell class] forCellReuseIdentifier:@"ErrordDetailCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMore)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, .1f)];
    
    [self createTableViewHeaderView];
}

- (void)createTableViewHeaderView
{
    CGFloat height = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 20 title:self.info font:kPingFangRegular(15)];
    height += 86;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, height)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.textColor = UIColorFromRGB(0x333333);
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.font = kPingFangMedium(15);
    detailLabel.text = @"详细信息";
    [headerView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-5);
        make.height.mas_equalTo(20);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = VCBackgroundColor;
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
        make.height.mas_equalTo(10);
    }];
    
    UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    dateLabel.textColor = UIColorFromRGB(0x333333);
    dateLabel.textAlignment = NSTextAlignmentRight;
    dateLabel.font = kPingFangRegular(14);
    dateLabel.text = self.date;
    [headerView addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(lineView.mas_top).offset(-5);
        make.height.mas_equalTo(20);
    }];
    
    UILabel * infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    infoLabel.textColor = UIColorFromRGB(0x333333);
    infoLabel.numberOfLines = 0;
    infoLabel.font = kPingFangRegular(15);
    infoLabel.text = self.info;
    [headerView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(dateLabel.mas_top).offset(-5);;
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ErrorDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ErrordDetailCell" forIndexPath:indexPath];
    
    ErrorDetailModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ErrorDetailModel * model = [self.dataSource objectAtIndex:indexPath.row];
    NSString * info = [NSString stringWithFormat:@"%@\n%@", model.small_palt_info, model.box_info];
    CGFloat height = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 50 title:info font:kPingFangRegular(14)];
    return 41 + height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ErrorDetailModel * model = [self.dataSource objectAtIndex:indexPath.row];
    RestaurantRankInforViewController * vc = [[RestaurantRankInforViewController alloc] initWithDetaiID:model.detail_id WithHotelNam:model.hotel_name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)getMore
{
    ErrorDetailModel * lastModel = [self.dataSource lastObject];
    if (lastModel) {
        NSString * detailID = lastModel.detail_id;
        
        [self requestWithDetailID:detailID success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            NSDictionary * dataDict = [response objectForKey:@"result"];
            if (dataDict) {
                NSDictionary * dataDict = [response objectForKey:@"result"];
                if ([dataDict objectForKey:@"list"]) {
                    NSArray * array = [dataDict objectForKey:@"list"];
                    if (array && array.count > 0) {
                        
                        for (NSInteger i = 0; i < array.count; i++) {
                            NSDictionary * dict = [array objectAtIndex:i];
                            ErrorDetailModel * model = [[ErrorDetailModel alloc] initWithDictionary:dict];
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

- (void)requestErrorDetail
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在获取异常详情" inView:self.view];
    
    [self requestWithDetailID:@"0" success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"result"]) {
            NSDictionary * dataDict = [response objectForKey:@"result"];
            
            self.info = [dataDict objectForKey:@"info"];
            self.date = [dataDict objectForKey:@"date"];
            
            if ([dataDict objectForKey:@"list"]) {
                NSArray * array = [dataDict objectForKey:@"list"];
                if (array && array.count > 0) {
                    
                    [self.dataSource removeAllObjects];
                    
                    for (NSInteger i = 0; i < array.count; i++) {
                        NSDictionary * dict = [array objectAtIndex:i];
                        ErrorDetailModel * model = [[ErrorDetailModel alloc] initWithDictionary:dict];
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

- (void)requestWithDetailID:(NSString *)detailID success:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock
{
    ErrorDetailRequest * request = [[ErrorDetailRequest alloc] initWithErrorID:self.errorID detailID:detailID pageSzie:@"15"];
    [request sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
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
