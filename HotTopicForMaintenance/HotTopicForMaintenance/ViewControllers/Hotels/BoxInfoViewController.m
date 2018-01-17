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

@interface BoxInfoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation BoxInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView.tableHeaderView = [[BoxInfoTableHeaderView alloc] initWithFrame:CGRectZero];
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
