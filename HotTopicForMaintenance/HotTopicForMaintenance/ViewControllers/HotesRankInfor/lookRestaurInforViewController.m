//
//  lookRestaurInforViewController.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "lookRestaurInforViewController.h"
#import "RestaurantRankModel.h"
#import "lookRestTableViewCell.h"

@interface lookRestaurInforViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, copy) NSString * cachePath;

@property (nonatomic, strong) UILabel *baseInforLab;
@property (nonatomic, strong) UILabel *contactLab;
@property (nonatomic, strong) UILabel *conPhoneLab;
@property (nonatomic, strong) UILabel *maintenanceLab;
@property (nonatomic, strong) UILabel *mPhoneLab;
@property (nonatomic, strong) UILabel *locationLab;
@property (nonatomic, strong) UILabel *loPlatformLab;

@property (nonatomic, strong) UILabel *platInforLab;
@property (nonatomic, strong) UILabel *pIpLab;
@property (nonatomic, strong) UILabel *pMacLab;
@property (nonatomic, strong) UILabel *pLocationLab;
@property (nonatomic, strong) UILabel *volLab;
@property (nonatomic, strong) UILabel *tvTimeLab;

@end

@implementation lookRestaurInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self initData];
}

- (void)initData{
    
    for (int i = 0; i < 10; i ++) {
        RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] init];
        tmpModel.string1 = @"V1";
        tmpModel.string2 = @"B9876545678";
        tmpModel.string3 = @"V1机顶盒";
        tmpModel.string4 = @"3分钟前";
        tmpModel.string5 = @"2017-08-28 08：08";
        tmpModel.string6 = @"08-28 17：39（郑伟）";
        tmpModel.stateType = 0;
        
        [self.dataSource addObject:tmpModel];
    }
    [self.tableView reloadData];
    [self setUpTableHeaderView];
}

- (void)initInfo{
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
    self.cachePath = [NSString stringWithFormat:@"%@%@.plist", FileCachePath, @"RestaurantRank"];
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
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    
    self.baseInforLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.baseInforLab.backgroundColor = [UIColor clearColor];
    self.baseInforLab.font = [UIFont boldSystemFontOfSize:14];
    self.baseInforLab.textColor = [UIColor lightGrayColor];
    self.baseInforLab.text = @"基本信息";
    [headView addSubview:self.baseInforLab];
    [self.baseInforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(kMainBoundsWidth - 5);
        make.height.mas_equalTo(20);
    }];
    
    self.contactLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contactLab.backgroundColor = [UIColor clearColor];
    self.contactLab.font = [UIFont systemFontOfSize:14];
    self.contactLab.textColor = [UIColor blackColor];
    self.contactLab.text = @"联系人：赵小二";
    [headView addSubview:self.contactLab];
    [self.contactLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseInforLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth/2 - 15);
        make.height.mas_equalTo(20);
    }];
    
    self.conPhoneLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.conPhoneLab.backgroundColor = [UIColor clearColor];
    self.conPhoneLab.font = [UIFont systemFontOfSize:14];
    self.conPhoneLab.textColor = [UIColor blackColor];
    self.conPhoneLab.text = @"联系电话：18666667678";
    [headView addSubview:self.conPhoneLab];
    [self.conPhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.baseInforLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.contactLab.mas_right);
        make.width.mas_equalTo(kMainBoundsWidth/2 - 15);
        make.height.mas_equalTo(20);
    }];
    
    self.maintenanceLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.maintenanceLab.backgroundColor = [UIColor clearColor];
    self.maintenanceLab.font = [UIFont systemFontOfSize:14];
    self.maintenanceLab.textColor = [UIColor blackColor];
    self.maintenanceLab.text = @"维护人：小张";
    [headView addSubview:self.maintenanceLab];
    [self.maintenanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contactLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth/2 - 15);
        make.height.mas_equalTo(20);
    }];
    
    self.mPhoneLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mPhoneLab.backgroundColor = [UIColor clearColor];
    self.mPhoneLab.font = [UIFont systemFontOfSize:14];
    self.mPhoneLab.textColor = [UIColor blackColor];
    self.mPhoneLab.text = @"联系电话：18510378890";
    [headView addSubview:self.mPhoneLab];
    [self.mPhoneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contactLab.mas_bottom).offset(5);
        make.left.mas_equalTo(self.maintenanceLab.mas_right);
        make.width.mas_equalTo(kMainBoundsWidth/2 - 15);
        make.height.mas_equalTo(20);
    }];
    
    self.locationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.locationLab.backgroundColor = [UIColor clearColor];
    self.locationLab.font = [UIFont systemFontOfSize:14];
    self.locationLab.textColor = [UIColor blackColor];
    self.locationLab.text = @"位置：北京市朝阳区永峰写字楼六楼601";
    [headView addSubview:self.locationLab];
    [self.locationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.maintenanceLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 15);
        make.height.mas_equalTo(20);
    }];
    
    self.pLocationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pLocationLab.backgroundColor = [UIColor clearColor];
    self.pLocationLab.font = [UIFont systemFontOfSize:14];
    self.pLocationLab.textColor = [UIColor blackColor];
    self.pLocationLab.text = @"小平台位置：前台";
    [headView addSubview:self.pLocationLab];
    [self.pLocationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.locationLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 15);
        make.height.mas_equalTo(20);
    }];
    
    //小平台
    self.platInforLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.platInforLab.backgroundColor = [UIColor clearColor];
    self.platInforLab.font = [UIFont boldSystemFontOfSize:14];
    self.platInforLab.textColor = [UIColor lightGrayColor];
    self.platInforLab.text = @"小平台";
    [headView addSubview:self.platInforLab];
    [self.platInforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pLocationLab.mas_bottom).offset(10);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(kMainBoundsWidth - 5);
        make.height.mas_equalTo(20);
    }];
    
    self.pIpLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pIpLab.backgroundColor = [UIColor clearColor];
    self.pIpLab.font = [UIFont systemFontOfSize:14];
    self.pIpLab.textColor = [UIColor blackColor];
    self.pIpLab.text = @"IP:192.168.0.1";
    [headView addSubview:self.pIpLab];
    [self.pIpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.platInforLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth/2 - 15);
        make.height.mas_equalTo(20);
    }];
    
    self.pIpLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pIpLab.backgroundColor = [UIColor clearColor];
    self.pIpLab.font = [UIFont systemFontOfSize:14];
    self.pIpLab.textColor = [UIColor blackColor];
    self.pIpLab.text = @"IP:192.168.0.1";
    [headView addSubview:self.pIpLab];
    [self.pIpLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.platInforLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo((kMainBoundsWidth - 30)/3);
        make.height.mas_equalTo(20);
    }];
    
    self.pMacLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pMacLab.backgroundColor = [UIColor clearColor];
    self.pMacLab.font = [UIFont systemFontOfSize:14];
    self.pMacLab.textColor = [UIColor blackColor];
    self.pMacLab.text = @"mac 192.168.0.1";
    [headView addSubview:self.pMacLab];
    [self.pMacLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.platInforLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.pIpLab.mas_right);
        make.width.mas_equalTo((kMainBoundsWidth - 30)/3);
        make.height.mas_equalTo(20);
    }];
    
    self.pLocationLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.pLocationLab.backgroundColor = [UIColor clearColor];
    self.pLocationLab.font = [UIFont systemFontOfSize:14];
    self.pLocationLab.textColor = [UIColor blackColor];
    self.pLocationLab.text = @"位置：楼梯间";
    [headView addSubview:self.pLocationLab];
    [self.pLocationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.platInforLab.mas_bottom).offset(10);
        make.left.mas_equalTo(self.pMacLab.mas_right);
        make.width.mas_equalTo((kMainBoundsWidth - 30)/3);
        make.height.mas_equalTo(20);
    }];
    
    self.volLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.volLab.backgroundColor = [UIColor clearColor];
    self.volLab.font = [UIFont systemFontOfSize:14];
    self.volLab.textColor = [UIColor blackColor];
    self.volLab.text = @"音量 50";
    [headView addSubview:self.volLab];
    [self.volLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pIpLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth/2 - 15);
        make.height.mas_equalTo(20);
    }];
    
    self.tvTimeLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.tvTimeLab.backgroundColor = [UIColor clearColor];
    self.tvTimeLab.font = [UIFont systemFontOfSize:14];
    self.tvTimeLab.textColor = [UIColor blackColor];
    self.tvTimeLab.text = @"电视切换时间 30S";
    [headView addSubview:self.tvTimeLab];
    [self.tvTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.pIpLab.mas_bottom).offset(5);
        make.left.mas_equalTo(self.volLab.mas_right);
        make.width.mas_equalTo(kMainBoundsWidth/2 - 15);
        make.height.mas_equalTo(20);
    }];
    
    //机顶盒
    UILabel *stbInforLab = [[UILabel alloc] initWithFrame:CGRectZero];
    stbInforLab.backgroundColor = [UIColor clearColor];
    stbInforLab.font = [UIFont boldSystemFontOfSize:14];
    stbInforLab.textColor = [UIColor lightGrayColor];
    stbInforLab.text = @"机顶盒";
    [headView addSubview:stbInforLab];
    [stbInforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.volLab.mas_bottom).offset(10);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(kMainBoundsWidth - 5);
        make.height.mas_equalTo(20);
    }];
    
    UIView *stbBgView = [[UIView alloc] initWithFrame:CGRectZero];
    stbBgView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1.0];
    [headView addSubview:stbBgView];
    [stbBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(stbInforLab.mas_bottom).offset(10);
        make.left.mas_equalTo(5);
        make.width.mas_equalTo(kMainBoundsWidth - 10);
        make.height.mas_equalTo(40);
    }];
    
    UILabel *serialNumLab = [[UILabel alloc] initWithFrame:CGRectZero];
    serialNumLab.backgroundColor = [UIColor clearColor];
    serialNumLab.font = [UIFont systemFontOfSize:14];
    serialNumLab.textColor = [UIColor blackColor];
    serialNumLab.textAlignment = NSTextAlignmentCenter;
    serialNumLab.text = @"序号";
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
    stbLocationLab.text = @"位置";
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
    RestaurantRankModel * model = [self.dataSource objectAtIndex:indexPath.row];
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
