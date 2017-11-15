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
#import "GetBindListReuqest.h"
#import "BindDeviceModel.h"
#import "Helper.h"

@interface BindingPositionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, copy) NSString * hotelID;
@property (nonatomic, copy) NSString * roomID;
@property (nonatomic, copy) NSString * macAddress;
@property (nonatomic, copy) NSString * hotelName;

@property (nonatomic, strong) UILabel *hotelLabel;
@property (nonatomic, strong) UILabel *wifiLabel;
@property (nonatomic, strong) UILabel *boxLabel;

@end

@implementation BindingPositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"绑定版位";
    
    [MBProgressHUD showLoadingHUDWithText:@"正在获取版位信息" inView:self.view];
    [[DeviceManager manager] startSearchDecice];
    [[DeviceManager manager] startMonitoring];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDeviceDidSuccess) name:RDSearchDeviceSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDeviceDidEnd) name:RDSearchDeviceDidEndNotification object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(reloadMyself)];
    // Do any additional setup after loading the view.
}

- (void)reloadMyself
{
    [[DeviceManager manager] startSearchDecice];
}

//发现了酒楼环境
- (void)searchDeviceDidSuccess
{
    if ([DeviceManager manager].isHotel && [DeviceManager manager].isRoom) {
        if (![self.hotelID isEqualToString:[DeviceManager manager].hotelID] ||
            ![self.roomID isEqualToString:[DeviceManager manager].roomID]) {
            self.hotelID = [DeviceManager manager].hotelID;
            self.roomID = [DeviceManager manager].roomID;
            self.macAddress = [DeviceManager manager].macAddress;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self setupDatas];
        }
    }
}

//搜索设备结束
- (void)searchDeviceDidEnd
{
    if (![DeviceManager manager].isHotel || ![DeviceManager manager].isRoom) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showTextHUDWithText:@"请连接酒楼wifi后继续操作" inView:[UIApplication sharedApplication].keyWindow];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setupDatas
{
    if (_tableView.superview) {
        [_tableView.tableHeaderView removeAllSubviews];
        [_tableView removeFromSuperview];
    }
    
    GetBindListReuqest * request = [[GetBindListReuqest alloc] initWithHotelId:self.hotelID roomID:self.roomID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.hotelName = [result objectForKey:@"hotel_name"];
            
            NSArray * list = [result objectForKey:@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                [self.dataSource removeAllObjects];
                for (NSInteger i = 0; i < list.count; i++) {
                    NSDictionary * info = [list objectAtIndex:i];
                    BindDeviceModel * model = [[BindDeviceModel alloc] initWithDictionary:info];
                    [self.dataSource addObject:model];
                }
            }
        }
        [self creatSubViews];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"获取失败" inView:self.view];
        
    }];
}

- (void)creatSubViews{
    
    self.title = @"绑定包间版位";
    
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
    self.hotelLabel.text = [NSString stringWithFormat:@"当前酒楼：%@", self.hotelName];
    [headView addSubview:self.hotelLabel];
    [self.hotelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15.f);
    }];
    
    self.wifiLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15.f) alignment:NSTextAlignmentLeft];
    self.wifiLabel.text = [NSString stringWithFormat:@"当前WIFI：%@", [Helper getWifiName]];
    [headView addSubview:self.wifiLabel];
    [self.wifiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotelLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(15.f);
    }];
    
    self.boxLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15.f) alignment:NSTextAlignmentLeft];
    self.boxLabel.text = [NSString stringWithFormat:@"当前机顶盒MAC：%@", self.macAddress];
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
    
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"RestaurantRankCell";
    BindPositionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[BindPositionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    BindDeviceModel * model =  [self.dataSource objectAtIndex:indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [cell configWithModel:model];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100 + 10;
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

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
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
