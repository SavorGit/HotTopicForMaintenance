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
#import "DeviceManager.h"

@interface BindingPositionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSArray * titleArray; //表项标题

@property (nonatomic, strong) UILabel *hotelLabel;
@property (nonatomic, strong) UILabel *wifiLabel;
@property (nonatomic, strong) UILabel *boxLabel;

@end

@implementation BindingPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DeviceManager manager] startSearchDecice];
    [[DeviceManager manager] startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDeviceDidSuccess) name:RDSearchDeviceSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDeviceDidEnd) name:RDSearchDeviceDidEndNotification object:nil];
    
    [self creatSubViews];
    // Do any additional setup after loading the view.
}

//发现了酒楼环境
- (void)searchDeviceDidSuccess
{
    
}

//搜索设备结束
- (void)searchDeviceDidEnd
{
    
}

- (void)creatSubViews{
    
    self.title = @"绑定包间版位";
    self.titleArray = [NSArray arrayWithObjects:@"选择酒楼",@"联系人",@"联系电话",@"地址",@"任务紧急程度", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = VCBackgroundColor;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 100)];
    headView.backgroundColor = UIColorFromRGB(0xffffff);
    _tableView.tableHeaderView = headView;
    
    self.hotelLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15.f) alignment:NSTextAlignmentLeft];
    self.hotelLabel.text = @"当前酒楼：";
    [headView addSubview:self.hotelLabel];
    [self.hotelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15.f);
    }];
    
    self.wifiLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15.f) alignment:NSTextAlignmentLeft];
    self.wifiLabel.text = @"当前WIFI：";
    [headView addSubview:self.wifiLabel];
    [self.wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotelLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15.f);
    }];
    
    self.boxLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15.f) alignment:NSTextAlignmentLeft];
    self.boxLabel.text = @"当前机顶盒MAC：";
    [headView addSubview:self.boxLabel];
    [self.boxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wifiLabel.mas_bottom).offset(10);
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

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[DeviceManager manager] stopMonitoring];
    [[DeviceManager manager] stopSearchDevice];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDSearchDeviceSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RDSearchDeviceDidEndNotification object:nil];
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
