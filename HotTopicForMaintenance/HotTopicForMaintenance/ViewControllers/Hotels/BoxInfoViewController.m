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
#import "DownLoadListViewController.h"
#import "CheckResultView.h"
#import "GetBoxInfoRequest.h"
#import "OneKeyCheckRequest.h"
#import <MJRefresh/MJRefreshNormalHeader.h>
#import "GetDownLoadMediaRequest.h"
#import "GetDownLoadADRequest.h"
#import "GetPubProgramRequest.h"
#import "DamageConfigRequest.h"
#import "StateConfigRequest.h"
#import "RestaurantRankModel.h"
#import "DamageUploadRequest.h"
#import "DamageUploadModel.h"
#import "Helper.h"
#import "FaultListViewController.h"
#import "UserManager.h"



@interface BoxInfoViewController ()<UITableViewDelegate, UITableViewDataSource, BoxInfoTableHeaderViewDelegate,UITextViewDelegate>

@property (nonatomic, copy) NSString * boxID;
@property (nonatomic, copy) NSString * hotelID;
@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) BoxInfoTableHeaderView * tableHeaderView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSDictionary * dataDict;
@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) UIView *mListView;
@property (nonatomic, strong) UIImageView *sheetBgView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITextView *remarkTextView;
@property (nonatomic, strong) UILabel *mReasonLab;

@property (nonatomic, strong) NSMutableArray * dConfigData; //故障数据源
@property (nonatomic, strong) DamageUploadModel *dUploadModel;
@property (nonatomic, strong) UIButton * unResolvedBtn;
@property (nonatomic, strong) UIButton * resolvedBtn;
@property (nonatomic, strong) UIButton * repairBtn;
@property (nonatomic, strong) UIButton * submitBtn;
@property (nonatomic, assign) BOOL isRefreh;


@end

@implementation BoxInfoViewController

- (instancetype)initWithBoxID:(NSString *)boxID title:(NSString *)title hotelID:(NSString *)hotelID
{
    if (self = [super init]) {
        self.boxID = boxID;
        self.hotelID = hotelID;
        self.navigationItem.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dConfigData = [[NSMutableArray alloc] init];
     self.dUploadModel = [[DamageUploadModel alloc] init];
    
    [self setupSubViews];
    [self setupDatas];
    [self demageConfigRequest];
}

- (void)setupSubViews
{
    self.tableHeaderView = [[BoxInfoTableHeaderView alloc] initWithFrame:CGRectZero];
    self.tableHeaderView.delegate = self;
    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(setupDatas)];
}

- (void)setupDatas
{
    GetBoxInfoRequest * request = [[GetBoxInfoRequest alloc] initWithBoxID:self.boxID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.dataDict = result;
            
            NSArray * program_list = [result objectForKey:@"program_list"];
            if ([program_list isKindOfClass:[NSArray class]]) {
                self.dataSource = program_list;
            }else{
                self.dataSource = [NSArray new];
            }
        }
        [self reloadBoxData];
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"版位信息错误" inView:self.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self.tableView.mj_header endRefreshing];
        [MBProgressHUD showTextHUDWithText:@"网络失去连接" inView:self.view];
        
    }];
}

- (void)reloadBoxData
{
    [self.tableHeaderView configWithDict:self.dataDict];
    [self.tableView reloadData];
}

- (void)testButtonDidClicked
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"检测中..." inView:self.view];
    
    OneKeyCheckRequest * request = [[OneKeyCheckRequest alloc] initWithBoxID:self.boxID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            __weak typeof(self) weakSelf = self;
            CheckResultView * resultView = [[CheckResultView alloc] initWithResult:result reCheckHandle:^{
                [weakSelf testButtonDidClicked];
            }];
            [resultView show];
        }else{
            [MBProgressHUD showTextHUDWithText:@"配置信息错误" inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"检测失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络连接失败" inView:self.view];
        
    }];
}

- (void)mediaDownLoadButtonDidClicked
{
    NSString * proID = [self.dataDict objectForKey:@"pro_download_period"];
    if (isEmptyString(proID)) {
        [MBProgressHUD showTextHUDWithText:@"没有正在下载的节目" inView:self.view];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    GetDownLoadMediaRequest * request = [[GetDownLoadMediaRequest alloc] initWithMediaProID:proID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSArray * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSArray class]]) {
            DownLoadListViewController * list = [[DownLoadListViewController alloc] initWithDataSource:result];
            [list configType:DownLoadListType_Media mediaDate:proID adDate:nil];
            [self.navigationController pushViewController:list animated:YES];
        }else{
            [MBProgressHUD showTextHUDWithText:@"内容信息为空" inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络连接失败" inView:self.view];
        
    }];
}

- (void)adDownLoadButtonDidClicked
{
    NSString * ADID = [self.dataDict objectForKey:@"ads_download_period"];
    if (isEmptyString(ADID)) {
        [MBProgressHUD showTextHUDWithText:@"没有正在下载的广告" inView:self.view];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    GetDownLoadADRequest * request = [[GetDownLoadADRequest alloc] initWithMediaADID:ADID boxID:self.boxID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSArray * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSArray class]]) {
            DownLoadListViewController * list = [[DownLoadListViewController alloc] initWithDataSource:result];
            [list configType:DownLoadListType_ADs mediaDate:nil adDate:ADID];
            [self.navigationController pushViewController:list animated:YES];
        }else{
            [MBProgressHUD showTextHUDWithText:@"内容信息为空" inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络连接失败" inView:self.view];
        
    }];
}

- (void)pushListButtonDidClicked
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    GetPubProgramRequest * request = [[GetPubProgramRequest alloc] initWithBoxID:self.boxID];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSArray * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSArray class]]) {
            NSString * proID = [self.dataDict objectForKey:@"pro_period"];
            NSString * ADID = [self.dataDict objectForKey:@"ads_period"];
            DownLoadListViewController * list = [[DownLoadListViewController alloc] initWithDataSource:result];
            [list configType:DownLoadListType_PubProgram mediaDate:proID adDate:ADID];
            [self.navigationController pushViewController:list animated:YES];
        }else{
            [MBProgressHUD showTextHUDWithText:@"内容信息为空" inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"网络连接失败" inView:self.view];
        
    }];
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
    
    NSDictionary * dict = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithDict:dict];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38 * kMainBoundsWidth / 375.f;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
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
        
        self.repairBtn = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16 * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"维修" cornerRadius:5 * scale];
        [self.repairBtn addTarget:self action:@selector(clickRepair) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:self.repairBtn];
        [self.repairBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)clickRepair{
    self.repairBtn.userInteractionEnabled = NO;
    self.dUploadModel.userid = [UserManager manager].user.userid;
    self.dUploadModel.hotel_id = self.hotelID;
    self.dUploadModel.type = @"2";
    self.dUploadModel.box_mac = [self.dataDict objectForKey:@"box_mac"];
    
    [self creatMListView];

}

- (void)demageConfigRequest
{
    DamageConfigRequest * request = [[DamageConfigRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSArray *listArray = [dataDict objectForKey:@"list"];
        
        for (int i = 0; i < listArray.count; i ++) {
            RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] initWithDictionary:listArray[i]];
            [self.dConfigData addObject:tmpModel];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
    }];
}

#pragma mark -- 上传维护信息
- (void)damageUploadRequest
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在提交" inView:self.view];
    DamageUploadRequest * request = [[DamageUploadRequest alloc] initWithModel:self.dUploadModel];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        self.submitBtn.userInteractionEnabled = YES;
        self.repairBtn.userInteractionEnabled = YES;
        
        [self dismissViewWithAnimationDuration:.3f];
        self.isRefreh = NO;
        [self cleanDamageModel];
        [MBProgressHUD showTextHUDWithText:@"提交成功" inView:self.view];
        
        [self setupDatas];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        [hud hideAnimated:NO];
        self.submitBtn.userInteractionEnabled = YES;
        self.repairBtn.userInteractionEnabled = YES;
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"提交失败" inView:self.view];
        }
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [hud hideAnimated:NO];
        self.submitBtn.userInteractionEnabled = YES;
        self.repairBtn.userInteractionEnabled = YES;
        [MBProgressHUD showTextHUDWithText:@"提交失败" inView:self.view];
    }];
}

#pragma mark - 弹出维修窗口
- (void)creatMListView{
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.mListView = [[UIView alloc] init];
    self.mListView.tag = 1888;
    self.mListView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.mListView.userInteractionEnabled = YES;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.mListView.bottom = keyWindow.top;
    [self.view addSubview:self.mListView];
    [self.mListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight));
        make.left.right.top.mas_equalTo(0);
    }];
    
    self.sheetBgView = [[UIImageView alloc] init];
    float bgVideoHeight = 330 *scale;
    float bgVideoWidth = 266 *scale;
    self.self.sheetBgView.frame = CGRectZero;
    self.sheetBgView.image = [UIImage imageNamed:@"wj_kong"];
    self.sheetBgView.backgroundColor = [UIColor whiteColor];
    self.sheetBgView.userInteractionEnabled = YES;
    self.sheetBgView.layer.borderColor = UIColorFromRGB(0xf6f2ed).CGColor;
    self.sheetBgView.layer.borderWidth = .5f;
    self.sheetBgView.layer.cornerRadius = 6.f;
    self.sheetBgView.layer.masksToBounds = YES;
    [self.mListView addSubview:self.sheetBgView];
    [self.sheetBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(bgVideoWidth,bgVideoHeight));
        make.center.mas_equalTo(self.mListView);
    }];
    
    UILabel *mTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    mTitleLab.backgroundColor = [UIColor clearColor];
    mTitleLab.font = [UIFont systemFontOfSize:15];
    mTitleLab.textColor = [UIColor blackColor];
    mTitleLab.text = @"维修";
    mTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.sheetBgView addSubview:mTitleLab];
    [mTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 *scale);
        make.centerX.mas_equalTo(self.sheetBgView.centerX);
        make.width.mas_equalTo(bgVideoWidth);
        make.height.mas_equalTo(20 *scale);
    }];
    
    self.unResolvedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.unResolvedBtn setTitle:@"未解决" forState:UIControlStateNormal];
    self.unResolvedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.unResolvedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.unResolvedBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    self.unResolvedBtn.layer.borderWidth = .5f;
    self.unResolvedBtn.layer.cornerRadius = 2.f;
    self.unResolvedBtn.layer.masksToBounds = YES;
    [self.unResolvedBtn addTarget:self action:@selector(unResolveClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:self.unResolvedBtn];
    [self.unResolvedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mTitleLab.mas_bottom).offset(10 *scale);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset( - (10 + 40));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40 *scale);
    }];
    
    self.resolvedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.resolvedBtn setTitle:@"已解决" forState:UIControlStateNormal];
    self.resolvedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.resolvedBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [self.resolvedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.resolvedBtn.layer.borderWidth = .5f;
    self.resolvedBtn.layer.cornerRadius = 2.f;
    self.resolvedBtn.layer.masksToBounds = YES;
    [self.resolvedBtn addTarget:self action:@selector(ResolveClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:self.resolvedBtn];
    [self.resolvedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mTitleLab.mas_bottom).offset(10 *scale);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset( 10 + 40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40 *scale);
    }];
    
    self.mReasonLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mReasonLab.backgroundColor = [UIColor clearColor];
    self.mReasonLab.font = [UIFont systemFontOfSize:14];
    self.mReasonLab.textColor = [UIColor grayColor];
    self.mReasonLab.layer.borderWidth = .5f;
    self.mReasonLab.layer.cornerRadius = 4.f;
    self.mReasonLab.layer.masksToBounds = YES;
    self.mReasonLab.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    self.mReasonLab.text = @"  故障说明与维修记录";
    self.mReasonLab.textAlignment = NSTextAlignmentLeft;
    self.mReasonLab.userInteractionEnabled = YES;
    [self.sheetBgView addSubview:self.mReasonLab];
    [self.mReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.unResolvedBtn.mas_bottom).offset(10 *scale);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(bgVideoWidth - 30);
        make.height.mas_equalTo(30 *scale);
    }];
    
    self.remarkTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.remarkTextView.text = @"备注，限制100字";
    self.remarkTextView.font = [UIFont systemFontOfSize:14];
    self.remarkTextView.textColor = UIColorFromRGB(0xe0dad2);
    self.remarkTextView.textAlignment = NSTextAlignmentLeft;
    self.remarkTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.remarkTextView.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    self.remarkTextView.layer.borderWidth = 1;
    self.remarkTextView.layer.cornerRadius =5;
    self.remarkTextView.keyboardType = UIKeyboardTypeDefault;
    self.remarkTextView.returnKeyType = UIReturnKeyDefault;
    self.remarkTextView.scrollEnabled = YES;
    self.remarkTextView.delegate = self;
    self.remarkTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.sheetBgView addSubview:self.remarkTextView];
    [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mReasonLab.mas_bottom).offset(10 *scale);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(bgVideoWidth - 30);
        make.height.mas_equalTo(130 *scale);
    }];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, CGRectGetMaxY(self.remarkTextView.frame) + 5, 60, 20)];
    self.countLabel.text = @"0/100";
    self.countLabel.textAlignment = NSTextAlignmentRight;
    self.countLabel.font = [UIFont systemFontOfSize:12];
    self.countLabel.backgroundColor = [UIColor clearColor];
    self.countLabel.textColor = [UIColor lightGrayColor];
    self.countLabel.enabled = NO;
    [self.sheetBgView addSubview:self.countLabel];
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkTextView.mas_bottom);
        make.right.mas_equalTo(self.remarkTextView.mas_right);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20 *scale);
    }];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.layer.borderWidth = .5f;
    cancelBtn.layer.cornerRadius = 2.f;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countLabel.mas_bottom).offset(5 *scale);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset(- 50);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30 *scale);
    }];
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.submitBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [self.submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.submitBtn.layer.borderWidth = .5f;
    self.submitBtn.layer.cornerRadius = 2.f;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.countLabel.mas_bottom).offset(5 *scale);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset(50);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30 *scale);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mReasonClicked)];
    tap.numberOfTapsRequired = 1;
    [self.mReasonLab addGestureRecognizer:tap];
    
    UITapGestureRecognizer * mListTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mListClicked)];
    mListTap.numberOfTapsRequired = 1;
    [self.mListView addGestureRecognizer:mListTap];
    
    [self showViewWithAnimationDuration:.3f];
    
}

- (void)ResolveClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.dUploadModel.state = @"1";
        btn.layer.borderWidth = 2.f;
        if (self.unResolvedBtn.selected == YES) {
            self.unResolvedBtn.selected = NO;
            self.unResolvedBtn.layer.borderWidth = .5f;
        }
    }else{
        self.dUploadModel.state = @"";
        btn.layer.borderWidth = .5f;
    }
}

- (void)unResolveClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.dUploadModel.state = @"2";
        btn.layer.borderWidth = 2.f;
        if (self.resolvedBtn.selected == YES) {
            self.resolvedBtn.selected = NO;
            self.resolvedBtn.layer.borderWidth = .5f;
        }
    }else{
        self.dUploadModel.state = @"";
        btn.layer.borderWidth = .5f;
    }
}

#pragma mark - 点击提交按钮
- (void)submitClicked{
    
    self.submitBtn.userInteractionEnabled = NO;
    if ([self.remarkTextView.text isEqualToString:@"备注，限制100字"]) {
        self.dUploadModel.remakr = @"";
    }else{
        self.dUploadModel.remakr = self.remarkTextView.text;
    }
    
    if (isEmptyString(self.dUploadModel.state)) {
        self.submitBtn.userInteractionEnabled = YES;
        [MBProgressHUD showTextHUDWithText:@"请选择是否解决" inView:self.view];
        return;
    }else if (isEmptyString(self.dUploadModel.remakr) && isEmptyString(self.dUploadModel.repair_num_str)){
        self.submitBtn.userInteractionEnabled = YES;
        [MBProgressHUD showTextHUDWithText:@"请填写至少一项内容" inView:self.view];
        return;
    }
    if (self.dUploadModel.remakr.length > 100) {
        self.submitBtn.userInteractionEnabled = YES;
        [MBProgressHUD showTextHUDWithText:@"备注文字超出100字" inView:self.view];
        return;
    }
    [self damageUploadRequest];
}

#pragma mark - 点击取消按钮
- (void)cancelClicked{
    self.repairBtn.userInteractionEnabled = YES;
    [self cleanDamageModel];
    [self dismissViewWithAnimationDuration:.3f];
}

- (void)cleanDamageModel{
    self.dUploadModel.state = @"";
    self.dUploadModel.type = @"";
    self.dUploadModel.remakr = @"";
    self.dUploadModel.repair_num_str = @"";
    for (int i = 0; i < self.dConfigData.count; i ++) {
        RestaurantRankModel *tmpModel = self.dConfigData[i];
        tmpModel.selectType = NO;
    }
}

#pragma mark - 点击故障选择
- (void)mReasonClicked{
    
    FaultListViewController *flVC = [[FaultListViewController alloc] initWithIsFaultList:YES];
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    if (version < 8.0) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    } else {;
        flVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    flVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    flVC.dataSource = self.dConfigData;
    [self presentViewController:flVC animated:YES completion:nil];
    flVC.backDatas = ^(NSArray *backArray,NSString *damageIdString) {
        NSLog(@"%ld",backArray.count);
        if (backArray.count > 0) {
            self.mReasonLab.text = [NSString stringWithFormat:@"  已选择%ld项",backArray.count];
            self.dUploadModel.repair_num_str = damageIdString;
        }else{
            self.mReasonLab.text = @"  故障说明与维修记录";
            self.dUploadModel.repair_num_str = @"";
        }
    };
}

#pragma mark - 点击弹窗页面空白处
- (void)mListClicked{
    
    [self.mListView endEditing:YES];
    [self.sheetBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mListView.centerY).offset(0);
    }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.sheetBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mListView.centerY).offset(- 50);
    }];
    if ([textView.text isEqualToString:@"备注，限制100字"]) {
        self.remarkTextView.textColor = [UIColor grayColor];
        textView.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location < 100)
    {
        return  YES;
    } else  if ([textView.text isEqualToString:@"\n"]) {
        //这里写按了ReturnKey 按钮后的代码
        return NO;
    }
    if (textView.text.length == 100) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%lu",textView.text.length);
    self.countLabel.text = [NSString stringWithFormat:@"%lu/100", textView.text.length];
}

#pragma mark - show view
-(void)showViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        self.mListView.bottom = self.view.bottom;
    } completion:^(BOOL finished) {
    }];
}

-(void)dismissViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        
        self.mListView.bottom = self.view.top;
        
    } completion:^(BOOL finished) {
        
        [self.mListView removeFromSuperview];
        
    }];
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
