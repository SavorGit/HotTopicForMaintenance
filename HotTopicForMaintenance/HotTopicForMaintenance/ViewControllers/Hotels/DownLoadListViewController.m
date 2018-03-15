//
//  DownLoadListViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/18.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "DownLoadListViewController.h"
#import "BoxInfoPlayCell.h"
#import "GetDownLoadADRequest.h"
#import "GetDownLoadMediaRequest.h"
#import <MJRefresh/MJRefreshNormalHeader.h>

@interface DownLoadListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) NSDictionary * dataSource;

@property (nonatomic, strong) UILabel * progressLabel;

@property (nonatomic, copy) NSString * titleText;

@property (nonatomic, assign) DownLoadListType type;

@property (nonatomic, copy) NSString * boxID;
@property (nonatomic, strong) NSArray * listSource;
@property (nonatomic, strong) NSDictionary * dataDict;

@end

@implementation DownLoadListViewController

- (instancetype)initWithDataSource:(NSDictionary *)dataSource boxID:(NSString *)boxID dataDict:(NSDictionary *)dataDict type:(DownLoadListType)type
{
    if (self = [super init]) {
        self.dataSource = dataSource;
        self.boxID = boxID;
        self.dataDict = dataDict;
        self.type = type;
        
        if (type == DownLoadListType_ADs || type == DownLoadListType_Media) {
            NSArray * list = [dataSource objectForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                self.listSource = list;
            }
        }else if (type == DownLoadListType_PubProgram) {
            NSArray * list = [dataSource objectForKey:@"program_list"];
            if ([list isKindOfClass:[NSArray class]]) {
                self.listSource = list;
            }
        }
        
    }
    return self;
}

- (void)configMediaDate:(NSString *)mediaDate adDate:(NSString *)adDate
{
    if (self.type == DownLoadListType_Media) {
        self.navigationItem.title = @"节目下载列表";
//        self.titleText = [NSString stringWithFormat:@"下载节目期号：%@", GetNoNullString(mediaDate)];
    }else if (self.type == DownLoadListType_ADs) {
        self.navigationItem.title = @"广告下载列表";
//        self.titleText = [NSString stringWithFormat:@"下载广告期号：%@", GetNoNullString(adDate)];
    }else if (self.type == DownLoadListType_PubProgram) {
        self.navigationItem.title = @"发布的节目单";
        self.titleText = [NSString stringWithFormat:@"发布节目期号：%@\n发布广告期号：%@", GetNoNullString(mediaDate), GetNoNullString(adDate)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 65 * scale)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 54.f * scale, kMainBoundsWidth, .5f)];
    
    if (self.type == DownLoadListType_PubProgram) {
        headerView.frame = CGRectMake(0, 0, kMainBoundsWidth, 81 * scale);
        lineView.frame = CGRectMake(0, 70.f * scale, kMainBoundsWidth, .5f);
    }else if (self.type == DownLoadListType_ADs) {
        [headerView addSubview:self.progressLabel];
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15 * scale);
            make.width.mas_equalTo(75 * scale);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(16 * scale);
        }];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupADDatas)];
        
        NSString * period = [self.dataSource objectForKey:@"period"];
        self.titleText = [NSString stringWithFormat:@"下载广告期号：%@", GetNoNullString(period)];
        self.progressLabel.text = [NSString stringWithFormat:@"下载中:%@", [self.dataSource objectForKey:@"download_percent"]];
        
    }else if (self.type == DownLoadListType_Media) {
        [headerView addSubview:self.progressLabel];
        [self.progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15 * scale);
            make.width.mas_equalTo(75 * scale);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo(16 * scale);
        }];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupMediaDatas)];
        
        NSString * period = [self.dataSource objectForKey:@"period"];
        self.titleText = [NSString stringWithFormat:@"下载节目期号：%@", GetNoNullString(period)];
        
        self.progressLabel.text = [NSString stringWithFormat:@"下载中:%@", [self.dataSource objectForKey:@"download_percent"]];
        
    }
    
    lineView.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [headerView addSubview:lineView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = kPingFangMedium(15 * scale);
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.text = self.titleText;
    self.titleLabel.numberOfLines = 0;
    [headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo((kMainBoundsWidth - 100) * scale);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-10 * scale);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxInfoPlayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BoxInfoPlayCell" forIndexPath:indexPath];
    
    NSDictionary * info = [self.listSource objectAtIndex:indexPath.row];
    [cell configNoFlagWithDict:info];
    
    if (self.type == DownLoadListType_Media || self.type == DownLoadListType_ADs) {
        NSInteger state = [[info objectForKey:@"state"] integerValue];
        if (state == 0) {
            [cell configIsDownLoad:NO];
        }else if (state == 1) {
            [cell configIsDownLoad:YES];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38 * kMainBoundsWidth / 375.f;
}

- (void)setupMediaDatas
{
    NSString * box_mac = [self.dataDict objectForKey:@"box_mac"];
    NSString * proID = [self.dataDict objectForKey:@"pro_download_period"];
    if (isEmptyString(proID)) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    GetDownLoadMediaRequest * request = [[GetDownLoadMediaRequest alloc] initWithMediaBoxMac:box_mac];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.dataSource = result;
            NSArray * list = [result objectForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                self.listSource = list;
                [self.tableView reloadData];
            }
        }
        
        NSString * period = [result objectForKey:@"period"];
        self.titleText = [NSString stringWithFormat:@"下载节目期号：%@", GetNoNullString(period)];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)setupADDatas
{
    NSString * box_mac = [self.dataDict objectForKey:@"box_mac"];
    NSString * ADID = [self.dataDict objectForKey:@"ads_download_period"];
    if (isEmptyString(ADID)) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    GetDownLoadADRequest * request = [[GetDownLoadADRequest alloc] initWithMediaADBoxMac:box_mac];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSArray * list = [result objectForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                self.dataSource = result;
                self.listSource = list;
                [self.tableView reloadData];
            }
        }
        
        NSString * period = [result objectForKey:@"period"];
        self.titleText = [NSString stringWithFormat:@"下载广告期号：%@", GetNoNullString(period)];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorFromRGB(0xffffff);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[BoxInfoPlayCell class] forCellReuseIdentifier:@"BoxInfoPlayCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _tableView;
}

- (UILabel *)progressLabel
{
    if (!_progressLabel) {
        CGFloat scale = kMainBoundsWidth / 375.f;
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _progressLabel.textAlignment = NSTextAlignmentRight;
        _progressLabel.font = kPingFangMedium(12 * scale);
        _progressLabel.textColor = UIColorFromRGB(0x62ad19);
        _progressLabel.text = @"已下载:80%";
    }
    return _progressLabel;
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
