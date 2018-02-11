//
//  MyHotelViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/2/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "MyHotelViewController.h"
#import "MyHotelInforRequest.h"
#import "PublisherInforRequest.h"
#import "MyInspectTableViewCell.h"
#import "MJRefresh.h"
#import "HotTopicTools.h"
#import "MyInspectModel.h"
#import "RestaurantRankInforViewController.h"
#import "UserManager.h"
#import "UserNameViewController.h"
#import "BaseNavigationController.h"
#import "PublisherModel.h"

@interface MyHotelViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * pubInforArray;
@property (nonatomic, strong) NSDictionary *headDic;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *normalLabel;
@property (nonatomic, strong) UILabel *frozenLabel;

@property (nonatomic, strong) UILabel *boxOnLineLabel;
@property (nonatomic, strong) UILabel *boxErrLabel;
@property (nonatomic, strong) UILabel *boxBListLabel;
@property (nonatomic, strong) UIButton *nameButton;
@property (nonatomic, strong) NSString *publishIdStr;

@end

@implementation MyHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的酒楼";
    self.pageNum = 1;
    [self initInfor];
    [self getMyHotelList];
    [self pubInforRequest];

}

-(void)initInfor{
    
    self.publishIdStr = [[NSString alloc] init];
    self.publishIdStr =[UserManager manager].user.userid;
    
    self.nameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.nameButton setFrame:CGRectMake(0, 0, 150, 30)];
    [self.nameButton setTitleColor:kNavTitleColor forState:UIControlStateNormal];
    self.nameButton.titleLabel.font = kPingFangMedium(16);
    [self.nameButton setTitle:[UserManager manager].user.nickname forState:UIControlStateNormal];
    [self.nameButton setImage:[UIImage imageNamed:@"ywsy_csxl"] forState:UIControlStateNormal];
    [self.nameButton setAdjustsImageWhenHighlighted:NO];
    self.nameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.nameButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 25)];
    [self.nameButton setImageEdgeInsets:UIEdgeInsetsMake(0, 130, 0, 0)];
    [self.nameButton addTarget:self action:@selector(nameButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.nameButton];
    
}

- (void)nameButtonDidClicked{
    
    if (self.pubInforArray.count >= 2) {
        UserNameViewController * vc = [[UserNameViewController alloc] initWithPubArray:self.pubInforArray];
        vc.btnClick = ^(PublisherModel *model) {
//            if (model.remark.length <= 3) {
//                self.nameButton.titleLabel.font = kPingFangMedium(16);
//            }else{
//                self.nameButton.titleLabel.font = kPingFangMedium(12);
//            }
            [self.nameButton setTitle:model.remark forState:UIControlStateNormal];
            self.publishIdStr = model.publish_user_id;
            [self getMyHotelList];
        };
        BaseNavigationController * na = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:na animated:YES completion:^{
        }];
    }else{
        [MBProgressHUD showTextHUDWithText:@"未获取到发布人信息" inView:self.view];
    }
}

-(void)setUpTableHeaderView{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 190 * scale)];
    headView.backgroundColor = [UIColor clearColor];
    UIImageView  *logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [logoImageView setImage:[UIImage imageNamed:@"jiulou"]];
    [headView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(37 * scale);
        make.height.mas_equalTo(12 * scale);
    }];
    
    self.numberLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xff4d55) font:kPingFangMedium(20 * scale) alignment:NSTextAlignmentLeft];
    self.numberLabel.text = [NSString stringWithFormat:@"%@", GetNoNullString([self.headDic objectForKey:@"hotel_all_nums"])];
    [headView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoImageView);
        make.top.mas_equalTo(logoImageView.mas_bottom);
        make.height.mas_equalTo(19 * scale);
    }];
    
    self.normalLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    self.normalLabel.text = [NSString stringWithFormat:@"正常 %@", GetNoNullString([self.headDic objectForKey:@"hotel_all_normal_nums"])];
    [headView addSubview:self.normalLabel];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(92 * scale);
         make.top.mas_equalTo(22 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.frozenLabel =[HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    self.frozenLabel.text = [NSString stringWithFormat:@"冻结 %@", GetNoNullString([self.headDic objectForKey:@"hotel_all_freeze_nums"])];
    [headView addSubview:self.frozenLabel];
    [self.frozenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.normalLabel.mas_right).offset(50 * scale);
        make.top.mas_equalTo(22 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIView *flineView = [[UIView alloc] initWithFrame:CGRectZero];
    flineView.backgroundColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1.0f];
    [headView addSubview:flineView];
    [flineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(1 * scale);
    }];
    
    UILabel *boxLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:[UIColor blackColor] font:kPingFangMedium(16 * scale) alignment:NSTextAlignmentLeft];
    boxLabel.text = @"机顶盒";
    [headView addSubview:boxLabel];
    [boxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoImageView);
        make.top.mas_equalTo(flineView.mas_bottom).offset(10 * scale);
        make.height.mas_equalTo(19 * scale);
    }];
    
    UIImageView * normalImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [normalImageView setImage:[UIImage imageNamed:@"zaixian"]];
    [headView addSubview:normalImageView];
    [normalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(92 * scale);
        make.top.mas_equalTo(flineView.mas_bottom).offset((10 + 3) * scale);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.boxOnLineLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    self.boxOnLineLabel.text = [NSString stringWithFormat:@"在线 %@", GetNoNullString([self.headDic objectForKey:@"box_normal_num"])];
    [headView addSubview:self.boxOnLineLabel];
    [self.boxOnLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(normalImageView.mas_right).offset(5);
        make.top.mas_equalTo(flineView.mas_bottom).offset(10 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * faultImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [faultImageView setImage:[UIImage imageNamed:@"lixian"]];
    [headView addSubview:faultImageView];
    [faultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.boxOnLineLabel.mas_right).offset(50 * scale);
        make.top.mas_equalTo(flineView.mas_bottom).offset((10 + 3) * scale);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.boxErrLabel =[HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    self.boxErrLabel.text = [NSString stringWithFormat:@"异常 %@", GetNoNullString([self.headDic objectForKey:@"box_not_normal_num"])];
    [headView addSubview:self.boxErrLabel];
    [self.boxErrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(faultImageView.mas_right).offset(5);
        make.top.mas_equalTo(flineView.mas_bottom).offset(10 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * bListImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [bListImageView setImage:[UIImage imageNamed:@"hmd"]];
    [headView addSubview:bListImageView];
    [bListImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(92 * scale);
        make.top.mas_equalTo(boxLabel.mas_bottom).offset((10 + 3) * scale);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.boxBListLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    self.boxBListLabel.text = [NSString stringWithFormat:@"黑名单 %@", GetNoNullString([self.headDic objectForKey:@"black_box_num"])];
    [headView addSubview:self.boxBListLabel];
    [self.boxBListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bListImageView.mas_right).offset(5);
        make.top.mas_equalTo(boxLabel.mas_bottom).offset(10 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIView *slineView = [[UIView alloc] initWithFrame:CGRectZero];
    slineView.backgroundColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1.0f];
    [headView addSubview:slineView];
    [slineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.boxBListLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(1 * scale);
    }];
    
    UILabel *explainLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:[UIColor darkGrayColor] font: kPingFangLight(12 * scale) alignment:NSTextAlignmentLeft];
    explainLabel.numberOfLines = 2;
    explainLabel.text = @"说明：1、在线为心跳72小时以内，异常大于72小时；2、巡检人\n员发现电视没有开机导致连续三天失联的版位则进入黑名单。";
    [headView addSubview:explainLabel];
    [explainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(logoImageView);
        make.top.mas_equalTo(slineView.mas_bottom).offset(10 * scale);
        make.height.mas_equalTo(35 * scale);
    }];
    
    UIView *tlineView = [[UIView alloc] initWithFrame:CGRectZero];
    tlineView.backgroundColor = [UIColor colorWithRed:245.f/255.f green:245.f/255.f blue:245.f/255.f alpha:1.0f];
    [headView addSubview:tlineView];
    [tlineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(explainLabel.mas_bottom).offset(12 * scale);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMore)];
    self.tableView.tableHeaderView = headView;
    
}

- (void)configHeaderData{
    self.numberLabel.text = [NSString stringWithFormat:@"%@", GetNoNullString([self.headDic objectForKey:@"hotel_all_nums"])];
    self.normalLabel.text = [NSString stringWithFormat:@"正常 %@", GetNoNullString([self.headDic objectForKey:@"hotel_all_normal_nums"])];
    self.frozenLabel.text = [NSString stringWithFormat:@"冻结 %@", GetNoNullString([self.headDic objectForKey:@"hotel_all_freeze_nums"])];
    self.boxOnLineLabel.text = [NSString stringWithFormat:@"在线 %@", GetNoNullString([self.headDic objectForKey:@"box_normal_num"])];
    self.boxErrLabel.text = [NSString stringWithFormat:@"异常 %@", GetNoNullString([self.headDic objectForKey:@"box_not_normal_num"])];
    self.boxBListLabel.text = [NSString stringWithFormat:@"黑名单 %@", GetNoNullString([self.headDic objectForKey:@"black_box_num"])];

}

- (void)createTableView
{
    if (self.tableView && self.tableView.superview) {
        [self.tableView removeFromSuperview];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    [self.tableView registerClass:[MyInspectTableViewCell class] forCellReuseIdentifier:@"myInseptCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 10.f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, .1f)];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInspectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"myInseptCell" forIndexPath:indexPath];
    
    MyInspectModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInspectModel * model = [self.dataSource objectAtIndex:indexPath.row];
    NSString * info = [NSString stringWithFormat:@"%@\n%@", model.small_palt_info, model.box_info];
    CGFloat height = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 50 title:info font:kPingFangRegular(14)];
    return 51 + height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyInspectModel * model = [self.dataSource objectAtIndex:indexPath.row];
    RestaurantRankInforViewController * vc = [[RestaurantRankInforViewController alloc] initWithDetaiID:model.hotel_id WithHotelNam:model.hotel_name];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pubInforRequest
{
    PublisherInforRequest * request = [[PublisherInforRequest alloc] initWithId:[UserManager manager].user.userid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.pubInforArray removeAllObjects];
        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSArray *listArray = [dataDict objectForKey:@"list"];
        for (int i = 0; i < listArray.count; i ++) {
            PublisherModel *tmpModel = [[PublisherModel alloc] initWithDictionary:listArray[i]];
            [self.pubInforArray addObject:tmpModel];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取失败，小热点正在休息~" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"获取失败，网络出现问题了~" inView:self.view];
        
    }];
}

- (void)getMyHotelList
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在获取酒楼信息" inView:self.view];
    
    [self.dataSource removeAllObjects];
    [self requestWithID:self.publishIdStr success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"result"]) {
            
            NSDictionary * dataDict = [response objectForKey:@"result"];
            NSDictionary *listDic = [dataDict objectForKey:@"list"];
            self.headDic = [listDic objectForKey:@"heart"];
            NSArray *hotelArray = [listDic objectForKey:@"hotel"];
            
            if (hotelArray && hotelArray.count > 0) {
                
                NSString *count = [dataDict objectForKey:@"count"];
                
                for (NSInteger i = 0; i < hotelArray.count; i++) {
                    NSDictionary * dict = [hotelArray objectAtIndex:i];
                    MyInspectModel * model = [[MyInspectModel alloc] initWithDictionary:dict];
                    model.count = count;
                    [self.dataSource addObject:model];
                }
                
                BOOL isNextPage = [[dataDict objectForKey:@"isNextPage"] boolValue];
                if (!isNextPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
        [self createTableView];
        
        if (self.dataSource.count == 0) {
            [MBProgressHUD showTextHUDWithText:@"暂无酒楼记录" inView:self.view];
        }else{
            [self setUpTableHeaderView];
        }
        
        [hud hideAnimated:YES];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取失败" inView:self.view];
        }
        
        [self createTableView];
//        [self setUpTableHeaderView];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"获取失败，网络出现问题了~" inView:self.view];
        
        [self createTableView];
//        [self setUpTableHeaderView];
    }];
}

- (void)refreshData
{
    self.pageNum = 1;
    [self requestWithID:self.publishIdStr success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"result"]) {
            
            NSDictionary * dataDict = [response objectForKey:@"result"];
            NSDictionary *listDic = [dataDict objectForKey:@"list"];
            self.headDic = [listDic objectForKey:@"heart"];
            NSArray *hotelArray = [listDic objectForKey:@"hotel"];
            
            if (hotelArray && hotelArray.count > 0) {
                
                [self.dataSource removeAllObjects];
                NSString *count = [dataDict objectForKey:@"count"];
                for (NSInteger i = 0; i < hotelArray.count; i++) {
                    NSDictionary * dict = [hotelArray objectAtIndex:i];
                    MyInspectModel * model = [[MyInspectModel alloc] initWithDictionary:dict];
                    model.count = count;
                    [self.dataSource addObject:model];
                }
                
                [self.tableView reloadData];
                [self configHeaderData];
                
                BOOL isNextPage = [[dataDict objectForKey:@"isNextPage"] boolValue];
                if (!isNextPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
        
        if (self.dataSource.count == 0) {
            [MBProgressHUD showTextHUDWithText:@"暂无异常报告" inView:self.view];
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"刷新失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"刷新失败" inView:self.view];
        
    }];
}

- (void)getMore
{
    self.pageNum ++;
    [self requestWithID:self.publishIdStr success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        if (dataDict) {
            NSDictionary *listDic = [dataDict objectForKey:@"list"];
            self.headDic = [listDic objectForKey:@"heart"];
            NSArray *hotelArray = [listDic objectForKey:@"hotel"];
            
            if (hotelArray && hotelArray.count > 0) {
                
                [self.dataSource removeAllObjects];
                NSString *count = [dataDict objectForKey:@"count"];
                for (NSInteger i = 0; i < hotelArray.count; i++) {
                    NSDictionary * dict = [hotelArray objectAtIndex:i];
                    MyInspectModel * model = [[MyInspectModel alloc] initWithDictionary:dict];
                    model.count = count;
                    [self.dataSource addObject:model];
                }
                
                [self createTableView];
                [self configHeaderData];
                
                BOOL isNextPage = [[dataDict objectForKey:@"isNextPage"] boolValue];
                if (!isNextPage) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }
        }
        
        BOOL isNextPage = [[dataDict objectForKey:@"isNextPage"] boolValue];
        if (isNextPage) {
            [self.tableView.mj_footer endRefreshing];
        }else{
            self.pageNum --;
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        self.pageNum --;
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        self.pageNum --;
        [self.tableView.mj_footer endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        
    }];
}

- (void)requestWithID:(NSString *)errorID success:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock
{
    MyHotelInforRequest * request = [[MyHotelInforRequest alloc] initWithID:errorID pageNum:[NSString stringWithFormat:@"%ld",self.pageNum] pageSize:@"20"];
    [request sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:networkFailureBlock];
}

- (void)dealloc
{
    [MyHotelInforRequest cancelRequest];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (NSMutableArray *)pubInforArray
{
    if (!_pubInforArray) {
        _pubInforArray = [NSMutableArray new];
    }
    return _pubInforArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
