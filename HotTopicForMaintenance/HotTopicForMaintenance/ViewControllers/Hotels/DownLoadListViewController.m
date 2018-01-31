//
//  DownLoadListViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/18.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "DownLoadListViewController.h"
#import "BoxInfoPlayCell.h"

@interface DownLoadListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, copy) NSString * titleText;

@property (nonatomic, assign) DownLoadListType type;

@end

@implementation DownLoadListViewController

- (instancetype)initWithDataSource:(NSArray *)dataSource
{
    if (self = [super init]) {
        self.dataSource = dataSource;
    }
    return self;
}

- (void)configType:(DownLoadListType)type mediaDate:(NSString *)mediaDate adDate:(NSString *)adDate
{
    self.type = type;
    
    if (type == DownLoadListType_Media) {
        self.navigationItem.title = @"节目下载列表";
        self.titleText = [NSString stringWithFormat:@"下载节目期号：%@", GetNoNullString(mediaDate)];
    }else if (type == DownLoadListType_ADs) {
        self.navigationItem.title = @"广告下载列表";
        self.titleText = [NSString stringWithFormat:@"下载广告期号：%@", GetNoNullString(adDate)];
    }else if (type == DownLoadListType_PubProgram) {
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
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.tableView.tableHeaderView = headerView;
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
    
    NSDictionary * info = [self.dataSource objectAtIndex:indexPath.row];
    [cell configNoFlagWithDict:info];
    if (self.type == DownLoadListType_Media) {
        cell.playTitleLabel.text = [info objectForKey:@"ads_name"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38 * kMainBoundsWidth / 375.f;
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
