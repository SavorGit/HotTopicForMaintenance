//
//  BindingPositionViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BindingPositionViewController.h"
#import "BindPositionTableViewCell.h"
#import "HotTopicTools.h"

@interface BindingPositionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSArray * titleArray; //表项标题

@end

@implementation BindingPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubViews];
    // Do any additional setup after loading the view.
}

- (void)creatSubViews{
    
    self.title = @"绑定包间版位";
    self.titleArray = [NSArray arrayWithObjects:@"选择酒楼",@"联系人",@"联系电话",@"地址",@"任务紧急程度", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 100)];
    headView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    _tableView.tableHeaderView = headView;
    
    UILabel *hotelLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:[UIColor blackColor] font:kPingFangMedium(15.f) alignment:NSTextAlignmentLeft];
    hotelLabel.text = @"当前酒楼：";
    [headView addSubview:hotelLabel];
    [hotelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15.f);
    }];
    
    UILabel *wifiLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:[UIColor blackColor] font:kPingFangMedium(15.f) alignment:NSTextAlignmentLeft];
    wifiLabel.text = @"当前WIFI：";
    [headView addSubview:wifiLabel];
    [wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hotelLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15.f);
    }];
    
    UILabel *boxLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:[UIColor blackColor] font:kPingFangMedium(15.f) alignment:NSTextAlignmentLeft];
    boxLabel.text = @"当前机顶盒MAC：";
    [headView addSubview:boxLabel];
    [boxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wifiLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15.f);
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"RestaurantRankCell";
    BindPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BindPositionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [cell configWithModel:nil];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100 + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
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
