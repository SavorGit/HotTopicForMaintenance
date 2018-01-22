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

@end

@implementation DownLoadListViewController

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
    lineView.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [headerView addSubview:lineView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.font = kPingFangMedium(15 * scale);
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.text = @"下载节目期号：20170506103554";
    [headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.right.mas_equalTo(-15 * scale);
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BoxInfoPlayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BoxInfoPlayCell" forIndexPath:indexPath];
    
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
