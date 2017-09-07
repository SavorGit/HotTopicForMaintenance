//
//  HomeHotelInfoView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeHotelInfoView.h"
#import "MBProgressHUD+Custom.h"
#import "HotelIndexRequest.h"
#import "HotTopicTools.h"
#import "HotelInfoTableViewCell.h"

@interface HomeHotelInfoView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UILabel * bottomLabel;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation HomeHotelInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createViews];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self createViews];
    }
    return self;
}

- (void)createViews
{
    self.dataSource = [NSMutableArray new];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.font = kPingFangMedium(15);
    titleLabel.textColor = UIColorFromRGB(0x333333);
    titleLabel.text = @"小热点最新状态";
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(120, 45));
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0x666666);
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(45.5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(0.5);
    }];
    
    UIButton * refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    refreshButton.layer.borderWidth = .5f;
    refreshButton.layer.cornerRadius = 5;
    refreshButton.layer.masksToBounds = YES;
    [refreshButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    refreshButton.titleLabel.font = kPingFangRegular(13);
    [self addSubview:refreshButton];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.bottom.equalTo(lineView.mas_top).offset(-10);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(70);
    }];
    [refreshButton setImageEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 10)];
    [refreshButton addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.bottomLabel.numberOfLines = 0;
    self.bottomLabel.font = kPingFangRegular(13);
    self.bottomLabel.textColor = UIColorFromRGB(0x333333);
    [self addSubview:self.bottomLabel];
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-5);
        make.height.mas_lessThanOrEqualTo(40);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[HotelInfoTableViewCell class] forCellReuseIdentifier:@"hotelInfoCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.mas_equalTo(0);
        make.bottom.equalTo(self.bottomLabel.mas_top).offset(-5);
        make.right.mas_equalTo(0);
    }];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 20, 5)];
    
    self.layer.borderColor = UIColorFromRGB(0x666666).CGColor;
    self.layer.borderWidth = .5f;
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    
    [self refreshData];
}

- (void)refreshData
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在刷新" inView:self];
    HotelIndexRequest * request = [[HotelIndexRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        [self.dataSource removeAllObjects];
        NSDictionary * dataDict = [response objectForKey:@"result"];
        if ([dataDict objectForKey:@"list"]) {
            self.dataSource = [NSMutableArray arrayWithArray:[dataDict objectForKey:@"list"]];
        }
        
        self.bottomLabel.text = [dataDict objectForKey:@"remark"];
        [self.tableView reloadData];
        [MBProgressHUD showTextHUDWithText:@"获取成功" inView:self];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取失败" inView:self];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:NO];
        [MBProgressHUD showTextHUDWithText:@"获取失败，网络出现问题了~" inView:self];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotelInfoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"hotelInfoCell" forIndexPath:indexPath];
    
    [cell configWithInfo:[self.dataSource objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * str = [self.dataSource objectAtIndex:indexPath.row];
    CGFloat height = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 50 title:str font:kPingFangRegular(13)];
    
    return height + (height / 18 * 5);
}

@end
