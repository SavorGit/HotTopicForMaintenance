//
//  SingleVRankInforViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/12/18.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SingleVRankInforViewController.h"
#import "RestaurantRankModel.h"
#import "RepairRecordRankModel.h"
#import "DamageUploadModel.h"
#import "SingleVRestaurantRankCell.h"
#import "lookRestaurInforViewController.h"
#import "FaultListViewController.h"
#import "SearchHotelViewController.h"
#import "Helper.h"
#import "SingleGetHotelVRequest.h"
#import "SingleDemageListRequest.h"
#import "SingleRepairAndSignRequest.h"
#import "UserManager.h"
#import "RDFrequentlyUsed.h"
#import "HotTopicTools.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface SingleVRankInforViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, strong) NSMutableArray * dConfigData; //数据源
@property (nonatomic, strong) NSMutableArray * repairPData; //数据源
@property (nonatomic, copy) NSString * cachePath;
@property (nonatomic, copy) NSString * imgFileName;

@property (nonatomic, strong) UILabel *positionInforLab;

@property (nonatomic, strong) UIView *mListView;
@property (nonatomic, strong) UIImageView *sheetBgView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UITextView *remarkTextView;
@property (nonatomic, strong) UILabel *mReasonLab;
@property (nonatomic, strong) UIImageView *addImageView;

@property (nonatomic, strong) UIButton *collectBtn;
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) RestaurantRankModel *lastHeartTModel;
@property (nonatomic, strong) RestaurantRankModel *lastSmallModel;

@property (nonatomic, strong) DamageUploadModel *dUploadModel;
@property (nonatomic, strong) UIButton * submitBtn;

@property (nonatomic, assign) BOOL isRefreh;


@property (nonatomic , copy) NSString * cid;
@property (nonatomic , copy) NSString * hotelName;//酒店名称

@end

@implementation SingleVRankInforViewController

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
    
    _dataSource = [[NSMutableArray alloc] init];
    _dConfigData = [[NSMutableArray alloc] init];
    _repairPData = [[NSMutableArray alloc] init];
    self.cachePath = [NSString stringWithFormat:@"%@%@.plist", FileCachePath, @"RestaurantRank"];
    self.imgFileName = [[NSString alloc] init];
    self.dUploadModel = [[DamageUploadModel alloc] init];
    self.isRefreh = NO;
    
    [self autoTitleButtonWith:self.hotelName];
}

- (void)dataRequest
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在刷新" inView:self.view];
    SingleGetHotelVRequest * request = [[SingleGetHotelVRequest alloc] initWithHotelId:self.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        [self.dataSource removeAllObjects];
        [self.repairPData removeAllObjects];
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSDictionary *listDict = [dataDict objectForKey:@"list"];
        
        self.lastSmallModel = [[RestaurantRankModel alloc] init];
        self.lastSmallModel.banwei = [listDict objectForKey:@"banwei"];
        NSArray *boxInforArr = [listDict objectForKey:@"box_info"];
        
        for (int i = 0; i < boxInforArr.count; i ++) {
            
            NSDictionary *tmpDic = boxInforArr[i];
            RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] initWithDictionary:tmpDic];
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
    SingleDemageListRequest * request = [[SingleDemageListRequest alloc] init];
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

- (void)upImageData{
    
    if (self.addImageView.image != nil) {

        NSString * title = [NSString stringWithFormat:@"上传图片%%0"];
        MBProgressHUD * hud =  [MBProgressHUD showLoadingHUDWithText:title buttonTitle:@"取消" inView:self.view target:self action:@selector(cancelOSSTask)];
        
        [HotTopicTools uploadImage:self.addImageView.image withImageName:self.imgFileName progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat progress = (CGFloat)totalBytesSent / (CGFloat)totalBytesExpectedToSend;
                NSString * currentTitle = [NSString stringWithFormat:@"上传图片%%%.2f", progress];
                hud.label.text = currentTitle;
            });
            
        } success:^(NSString *path ) {
            self.dUploadModel.imgUrl = path;
            self.dUploadModel.srtype = @"2";
            self.dUploadModel.current_location = [UserManager manager].locationName;
            [self damageUploadRequest];
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.submitBtn.userInteractionEnabled = YES;
                [MBProgressHUD showTextHUDWithText:@"图片上传失败" inView:self.view];
                [hud hideAnimated:YES];
            });
        }];
    }else{
        self.submitBtn.userInteractionEnabled = YES;
        [MBProgressHUD showTextHUDWithText:@"请选择一张照片" inView:self.view];
        
    }
}
#pragma mark -- 上传维护信息
- (void)damageUploadRequest;
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在提交" inView:self.view];
    SingleRepairAndSignRequest * request = [[SingleRepairAndSignRequest alloc] initWithModel:self.dUploadModel];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        self.submitBtn.userInteractionEnabled = YES;
        
        NSInteger code = [response[@"code"] integerValue];
        NSString *msg = response[@"msg"];
        if (code == 10000) {
            if ([self.dUploadModel.srtype integerValue] == 1) {
                [MBProgressHUD showTextHUDWithText:@"签到成功" inView:self.view];
            }else{
                [self dismissViewWithAnimationDuration:.3f];
                [MBProgressHUD showTextHUDWithText:@"提交成功" inView:self.view];
            }
            self.isRefreh = NO;
            [self cleanDamageModel];
            [self dataRequest];
            
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
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    
    return _tableView;
}

-(void)setUpTableHeaderView{
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    
    self.positionInforLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 30, 0)];
    self.positionInforLab.backgroundColor = [UIColor clearColor];
    self.positionInforLab.font = [UIFont boldSystemFontOfSize:16];
    self.positionInforLab.textColor = [UIColor blackColor];
    self.positionInforLab.text = [NSString stringWithFormat:@"%@",self.lastSmallModel.banwei];
    [headView addSubview:self.positionInforLab];
    [self.positionInforLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 15);
        make.height.mas_equalTo(30);
    }];
    headView.backgroundColor = UIColorFromRGB(0xffffff);
    _tableView.tableHeaderView = headView;
}

#pragma mark - 弹出维修窗口
- (void)creatMListView{
    
    CGFloat scale = kMainBoundsWidth/375.f;
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
    float bgVideoHeight = (320 + 90) *scale;
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
    mTitleLab.text = @"报修";
    mTitleLab.textAlignment = NSTextAlignmentCenter;
    [self.sheetBgView addSubview:mTitleLab];
    [mTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 *scale);
        make.centerX.mas_equalTo(self.sheetBgView.centerX);
        make.width.mas_equalTo(bgVideoWidth);
        make.height.mas_equalTo(20 *scale);
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
        make.top.mas_equalTo(mTitleLab.mas_bottom).offset(10 *scale);
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
    
    UIButton * addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addImgBtn setTitle:@"选择图片" forState:UIControlStateNormal];
    addImgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    addImgBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [addImgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    addImgBtn.layer.borderWidth = .5f;
    addImgBtn.layer.cornerRadius = 2.f;
    addImgBtn.layer.masksToBounds = YES;
    [addImgBtn addTarget:self action:@selector(addImgClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:addImgBtn];
    [addImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkTextView.mas_bottom).offset(15 *scale);
        make.centerX.mas_equalTo(self.sheetBgView.centerX);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30 *scale);
    }];
    
    self.addImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.addImageView.backgroundColor = [UIColor clearColor];
    self.addImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.sheetBgView addSubview:self.addImageView];
    [self.addImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80 *scale , 80 *scale));
        make.top.mas_equalTo(addImgBtn.mas_bottom).offset(10 *scale);
        make.centerX.mas_equalTo(self.sheetBgView.centerX);
    }];
    self.addImageView.image = [UIImage imageNamed:@"zanwu"];
    
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
        make.top.mas_equalTo(self.addImageView.mas_bottom).offset(15 *scale);
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
        make.top.mas_equalTo(self.addImageView.mas_bottom).offset(15 *scale);
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

- (void)addImgClicked{
    
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = YES;
    }
    
    [self selectImageFromAlbum];
}

#pragma mark - 点击提交按钮
- (void)submitClicked{
    
    self.submitBtn.userInteractionEnabled = NO;
    if ([self.remarkTextView.text isEqualToString:@"备注，限制100字"]) {
        self.dUploadModel.remakr = @"";
    }else{
        self.dUploadModel.remakr = self.remarkTextView.text;
    }
    
    if (isEmptyString(self.dUploadModel.remakr) && isEmptyString(self.dUploadModel.repair_num_str)){
        self.submitBtn.userInteractionEnabled = YES;
        [MBProgressHUD showTextHUDWithText:@"请填写至少一项内容" inView:self.view];
        return;
    }
    if (self.dUploadModel.remakr.length > 100) {
        self.submitBtn.userInteractionEnabled = YES;
        [MBProgressHUD showTextHUDWithText:@"备注文字超出100字" inView:self.view];
        return;
    }
    [self upImageData];
}

#pragma mark - 点击取消按钮
- (void)cancelClicked{
    [self cleanDamageModel];
    [self dismissViewWithAnimationDuration:.3f];
}

- (void)cleanDamageModel{
    self.dUploadModel.remakr = @"";
    self.dUploadModel.repair_num_str = @"";
    self.dUploadModel.srtype = @"";
    self.dUploadModel.imgUrl = @"";
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
    SingleVRestaurantRankCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SingleVRestaurantRankCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell configWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.btnClick = ^(RestaurantRankModel *tmpModel){
        
        weakSelf.dUploadModel.userid = [UserManager manager].user.userid;
        weakSelf.dUploadModel.hotel_id = self.cid;
        weakSelf.dUploadModel.box_mac = tmpModel.mac;
        weakSelf.dUploadModel.bid = tmpModel.bid;
        
        [weakSelf creatMListView];
    };
    
    cell.singleBtnClick = ^(RestaurantRankModel *tmpModel){
        
        weakSelf.dUploadModel.userid = [UserManager manager].user.userid;
        weakSelf.dUploadModel.hotel_id = self.cid;
        weakSelf.dUploadModel.bid = tmpModel.bid;
        weakSelf.dUploadModel.srtype = @"1";
        weakSelf.dUploadModel.current_location = [UserManager manager].locationName;
        weakSelf.dUploadModel.remakr = @"";
        weakSelf.dUploadModel.imgUrl = @"";
        weakSelf.dUploadModel.repair_num_str  = @"";
        
        [self damageUploadRequest];
    };
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   RestaurantRankModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
//    //维修记录的高度
//    float reConHeight;
//    if (tmpModel.recordList.count > 0) {
//        reConHeight = tmpModel.recordList.count *17;
//    }else{
//        reConHeight = 17;
//    }
    float reContentHeight;
    if ([self getHeightByWidth:kMainBoundsWidth - 20 - 15 - 15 - 90 title:tmpModel.current_location font:[UIFont systemFontOfSize:14]] > 17) {
        reContentHeight = 35;
    }else{
        reContentHeight = 17;
    }
    return 102 + 40 + reContentHeight;
}

- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

- (void)autoTitleButtonWith:(NSString *)title
{
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    titleButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [titleButton setTitleColor:kNavTitleColor forState:UIControlStateNormal];
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
    
    titleButton.frame = CGRectMake(0, 0, size.width + 30, 30);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = kNavTitleColor;
    [titleButton addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(titleButton.mas_bottom).offset(-0.5);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    self.navigationItem.titleView = titleButton;
    
    UIButton * refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    refreshButton.frame = CGRectMake(0, 0, 40, 30);
    [refreshButton addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
}

#pragma mark - 点击查看酒楼信息
- (void)titleButtonDidBeClicked{
    
    lookRestaurInforViewController *lrVC = [[lookRestaurInforViewController alloc] initWithDetaiID:self.cid WithHotelNam:self.hotelName];
    [self.navigationController pushViewController:lrVC animated:YES];
    
}

#pragma mark - 点击刷新页面
- (void)refreshAction{
    
    self.isRefreh = YES;
    [self dataRequest];
    
}


#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [_imagePickerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    self.addImageView.image = image;
    
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        self.addImageView.image = info[UIImagePickerControllerEditedImage];
        if (self.addImageView.image !=nil) {
            //获取图片的名字
            __block NSString* imageFileName;
            NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
            ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
            {
                ALAssetRepresentation *representation = [myasset defaultRepresentation];
                imageFileName = [representation filename];
                NSArray *strArray = [imageFileName componentsSeparatedByString:@"."];
                if (strArray.count > 0) {
                    self.imgFileName = strArray[0];
                }
                
            };
            
            ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];

            [assetslibrary assetForURL:imageURL

                           resultBlock:resultblock

                          failureBlock:nil];
            
        }

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc
{
    [SingleGetHotelVRequest cancelRequest];
    [SingleDemageListRequest cancelRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
