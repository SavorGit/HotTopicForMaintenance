//
//  BoxInfoViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "BoxInfoViewController.h"
#import "BoxInfoTableHeaderView.h"
#import "BoxInfoPlayCell.h"
#import "HotTopicTools.h"
#import "DownLoadListViewController.h"
#import "CheckResultView.h"
#import "GetBoxInfoRequest.h"
#import "OneKeyCheckRequest.h"
#import <MJRefresh/MJRefreshNormalHeader.h>
#import "GetDownLoadMediaRequest.h"
#import "GetDownLoadADRequest.h"
#import "GetPubProgramRequest.h"

@interface BoxInfoViewController ()<UITableViewDelegate, UITableViewDataSource, BoxInfoTableHeaderViewDelegate>

@property (nonatomic, copy) NSString * boxID;
@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) BoxInfoTableHeaderView * tableHeaderView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSDictionary * dataDict;
@property (nonatomic, strong) NSArray * dataSource;

@end

@implementation BoxInfoViewController

- (instancetype)initWithBoxID:(NSString *)boxID title:(NSString *)title
{
    if (self = [super init]) {
        self.boxID = boxID;
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
    [self setupDatas];
}

- (void)setupSubViews
{
    self.tableHeaderView = [[BoxInfoTableHeaderView alloc] initWithFrame:CGRectZero];
    self.tableHeaderView.delegate = self;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupDatas)];
}

- (void)setupDatas
{
    GetBoxInfoRequest * request = [[GetBoxInfoRequest alloc] initWithBoxID:self.boxID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.dataDict = result;
            
            NSArray * program_list = [result objectForKey:@"program_list"];
            if ([program_list isKindOfClass:[NSArray class]]) {
                self.dataSource = program_list;
            }else{
                self.dataSource = [NSArray new];
            }
        }
        [self reloadBoxData];
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"版位信息错误" inView:self.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"网络失去连接" inView:self.view];
        
    }];
}

- (void)reloadBoxData
{
    [self.tableHeaderView configWithDict:self.dataDict];
    [self.tableView reloadData];
}

- (void)testButtonDidClicked
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"检测中..." inView:self.view];
    
    OneKeyCheckRequest * request = [[OneKeyCheckRequest alloc] initWithBoxID:self.boxID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            __weak typeof(self) weakSelf = self;
            CheckResultView * resultView = [[CheckResultView alloc] initWithResult:result reCheckHandle:^{
                [weakSelf testButtonDidClicked];
            }];
            [resultView show];
        }else{
            [MBProgressHUD showTextHUDWithText:@"配置信息错误" inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"检测失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络连接失败" inView:self.view];
        
    }];
}

- (void)mediaDownLoadButtonDidClicked
{
    NSString * proID = [self.dataDict objectForKey:@"pro_download_period"];
    if (isEmptyString(proID)) {
        [MBProgressHUD showTextHUDWithText:@"没有正在下载的节目" inView:self.view];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    GetDownLoadMediaRequest * request = [[GetDownLoadMediaRequest alloc] initWithMediaProID:proID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSArray * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSArray class]]) {
            DownLoadListViewController * list = [[DownLoadListViewController alloc] initWithDataSource:result];
            [list configType:DownLoadListType_Media mediaDate:proID adDate:nil];
            [self.navigationController pushViewController:list animated:YES];
        }else{
            [MBProgressHUD showTextHUDWithText:@"内容信息为空" inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络连接失败" inView:self.view];
        
    }];
}

- (void)adDownLoadButtonDidClicked
{
    NSString * ADID = [self.dataDict objectForKey:@"ads_download_period"];
    if (isEmptyString(ADID)) {
        [MBProgressHUD showTextHUDWithText:@"没有正在下载的广告" inView:self.view];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    GetDownLoadADRequest * request = [[GetDownLoadADRequest alloc] initWithMediaADID:ADID boxID:self.boxID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSArray * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSArray class]]) {
            DownLoadListViewController * list = [[DownLoadListViewController alloc] initWithDataSource:result];
            [list configType:DownLoadListType_ADs mediaDate:nil adDate:ADID];
            [self.navigationController pushViewController:list animated:YES];
        }else{
            [MBProgressHUD showTextHUDWithText:@"内容信息为空" inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络连接失败" inView:self.view];
        
    }];
}

- (void)pushListButtonDidClicked
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    GetPubProgramRequest * request = [[GetPubProgramRequest alloc] initWithBoxID:self.boxID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSArray * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSArray class]]) {
            NSString * proID = [self.dataDict objectForKey:@"pro_period"];
            NSString * ADID = [self.dataDict objectForKey:@"ads_period"];
            DownLoadListViewController * list = [[DownLoadListViewController alloc] initWithDataSource:result];
            [list configType:DownLoadListType_PubProgram mediaDate:proID adDate:ADID];
            [self.navigationController pushViewController:list animated:YES];
        }else{
            [MBProgressHUD showTextHUDWithText:@"内容信息为空" inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络连接失败" inView:self.view];
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxInfoPlayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BoxInfoPlayCell" forIndexPath:indexPath];
    
    NSDictionary * dict = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithDict:dict];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38 * kMainBoundsWidth / 375.f;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        CGFloat scale = kMainBoundsWidth / 375.f;
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = UIColorFromRGB(0xffffff);
        [self.view addSubview:_bottomView];
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(115.f / 2.f * scale);
        }];
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = UIColorFromRGB(0x666666);
        [_bottomView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(.5 * scale);
        }];
        
        UIButton * repairButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16 * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"维修" cornerRadius:5 * scale];
        [_bottomView addSubview:repairButton];
        [repairButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(225 * scale);
            make.height.mas_equalTo(44 * scale);
        }];
    }
    return _bottomView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[BoxInfoPlayCell class] forCellReuseIdentifier:@"BoxInfoPlayCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.bottomView.mas_top);
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
