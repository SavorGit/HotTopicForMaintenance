//
//  RestaurantRankInforViewController.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RestaurantRankInforViewController.h"
#import "RestaurantRankModel.h"
#import "RepairRecordRankModel.h"
#import "RestaurantRankCell.h"
#import "lookRestaurInforViewController.h"
#import "FaultListViewController.h"
#import "SearchHotelViewController.h"
#import "Helper.h"
#import "RestRankInforRequest.h"
#import "DamageConfigRequest.h"

@interface RestaurantRankInforViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, strong) NSMutableArray * dConfigData; //数据源
@property (nonatomic, copy) NSString * cachePath;

@property (nonatomic, strong) UILabel *rePlatformVerLab;
@property (nonatomic, strong) UILabel *lastPlatformVerLab;
@property (nonatomic, strong) UILabel *lastApkVerLab;
@property (nonatomic, strong) UILabel *positionInforLab;
@property (nonatomic, strong) UIImageView *lastplatDotImg;
@property (nonatomic, strong) UIImageView *lastApkDotImg;

@property (nonatomic, strong) UIView *mListView;
@property (nonatomic, strong) UIImageView *sheetBgView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITextView *remarkTextView;
@property (nonatomic, strong) UILabel *mReasonLab;

@property (nonatomic, strong) UIImageView * topView;
@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) RestaurantRankModel *lastHeartTModel;
@property (nonatomic, strong) RestaurantRankModel *lastSmallModel;

@property (nonatomic , copy) NSString * cid;

@end

@implementation RestaurantRankInforViewController

- (instancetype)initWithDetaiID:(NSString *)detailID
{
    if (self = [super init]) {
        self.cid = detailID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self dataRequest];
    [self demageConfigRequest];
//    [self initData];
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;

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
    _dConfigData = [[NSMutableArray alloc] initWithCapacity:100];
    self.cachePath = [NSString stringWithFormat:@"%@%@.plist", FileCachePath, @"RestaurantRank"];
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    [self autoTitleButtonWith:@"淮阳府(安定门)"];
}

- (void)dataRequest
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在刷新" inView:self.view];
    RestRankInforRequest * request = [[RestRankInforRequest alloc] initWithId:self.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        [self.dataSource removeAllObjects];
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSDictionary *listDict = [dataDict objectForKey:@"list"];
        
        NSDictionary *versionDict = [listDict objectForKey:@"version"];
        NSDictionary *lastHeartTimeDict = [versionDict objectForKey:@"last_heart_time"];
        NSDictionary *lastSmallDict = [versionDict objectForKey:@"last_small"];
        self.lastHeartTModel = [[RestaurantRankModel alloc] initWithDictionary:lastHeartTimeDict];
        self.lastSmallModel = [[RestaurantRankModel alloc] initWithDictionary:lastSmallDict];
        self.lastSmallModel.banwei = [listDict objectForKey:@"banwei"];
        self.lastSmallModel.neSmall = [versionDict objectForKey:@"new_small"];
        
        NSArray *boxInforArr = [listDict objectForKey:@"box_info"];
        
        for (int i = 0; i < boxInforArr.count; i ++) {
            
            NSDictionary *tmpDic = boxInforArr[i];
            RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] initWithDictionary:tmpDic];
            NSArray * listArray = [tmpDic objectForKey:@"repair_record"];
            tmpModel.recordList = [NSMutableArray new];
            for (NSInteger i = 0; i < listArray.count; i++) {
                 RepairRecordRankModel * detailModel = [[RepairRecordRankModel alloc] initWithDictionary:[listArray objectAtIndex:i]];
                [tmpModel.recordList addObject:detailModel];
            }
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

- (void)demageConfigRequest
{
    DamageConfigRequest * request = [[DamageConfigRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.dataSource removeAllObjects];
        
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
            make.top.mas_equalTo(64);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    
    return _tableView;
}

-(void)setUpTableHeaderView{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150)];
    
    self.rePlatformVerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 30, 0)];
    self.rePlatformVerLab.backgroundColor = [UIColor clearColor];
    self.rePlatformVerLab.font = [UIFont systemFontOfSize:14];
    self.rePlatformVerLab.textColor = [UIColor blackColor];
    self.rePlatformVerLab.text = [NSString stringWithFormat:@"发布小平台版本号:%@",self.lastSmallModel.neSmall];
    [headView addSubview:self.rePlatformVerLab];
    [self.rePlatformVerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth/2 - 15);
        make.height.mas_equalTo(20);
    }];
    
    self.lastPlatformVerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 30, 0)];
    self.lastPlatformVerLab.backgroundColor = [UIColor clearColor];
    self.lastPlatformVerLab.font = [UIFont systemFontOfSize:15];
    self.lastPlatformVerLab.textColor = [UIColor blackColor];
    self.lastPlatformVerLab.text = [NSString stringWithFormat:@"最后小平台版本号:%@",self.lastSmallModel.last_small_pla];
    [headView addSubview:self.lastPlatformVerLab];
    [self.lastPlatformVerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rePlatformVerLab.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 15 - 30);
        make.height.mas_equalTo(20);
    }];
    
    //最后小平台版本号标识
    self.lastplatDotImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lastplatDotImg.backgroundColor = [UIColor grayColor];
    self.lastplatDotImg.contentMode = UIViewContentModeScaleAspectFit;
    self.lastplatDotImg.layer.cornerRadius = 20/2.0;
    self.lastplatDotImg.layer.masksToBounds = YES;
    [self.lastplatDotImg setImage:[UIImage imageNamed:@""]];
    [headView addSubview:self.lastplatDotImg];
    [self.lastplatDotImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(self.rePlatformVerLab.mas_bottom).offset(5);
        make.left.mas_equalTo(self.lastPlatformVerLab.mas_right);
    }];
    if (self.lastSmallModel.last_small_state == 0) {
        self.lastplatDotImg.backgroundColor = [UIColor redColor];
    }else{
        self.lastplatDotImg.backgroundColor = [UIColor greenColor];
    }
    
    self.lastApkVerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 30, 0)];
    self.lastApkVerLab.backgroundColor = [UIColor clearColor];
    self.lastApkVerLab.font = [UIFont systemFontOfSize:15];
    self.lastApkVerLab.textColor = [UIColor blackColor];
    self.lastApkVerLab.text = [NSString stringWithFormat:@"小平台最后心跳时间:%@",self.lastHeartTModel.ltime];;
    [headView addSubview:self.lastApkVerLab];
    [self.lastApkVerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lastPlatformVerLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 15 - 30);
        make.height.mas_equalTo(20);
    }];
    
    //最后心跳时间
    self.lastApkDotImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.lastApkDotImg.backgroundColor = [UIColor grayColor];
    self.lastApkDotImg.contentMode = UIViewContentModeScaleAspectFit;
    self.lastApkDotImg.layer.cornerRadius = 20/2.0;
    self.lastApkDotImg.layer.masksToBounds = YES;
    [self.lastApkDotImg setImage:[UIImage imageNamed:@""]];
    [headView addSubview:self.lastApkDotImg];
    [self.lastApkDotImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(self.lastPlatformVerLab.mas_bottom).offset(5);
        make.left.mas_equalTo(self.lastApkVerLab.mas_right);
    }];
    if (self.lastHeartTModel.lstate == 0) {
        self.lastApkDotImg.backgroundColor = [UIColor redColor];
    }else{
        self.lastApkDotImg.backgroundColor = [UIColor greenColor];
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"小平台维修" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.layer.borderWidth = .5f;
    button.layer.cornerRadius = 5.f;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(mPlatformClicked) forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lastApkVerLab.mas_bottom).offset(5);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(20);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xe0dad2);
    [headView addSubview:lineView];
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(button.mas_bottom).offset(5);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(1);
    }];
    
    self.positionInforLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 30, 0)];
    self.positionInforLab.backgroundColor = [UIColor clearColor];
    self.positionInforLab.font = [UIFont boldSystemFontOfSize:16];
    self.positionInforLab.textColor = [UIColor blackColor];
    self.positionInforLab.text = [NSString stringWithFormat:@"%@",self.lastSmallModel.banwei];
    [headView addSubview:self.positionInforLab];
    [self.positionInforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 15);
        make.height.mas_equalTo(20);
    }];
    
    _tableView.tableHeaderView = headView;
}

#pragma mark - 点击小平台维修
- (void)mPlatformClicked{
    
    [self creatMListView];
}

- (UIView *)topView
{
    if (_topView == nil) {
        
        _topView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topView.userInteractionEnabled = YES;
        _topView.contentMode = UIViewContentModeScaleToFill;
        _topView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_topView];
        [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(64);
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(5,20, 40, 44)];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:_backButton];
        
        UIButton *shareBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [shareBtn setImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateNormal];
        [shareBtn setImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateSelected];
        shareBtn.tag = 101;
        [shareBtn addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 44));
            make.top.mas_equalTo(20);
            make.right.mas_equalTo(- 15);
        }];
    }
    return _topView;
}

- (void)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatMListView{
    
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
    
    [self showViewWithAnimationDuration:.3f];

    
    self.sheetBgView = [[UIImageView alloc] init];
    float bgVideoHeight = [Helper autoHeightWith:320];
    float bgVideoWidth = [Helper autoWidthWith:266];
    self.self.sheetBgView.frame = CGRectZero;
    self.sheetBgView.image = [UIImage imageNamed:@"wj_kong"];
    self.sheetBgView.backgroundColor = [UIColor whiteColor];
    self.sheetBgView.userInteractionEnabled = YES;
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
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.sheetBgView.centerX);
        make.width.mas_equalTo(bgVideoWidth);
        make.height.mas_equalTo(20);
    }];
    
    UIButton * unResolvedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [unResolvedBtn setTitle:@"未解决" forState:UIControlStateNormal];
    unResolvedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    unResolvedBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [unResolvedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    unResolvedBtn.layer.borderWidth = .5f;
    unResolvedBtn.layer.cornerRadius = 2.f;
    unResolvedBtn.layer.masksToBounds = YES;
    [unResolvedBtn addTarget:self action:@selector(unResolveClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:unResolvedBtn];
    [unResolvedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mTitleLab.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset( - (10 + 40));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    UIButton * resolvedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [resolvedBtn setTitle:@"已解决" forState:UIControlStateNormal];
    resolvedBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    resolvedBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [resolvedBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    resolvedBtn.layer.borderWidth = .5f;
    resolvedBtn.layer.cornerRadius = 2.f;
    resolvedBtn.layer.masksToBounds = YES;
    [resolvedBtn addTarget:self action:@selector(ResolveClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:resolvedBtn];
    [resolvedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mTitleLab.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset( 10 + 40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
    
    self.mReasonLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mReasonLab.backgroundColor = [UIColor clearColor];
    self.mReasonLab.font = [UIFont systemFontOfSize:14];
    self.mReasonLab.textColor = [UIColor blackColor];
    self.mReasonLab.layer.borderWidth = .5f;
    self.mReasonLab.layer.cornerRadius = 4.f;
    self.mReasonLab.layer.masksToBounds = YES;
    self.mReasonLab.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    self.mReasonLab.text = @"故障原因";
    self.mReasonLab.textAlignment = NSTextAlignmentCenter;
    self.mReasonLab.userInteractionEnabled = YES;
    [self.sheetBgView addSubview:self.mReasonLab];
    [self.mReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(unResolvedBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(bgVideoWidth - 30);
        make.height.mas_equalTo(30);
    }];
    
    self.remarkTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.remarkTextView.text = @"限制100字以内";
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
        make.top.mas_equalTo(self.mReasonLab.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(bgVideoWidth - 30);
        make.height.mas_equalTo(130);
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
        make.height.mas_equalTo(20);
    }];
    
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    submitBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    submitBtn.layer.borderWidth = .5f;
    submitBtn.layer.cornerRadius = 2.f;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkTextView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.sheetBgView.centerX);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mReasonClicked)];
    tap.numberOfTapsRequired = 1;
    [self.mReasonLab addGestureRecognizer:tap];
    
    UITapGestureRecognizer * mListTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mListClicked)];
    mListTap.numberOfTapsRequired = 1;
    [self.mListView addGestureRecognizer:mListTap];
    
}

#pragma mark - 点击提交按钮
- (void)submitClicked{
    
      [self dismissViewWithAnimationDuration:.3f];
}

#pragma mark - 点击故障选择
- (void)mReasonClicked{
    
    FaultListViewController *flVC = [[FaultListViewController alloc] init];
    float version = [UIDevice currentDevice].systemVersion.floatValue;
    if (version < 8.0) {
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
    } else {;
        flVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    flVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    flVC.sourceData = self.dConfigData;
    [self presentViewController:flVC animated:YES completion:nil];
    flVC.backDatas = ^(NSString *str1) {
        NSLog(@"%@",str1);
        self.mReasonLab.text = str1;
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
    
    if ([textView.text isEqualToString:@"限制100字以内"]) {
        self.remarkTextView.textColor = [UIColor blackColor];
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
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.mListView.bottom = self.view.bottom;
    } completion:^(BOOL finished) {
    }];
}

-(void)dismissViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.mListView.bottom = self.view.top;
        
    } completion:^(BOOL finished) {
        
        [self.mListView removeFromSuperview];
        
    }];
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
    RestaurantRankCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[RestaurantRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell configWithModel:model];
    
    cell.btnClick = ^(RestaurantRankModel *tmpModel){
        
        [self creatMListView];
        NSLog(@"---维修---");
    };
    return cell;
   
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)autoTitleButtonWith:(NSString *)title
{
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setTintColor:UIColorFromRGB(0xece6de)];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
    titleButton.imageView.contentMode = UIViewContentModeCenter;
    
    CGFloat maxWidth = kMainBoundsWidth - 150;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    if (size.width > maxWidth) {
        size.width = maxWidth;
    }
    [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width + 15, 0, 0)];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10 + 10)];
    
    [titleButton setTitle:title forState:UIControlStateNormal];
    [self.topView addSubview:titleButton];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.centerX.mas_equalTo(self.topView.centerX);
        make.width.mas_equalTo(size.width + 30);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - 点击查看酒楼信息
- (void)titleButtonDidBeClicked{
    
    lookRestaurInforViewController *lrVC = [[lookRestaurInforViewController alloc] initWithDetaiID:self.cid];
    [self.navigationController pushViewController:lrVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - 点击刷新页面
- (void)refreshAction{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end