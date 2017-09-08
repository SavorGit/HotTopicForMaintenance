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
#import "DamageUploadModel.h"
#import "RestaurantRankCell.h"
#import "lookRestaurInforViewController.h"
#import "FaultListViewController.h"
#import "SearchHotelViewController.h"
#import "Helper.h"
#import "RestRankInforRequest.h"
#import "DamageConfigRequest.h"
#import "DamageUploadRequest.h"
#import "UserManager.h"

@interface RestaurantRankInforViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, strong) NSMutableArray * dConfigData; //数据源
@property (nonatomic, strong) NSMutableArray * repairPData; //数据源
@property (nonatomic, copy) NSString * cachePath;

@property (nonatomic, strong) UILabel *rePlatformVerLab;
@property (nonatomic, strong) UILabel *lastPlatformVerLab;
@property (nonatomic, strong) UILabel *lastApkVerLab;
@property (nonatomic, strong) UILabel *positionInforLab;
@property (nonatomic, strong) UIImageView *lastplatDotImg;
@property (nonatomic, strong) UIImageView *lastApkDotImg;
@property (nonatomic, strong) UILabel *mRecordLabel;
@property (nonatomic, strong) UILabel *mReContentLabel;

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

@property (nonatomic, strong) DamageUploadModel *dUploadModel;

@property (nonatomic, strong) UIButton * unResolvedBtn;
@property (nonatomic, strong) UIButton * resolvedBtn;
@property (nonatomic, strong) UIButton * submitBtn;

@property (nonatomic, assign) BOOL isRefreh;


@property (nonatomic , copy) NSString * cid;
@property (nonatomic , copy) NSString * hotelName;//酒店名称

@end

@implementation RestaurantRankInforViewController

- (instancetype)initWithDetaiID:(NSString *)detailID WithHotelNam:(NSString *)hotelName
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
    [self demageConfigRequest];
    
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}

- (void)initInfo{
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
    _dConfigData = [[NSMutableArray alloc] initWithCapacity:100];
    _repairPData = [[NSMutableArray alloc] initWithCapacity:100];
    self.cachePath = [NSString stringWithFormat:@"%@%@.plist", FileCachePath, @"RestaurantRank"];
    self.dUploadModel = [[DamageUploadModel alloc] init];
    self.isRefreh = NO;
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(64);
    }];
    [self autoTitleButtonWith:self.hotelName];
}

- (void)dataRequest
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在刷新" inView:self.view];
    RestRankInforRequest * request = [[RestRankInforRequest alloc] initWithId:self.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        [self.dataSource removeAllObjects];
        [self.repairPData removeAllObjects];
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSDictionary *listDict = [dataDict objectForKey:@"list"];
        
        NSDictionary *versionDict = [listDict objectForKey:@"version"];
        NSDictionary *lastHeartTimeDict = [versionDict objectForKey:@"last_heart_time"];
        NSDictionary *lastSmallDict = [versionDict objectForKey:@"last_small"];
        self.lastHeartTModel = [[RestaurantRankModel alloc] initWithDictionary:lastHeartTimeDict];
        self.lastSmallModel = [[RestaurantRankModel alloc] initWithDictionary:lastSmallDict];
        self.lastSmallModel.banwei = [listDict objectForKey:@"banwei"];
        self.lastSmallModel.neSmall = [versionDict objectForKey:@"new_small"];
        self.lastSmallModel.small_mac = [versionDict objectForKey:@"small_mac"];
        NSArray *boxInforArr = [listDict objectForKey:@"box_info"];
        
        NSArray *repair_recordArr = [versionDict objectForKey:@"repair_record"];//头部小平台维修记录
        for (int i = 0 ; i < repair_recordArr.count; i ++) {
            
            RepairRecordRankModel * detailModel = [[RepairRecordRankModel alloc] initWithDictionary:[repair_recordArr objectAtIndex:i]];
            [_repairPData addObject:detailModel];
            
        }
        
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
        
        if (self.isRefreh == YES) {
            [MBProgressHUD showTextHUDWithText:@"刷新成功" inView:self.view];
        }
        
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
        
        NSInteger code = [response[@"code"] integerValue];
        NSString *msg = response[@"msg"];
        if (code == 10000) {
            [self dismissViewWithAnimationDuration:.3f];
            self.isRefreh = NO;
            [self cleanDamageModel];
            [self dataRequest];
            [MBProgressHUD showTextHUDWithText:@"提交成功" inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:msg inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        [hud hideAnimated:NO];
        self.submitBtn.userInteractionEnabled = YES;
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"提交失败" inView:self.view];
        }
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [hud hideAnimated:NO];
        self.submitBtn.userInteractionEnabled = YES;
        [MBProgressHUD showTextHUDWithText:@"提交失败" inView:self.view];
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
    self.rePlatformVerLab.font = [UIFont systemFontOfSize:13];
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
    self.lastPlatformVerLab.font = [UIFont systemFontOfSize:14];
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
    self.lastApkVerLab.font = [UIFont systemFontOfSize:14];
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
    
    self.mRecordLabel = [[UILabel alloc]init];
    self.mRecordLabel.font = [UIFont systemFontOfSize:14];
    self.mRecordLabel.textColor = [UIColor blackColor];
    self.mRecordLabel.textAlignment = NSTextAlignmentLeft;
    self.mRecordLabel.text = @"维修记录:";
    [headView addSubview:self.mRecordLabel];
    [self.mRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 17));
        make.top.mas_equalTo(self.lastApkVerLab.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
    }];

    self.mReContentLabel = [[UILabel alloc]init];
    self.mReContentLabel.font = [UIFont systemFontOfSize:14];
    self.mReContentLabel.textColor = [UIColor blackColor];
    self.mReContentLabel.textAlignment = NSTextAlignmentLeft;
    self.mReContentLabel.numberOfLines = 0;
    self.mReContentLabel.text = @"维修记录内容";
    [headView addSubview:self.mReContentLabel];
    [self.mReContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30 - 65 - 130, 17));
        make.top.mas_equalTo(self.lastApkVerLab.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mRecordLabel.mas_right).offset(5);
    }];
    
    if (self.repairPData.count > 0) {
        
        NSMutableString *mReConString = [[NSMutableString alloc] init];
        for (int i = 0; i < self.repairPData.count; i ++) {
            RepairRecordRankModel *tmpModel = [self.repairPData objectAtIndex:i];
            [mReConString appendString:[NSString stringWithFormat:@"\n%@  (%@)",tmpModel.ctime,tmpModel.nickname]];
        }
        [mReConString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        
        float reConHeight;//维修记录的高度
        reConHeight = self.repairPData.count *17;
        [self.mReContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(reConHeight);
        }];
        headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 135 + reConHeight);
        self.mReContentLabel.text = mReConString;
        
    }else{
        [self.mReContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(17);
        }];
        headView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 150);
        self.mReContentLabel.text = @"无";
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
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(20);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xe0dad2);
    [headView addSubview:lineView];
    [lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mReContentLabel.mas_bottom).offset(5);
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
    
    self.dUploadModel.userid = [UserManager manager].user.userid;
    self.dUploadModel.hotel_id = self.cid;
    self.dUploadModel.type = @"1";
    self.dUploadModel.box_mac = self.lastSmallModel.small_mac;;
    
    [self creatMListView];
}

#pragma mark - 自定义导航栏视图
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
        
        UIButton * refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [refreshButton setBackgroundImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
        [_topView addSubview:refreshButton];
        [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20 + 8.5);
            make.right.mas_equalTo(-18);
            make.width.height.mas_equalTo(23);
        }];
        [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [_topView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_topView.mas_bottom).offset(-0.5);
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(kMainBoundsWidth);
            make.height.mas_equalTo(0.5);
        }];
    }
    return _topView;
}

- (void)backButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 弹出维修窗口
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
    
    self.sheetBgView = [[UIImageView alloc] init];
    float bgVideoHeight = [Helper autoHeightWith:320];
    float bgVideoWidth = [Helper autoWidthWith:266];
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
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.sheetBgView.centerX);
        make.width.mas_equalTo(bgVideoWidth);
        make.height.mas_equalTo(20);
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
        make.top.mas_equalTo(mTitleLab.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset( - (10 + 40));
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
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
        make.top.mas_equalTo(mTitleLab.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset( 10 + 40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
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
        make.top.mas_equalTo(self.unResolvedBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(bgVideoWidth - 30);
        make.height.mas_equalTo(30);
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
        make.top.mas_equalTo(self.remarkTextView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset(- 50);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
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
        make.top.mas_equalTo(self.remarkTextView.mas_bottom).offset(15);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset(50);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
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
    
    FaultListViewController *flVC = [[FaultListViewController alloc] init];
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
        
        self.dUploadModel.userid = [UserManager manager].user.userid;
        self.dUploadModel.hotel_id = self.cid;
        self.dUploadModel.type = @"2";
        self.dUploadModel.box_mac = tmpModel.mac;
        
        [self creatMListView];
        NSLog(@"---维修---");
    };
    return cell;
   
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantRankModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
    //维修记录的高度
    float reConHeight;
    if (tmpModel.recordList.count > 0) {
        reConHeight = tmpModel.recordList.count *17;
    }else{
        reConHeight = 17;
    }
    return 97 + reConHeight;
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
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [titleButton setTitle:title forState:UIControlStateNormal];
    [self.topView addSubview:titleButton];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 + 9);
        make.centerX.mas_equalTo(self.topView.centerX);
        make.width.mas_equalTo(size.width + 30);
        make.height.mas_equalTo(26);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [titleButton addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(titleButton.mas_bottom).offset(-0.5);
        make.centerX.mas_equalTo(titleButton.centerX);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - 点击查看酒楼信息
- (void)titleButtonDidBeClicked{
    
    lookRestaurInforViewController *lrVC = [[lookRestaurInforViewController alloc] initWithDetaiID:self.cid WithHotelNam:self.hotelName];
    [self.navigationController pushViewController:lrVC animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - 点击刷新页面
- (void)refreshAction{
    
    self.isRefreh = YES;
    [self dataRequest];
    
}

- (void)dealloc
{
    [RestRankInforRequest cancelRequest];
    [DamageConfigRequest cancelRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
