//
//  lookRestaurInforViewController.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "lookRestaurInforViewController.h"
#import "LookHotelInforModel.h"
#import "lookRestTableViewCell.h"
#import "LookHotelInforRequest.h"

@interface lookRestaurInforViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, copy) NSString * cachePath;

@property (nonatomic, strong) UILabel *baseInforLab;
@property (nonatomic, strong) UILabel *hotelNameLab;
@property (nonatomic, strong) UILabel *locationLab;
@property (nonatomic, strong) UILabel *wifiNameLab;
@property (nonatomic, strong) UILabel *listNameLab;
@property (nonatomic, strong) UILabel *macNameLab;
@property (nonatomic, strong) UILabel *wifiPsNameLab;
@property (nonatomic, strong) UILabel *stbInforLab;

@property (nonatomic, strong) UILabel *loPlatformLab;

@property (nonatomic, strong) UILabel *platInforLab;
@property (nonatomic, strong) UILabel *pIpLab;
@property (nonatomic, strong) UILabel *pMacLab;
@property (nonatomic, strong) UILabel *pLocationLab;
@property (nonatomic, strong) UILabel *volLab;
@property (nonatomic, strong) UILabel *tvTimeLab;

@property (nonatomic, strong) LookHotelInforModel *topHeaderModel;

@property (nonatomic , copy) NSString * cid;
@property (nonatomic , copy) NSString * hotelName;

@end

@implementation lookRestaurInforViewController

- (instancetype)initWithDetaiID:(NSString *)detailID WithHotelNam:(NSString *)hotelName;
{
    if (self = [super init]) {
        self.cid = detailID;
        self.hotelName = hotelName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self dataRequest];
}

- (void)initData{
    
    for (int i = 0; i < 10; i ++) {
        LookHotelInforModel *tmpModel = [[LookHotelInforModel alloc] init];
        
        [self.dataSource addObject:tmpModel];
    }
    [self.tableView reloadData];
    [self setUpTableHeaderView];
}

- (void)initInfo{
    
    self.title = self.hotelName;
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
    self.cachePath = [NSString stringWithFormat:@"%@%@.plist", FileCachePath, @"RestaurantRank"];
}

- (void)dataRequest
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在刷新" inView:self.view];
    LookHotelInforRequest * request = [[LookHotelInforRequest alloc] initWithId:self.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        [self.dataSource removeAllObjects];
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSDictionary *listDict = [dataDict objectForKey:@"list"];
        NSArray *hotelInfoArr = [listDict objectForKey:@"hotel_info"];
        if (hotelInfoArr.count > 0) {
            self.topHeaderModel = [[LookHotelInforModel alloc] initWithDictionary:hotelInfoArr[0]];
        }
        
        NSArray *posionArr = [listDict objectForKey:@"position"];
        for (int i = 0; i < posionArr.count; i ++) {
            LookHotelInforModel *tmpModel = [[LookHotelInforModel alloc] initWithDictionary:posionArr[i]];
            [self.dataSource addObject:tmpModel];
        }
        
        [self.tableView reloadData];
        [self setUpTableHeaderView];
        
        [MBProgressHUD showTextHUDWithText:@"获取成功" inView:self.view];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取失败，小热点正在休息~" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:NO];
        [MBProgressHUD showTextHUDWithText:@"获取失败，网络出现问题了~" inView:self.view];
        
    }];
}

#pragma mark -- 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    
    return _tableView;
}

-(void)setUpTableHeaderView{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 455)];
    
    self.baseInforLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.baseInforLab.backgroundColor = [UIColor clearColor];
    self.baseInforLab.font = [UIFont boldSystemFontOfSize:14];
    self.baseInforLab.textColor = [UIColor lightGrayColor];
    self.baseInforLab.text = @"基本信息";
    [headView addSubview:self.baseInforLab];
    [self.baseInforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(kMainBoundsWidth - 5);
        make.height.mas_equalTo(20);
    }];
    
    self.hotelNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.hotelNameLab.backgroundColor = [UIColor clearColor];
    self.hotelNameLab.font = [UIFont systemFontOfSize:14];
    self.hotelNameLab.textColor = [UIColor blackColor];
    self.hotelNameLab.text = [NSString stringWithFormat:@"酒店名称:%@",self.topHeaderModel.hotel_name ];
    [headView addSubview:self.hotelNameLab];
    [self.hotelNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseInforLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(20);
    }];
    
    self.locationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.locationLab.backgroundColor = [UIColor clearColor];
    self.locationLab.font = [UIFont systemFontOfSize:14];
    self.locationLab.textColor = [UIColor blackColor];
    self.locationLab.text = [NSString stringWithFormat:@"酒店地址:%@",self.topHeaderModel.hotel_addr];
    [headView addSubview:self.locationLab];
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotelNameLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 15);
        make.height.mas_equalTo(20);
    }];
    
    CGFloat topHeight = 75.0;
    NSArray *leftArr = [NSArray arrayWithObjects:@"所属区域：",@"酒楼级别：",@"安装日期：",@"酒楼联系人：",@"合作维护人：",@"座机：",@"手机：",nil];
    NSArray *leftValueArr = [NSArray arrayWithObjects:self.topHeaderModel.area_name,self.topHeaderModel.level,self.topHeaderModel.install_date,self.topHeaderModel.contractor,self.topHeaderModel.maintainer,self.topHeaderModel.tel,self.topHeaderModel.mobile,nil];
    for (int i = 0; i < leftValueArr.count; i ++) {
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.tag = 10086 + i;
        tmpLabel.font = [UIFont systemFontOfSize:14];
        tmpLabel.textColor = [UIColor blackColor];
        tmpLabel.text = @"";
        [headView addSubview:tmpLabel];
        tmpLabel.frame = CGRectMake(15, (topHeight + i *20 + (5 + i *5)), kMainBoundsWidth/2 - 15 - 10, 20);
        tmpLabel.text = [NSString stringWithFormat:@"%@%@",leftArr[i],leftValueArr[i]];
    }
    
    NSArray *rightArr = [NSArray arrayWithObjects:@"是否重点：",@"变更说明：",@"酒楼状态：",@"机顶盒类型：",@"小平台存放地址：",@"小平台远程ID：",@"技术运维人：",nil];
    NSArray *rightValueArr = [NSArray arrayWithObjects:self.topHeaderModel.is_key,self.topHeaderModel.state_change_reason,self.topHeaderModel.hotel_state,self.topHeaderModel.hotel_box_type,self.topHeaderModel.server_location,self.topHeaderModel.remote_id,self.topHeaderModel.tech_maintainer,nil];
    for (int i = 0; i < rightValueArr.count; i ++) {
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.tag = 20086 + i;
        tmpLabel.font = [UIFont systemFontOfSize:14];
        tmpLabel.textColor = [UIColor blackColor];
        tmpLabel.text = @"";
        [headView addSubview:tmpLabel];
        tmpLabel.frame = CGRectMake(kMainBoundsWidth/2 - 5, (topHeight + i *20 + (5 + i *5)), kMainBoundsWidth/2 - 15 + 10, 20);
        tmpLabel.text = [NSString stringWithFormat:@"%@%@",rightArr[i],rightValueArr[i]];
    }
    
    self.macNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.macNameLab.backgroundColor = [UIColor clearColor];
    self.macNameLab.font = [UIFont systemFontOfSize:14];
    self.macNameLab.textColor = [UIColor blackColor];
    self.macNameLab.text = [NSString stringWithFormat:@"小平台MAC地址:%@",self.topHeaderModel.mac_addr];
    [headView addSubview:self.macNameLab];
    [self.macNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(250 + 5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(20);
    }];
    
    self.wifiPsNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.wifiPsNameLab.backgroundColor = [UIColor clearColor];
    self.wifiPsNameLab.font = [UIFont systemFontOfSize:14];
    self.wifiPsNameLab.textColor = [UIColor blackColor];
    self.wifiPsNameLab.text = [NSString stringWithFormat:@"酒楼wifi密码:%@",self.topHeaderModel.hotel_wifi_pas];
    [headView addSubview:self.wifiPsNameLab];
    [self.wifiPsNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.macNameLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(20);
    }];
    
    self.locationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.locationLab.backgroundColor = [UIColor clearColor];
    self.locationLab.font = [UIFont systemFontOfSize:14];
    self.locationLab.textColor = [UIColor blackColor];
    self.locationLab.text = [NSString stringWithFormat:@"酒楼位置坐标:%@",self.topHeaderModel.gps];
    [headView addSubview:self.locationLab];
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wifiPsNameLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(20);
    }];

    self.wifiNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.wifiNameLab.backgroundColor = [UIColor clearColor];
    self.wifiNameLab.font = [UIFont systemFontOfSize:14];
    self.wifiNameLab.textColor = [UIColor blackColor];
    self.wifiNameLab.text = [NSString stringWithFormat:@"酒楼wifi名称:%@",self.topHeaderModel.hotel_wifi];
    [headView addSubview:self.wifiNameLab];
    [self.wifiNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.locationLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(20);
    }];
    
    self.listNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.listNameLab.backgroundColor = [UIColor clearColor];
    self.listNameLab.font = [UIFont systemFontOfSize:14];
    self.listNameLab.textColor = [UIColor blackColor];
    self.listNameLab.text = [NSString stringWithFormat:@"节目单:%@",self.topHeaderModel.menu_name];
    [headView addSubview:self.listNameLab];
    [self.listNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.wifiNameLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(20);
    }];
    
    //机顶盒
    self.stbInforLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.stbInforLab.backgroundColor = [UIColor clearColor];
    self.stbInforLab.font = [UIFont boldSystemFontOfSize:14];
    self.stbInforLab.textColor = [UIColor lightGrayColor];
    self.stbInforLab.text = [NSString stringWithFormat:@"版位信息（包间：%@机顶盒：%@电视：%@）",self.topHeaderModel.room_num,self.topHeaderModel.box_num,self.topHeaderModel.tv_num];
    [headView addSubview:self.stbInforLab];
    [self.stbInforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.listNameLab.mas_bottom).offset(10);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(kMainBoundsWidth - 5);
        make.height.mas_equalTo(20);
    }];

    
    UIView *stbBgView = [[UIView alloc] initWithFrame:CGRectZero];
    stbBgView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    [headView addSubview:stbBgView];
    [stbBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stbInforLab.mas_bottom).offset(10);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(kMainBoundsWidth - 10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *serialNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
    serialNumLab.backgroundColor = [UIColor clearColor];
    serialNumLab.font = [UIFont systemFontOfSize:14];
    serialNumLab.textColor = [UIColor blackColor];
    serialNumLab.textAlignment = NSTextAlignmentCenter;
    serialNumLab.text = @"包间";
    [stbBgView addSubview:serialNumLab];
    [serialNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo((kMainBoundsWidth - 10)/4 - 15);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *stbLocationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    stbLocationLab.backgroundColor = [UIColor clearColor];
    stbLocationLab.font = [UIFont systemFontOfSize:14];
    stbLocationLab.textColor = [UIColor blackColor];
    stbLocationLab.textAlignment = NSTextAlignmentCenter;
    stbLocationLab.text = @"机顶盒";
    [stbBgView addSubview:stbLocationLab];
    [stbLocationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(serialNumLab.mas_right);
        make.width.mas_equalTo((kMainBoundsWidth - 10)/4);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *stbMacLab = [[UILabel alloc] initWithFrame:CGRectZero];
    stbMacLab.backgroundColor = [UIColor clearColor];
    stbMacLab.font = [UIFont systemFontOfSize:14];
    stbMacLab.textColor = [UIColor blackColor];
    stbMacLab.text = @"mac";
    stbMacLab.textAlignment = NSTextAlignmentCenter;
    [stbBgView addSubview:stbMacLab];
    [stbMacLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(stbLocationLab.mas_right);
        make.width.mas_equalTo((kMainBoundsWidth - 10)/4 + 15);
        make.height.mas_equalTo(20);
    }];
    
    UILabel *stbStateLab = [[UILabel alloc] initWithFrame:CGRectZero];
    stbStateLab.backgroundColor = [UIColor clearColor];
    stbStateLab.font = [UIFont systemFontOfSize:14];
    stbStateLab.textColor = [UIColor blackColor];
    stbStateLab.text = @"状态";
    [stbBgView addSubview:stbStateLab];
    [stbStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(stbMacLab.mas_right).offset(15);
        make.width.mas_equalTo((kMainBoundsWidth - 10)/4 - 15);
        make.height.mas_equalTo(20);
    }];
    
    _tableView.tableHeaderView = headView;
}

#pragma mark - UITableViewDataSource
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
    LookHotelInforModel * model = [self.dataSource objectAtIndex:indexPath.row];
    static NSString *cellID = @"RestaurantRankCell";
    lookRestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[lookRestTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell configWithModel:model];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)dealloc
{
    [LookHotelInforRequest cancelRequest];
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
