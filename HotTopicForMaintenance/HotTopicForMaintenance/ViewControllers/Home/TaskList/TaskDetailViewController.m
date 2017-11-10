//
//  TaskDetailViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TaskDetailView.h"
#import "DeviceFaultModel.h"
#import "DeviceFaultTableViewCell.h"
#import "HotTopicTools.h"
#import "UserManager.h"
#import "AssignViewController.h"
#import "RDTextView.h"
#import "Helper.h"
#import "InstallProAlertView.h"
#import "TaskListDetailRequest.h"
#import "TaskRepairAlertModel.h"
#import "GetBoxListRequest.h"
#import "RestaurantRankModel.h"
#import "PositionListViewController.h"
#import "RefuseRequest.h"
#import "DeviceManager.h"
#import "SubmitTaskRequest.h"
#import "BoxDataRequest.h"
#import "NSArray+json.h"
#import "InstallAlerTableViewCell.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "RepairDetailCell.h"
#import "CheckDetailCell.h"
#import "NetworkDetailCell.h"
#import "InstallDetailCell.h"

@interface TaskDetailViewController ()<UITableViewDelegate, UITableViewDataSource,InstallProAlertDelegate,UITextViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) TaskModel * tempModel;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * executeSource;
@property (nonatomic, strong) NSMutableArray * dConfigData; //版位选择信息
@property (nonatomic, strong) NSMutableArray * subMitPosionArray; //提交维修信息
@property (nonatomic, strong) TaskModel * taskListModel;

@property (nonatomic, assign) BOOL hasNotification;
@property (nonatomic, assign) BOOL hasSearchHotel;

@property (nonatomic, strong) UIView *mListView;
@property (nonatomic, strong) UIImageView *sheetBgView;
@property (nonatomic, strong) UITextView *remarkTextView;
@property (nonatomic, strong) UILabel *mReasonLab;
@property (nonatomic, strong) UIButton * unResolvedBtn;
@property (nonatomic, strong) UIButton * resolvedBtn;
@property (nonatomic, strong) UIButton * submitBtn;
@property (nonatomic, strong) TaskRepairAlertModel *repairAlertModel;
@property (nonatomic, assign) NSInteger selectImgTag;
@property (nonatomic, strong) NSIndexPath *selectImgIndex;
@property (nonatomic, assign) NSInteger totalAlertCount;
@property (nonatomic, copy) NSString * currentBoxId;

@property (nonatomic, strong) InstallProAlertView *inPAlertView;

@property (nonatomic, strong) UIView * bottomView;

//点击拒绝的弹窗
@property (nonatomic, strong) UIView * refuseView;
@property (nonatomic, strong) RDTextView * refuseTextView;

@property (nonatomic, copy) NSString * hotelID;

@end

@implementation TaskDetailViewController

- (instancetype)initWithTaskModel:(TaskModel *)model
{
    if (self = [super init]) {
        self.tempModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"任务详情";
    self.repairAlertModel = [[TaskRepairAlertModel alloc] init];
    self.executeSource = [[NSMutableArray alloc] init];
    self.dConfigData = [[NSMutableArray alloc] init];
    self.subMitPosionArray = [[NSMutableArray alloc] init];
    self.currentBoxId = [[NSString alloc] init];
    [self setupDatas];
}

- (void)removeNotification
{
    if (self.hasNotification) {
        self.hasNotification = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:RDTaskStatusDidChangeNotification object:nil];
    }
}

- (void)addNotification
{
    if (!self.hasNotification) {
        self.hasNotification = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskStatusDidChange) name:RDTaskStatusDidChangeNotification object:nil];
    }
}

- (void)taskStatusDidChange
{
    [self.navigationController popViewControllerAnimated:YES];
    
    [self.bottomView removeAllSubviews];
    [self.bottomView removeFromSuperview];
    [self.tableView removeFromSuperview];
    
    [self setupDatas];
}

- (void)setupViews
{
    //tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.tableView registerClass:[DeviceFaultTableViewCell class] forCellReuseIdentifier:@"DeviceFaultTableViewCell"];
    self.tableView.backgroundColor = VCBackgroundColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.taskListModel.state_id == TaskStatusType_Completed) {
        if (self.taskListModel.task_type_id == TaskType_Repair) {
            [self.tableView registerClass:[RepairDetailCell class] forCellReuseIdentifier:@"RepairDetailCell"];
        }else if (self.taskListModel.task_type_id == TaskType_InfoCheck) {
            [self.tableView registerClass:[CheckDetailCell class] forCellReuseIdentifier:@"CheckDetailCell"];
        }else if (self.taskListModel.task_type_id == TaskType_NetTransform) {
            [self.tableView registerClass:[NetworkDetailCell class] forCellReuseIdentifier:@"NetworkDetailCell"];
        }else if (self.taskListModel.task_type_id == TaskType_Install) {
            [self.tableView registerClass:[InstallDetailCell class] forCellReuseIdentifier:@"InstallDetailCell"];
            
        }
    }
    
    TaskDetailView * view = [[TaskDetailView alloc] initWithTaskModel:self.taskListModel];
    self.tableView.tableHeaderView = view;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    if (self.taskListModel.state_id == TaskStatusType_WaitAssign ||
        self.taskListModel.state_id == TaskStatusType_WaitHandle) {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 98.f * scale)];
    }
    
    //底部角色操作栏
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(58.f * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor =UIColorFromRGB(0xf5f5f5);
    [self.bottomView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1.f);
    }];
    
    [self addNotification];
    
    [self createRolesHandleView];
}

- (void)createRolesHandleView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    switch ([UserManager manager].user.roletype) {
        case UserRoleType_AssignTask:
            
        {
            if (self.taskListModel.state_id == TaskStatusType_WaitAssign) {
                UIButton * assignButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"去指派" cornerRadius:5.f];
                [assignButton addTarget:self action:@selector(assignButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.bottomView addSubview:assignButton];
                [assignButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(15.f * scale);
                    make.width.mas_equalTo(225.f * scale);
                    make.height.mas_equalTo(44.f * scale);
                }];
                
                UIButton * refuseButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) backgroundColor:UIColorFromRGB(0xf54444) title:@"拒绝" cornerRadius:5.f];
                [refuseButton addTarget:self action:@selector(refuseButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.bottomView addSubview:refuseButton];
                [refuseButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.right.mas_equalTo(-15.f * scale);
                    make.width.mas_equalTo(110.f * scale);
                    make.height.mas_equalTo(44.f * scale);
                }];
            }else{
                [self.bottomView removeFromSuperview];
            }
        }
            
            break;
            
        case UserRoleType_HandleTask:
        {
            [self addSearchHotelNotification];
            if (self.taskListModel.state_id == TaskStatusType_WaitHandle) {
                if (self.taskListModel.task_type_id == TaskType_Repair) {
                    UIButton * repairButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"维修" cornerRadius:5.f];
                    [repairButton addTarget:self action:@selector(repairButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.bottomView addSubview:repairButton];
                    [repairButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(0);
                        make.left.mas_equalTo(15.f * scale);
                        make.right.mas_equalTo(-15.f * scale);
                        make.height.mas_equalTo(44.f * scale);
                    }];
                }else if (self.taskListModel.task_type_id == TaskType_Install) {
                    UIButton * installButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"安装验收" cornerRadius:5.f];
                    [installButton addTarget:self action:@selector(installButtonButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.bottomView addSubview:installButton];
                    [installButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(0);
                        make.left.mas_equalTo(15.f * scale);
                        make.right.mas_equalTo(-15.f * scale);
                        make.height.mas_equalTo(44.f * scale);
                    }];
                }else if (self.taskListModel.task_type_id == TaskType_NetTransform) {
                    UIButton * netWorkButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"处理完成" cornerRadius:5.f];
                    [netWorkButton addTarget:self action:@selector(netWorkButtonButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.bottomView addSubview:netWorkButton];
                    [netWorkButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(0);
                        make.left.mas_equalTo(15.f * scale);
                        make.right.mas_equalTo(-15.f * scale);
                        make.height.mas_equalTo(44.f * scale);
                    }];
                }else if (self.taskListModel.task_type_id == TaskType_InfoCheck) {
                    UIButton * checkButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"处理完成" cornerRadius:5.f];
                    [checkButton addTarget:self action:@selector(checkButtonButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
                    [self.bottomView addSubview:checkButton];
                    [checkButton mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.mas_equalTo(0);
                        make.left.mas_equalTo(15.f * scale);
                        make.right.mas_equalTo(-15.f * scale);
                        make.height.mas_equalTo(44.f * scale);
                    }];
                }
            }else{
                [self.bottomView removeFromSuperview];
            }
        }
            break;
            
        default:
            
            [self.bottomView removeFromSuperview];
            
            break;
    }
}

- (void)addSearchHotelNotification
{
    if (!self.hasSearchHotel) {
        [[DeviceManager manager] startSearchDecice];
        [[DeviceManager manager] startMonitoring];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDeviceDidSuccess) name:RDSearchDeviceSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchDeviceDidEnd) name:RDSearchDeviceDidEndNotification object:nil];
    }
}

//发现了酒楼环境
- (void)searchDeviceDidSuccess
{
    NSString * hotelID = [DeviceManager manager].hotelID;
    if (!isEmptyString(hotelID)) {
        if (![self.hotelID isEqualToString:hotelID]) {
            self.hotelID = hotelID;
        }
    }
}

//搜索设备结束
- (void)searchDeviceDidEnd
{
    if (![DeviceManager manager].isHotel) {
        self.hotelID = @"";
    }else{
        NSString * hotelID = [DeviceManager manager].hotelID;
        if (!isEmptyString(hotelID)) {
            if (![self.hotelID isEqualToString:hotelID]) {
                self.hotelID = hotelID;
            }
        }
    }
}

- (void)removeSearchHotelNotification
{
    if (self.hasSearchHotel) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:RDSearchDeviceSuccessNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:RDSearchDeviceDidEndNotification object:nil];
    }
}

//去指派
- (void)assignButtonDidClicked
{
    AssignViewController * vc = [[AssignViewController alloc] initWithTaskModel:self.taskListModel];
    [self.navigationController pushViewController:vc animated:YES];
}

//拒绝
- (void)refuseButtonDidClicked
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.refuseView];
    [self.refuseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

//安装验收
- (void)installButtonButtonDidClicked
{
    [self creatInstallListView:self.dConfigData.count andTitArray:nil];
}

//维修
- (void)repairButtonDidClicked
{
    [self creatRepairListView];
}

//网络改造处理完成
- (void)netWorkButtonButtonDidClicked
{
    [self creatInstallListView:2 andTitArray:[NSArray arrayWithObjects:@"改造设备图",@"网络改造检验单", nil]];
}

//信息检测
- (void)checkButtonButtonDidClicked
{
    [self creatInstallListView:1 andTitArray:[NSArray arrayWithObjects:@"信息检验单", nil]];
}

#pragma mark - 弹出安装验收，网络改造，信息检测窗口
- (void)creatInstallListView:(NSUInteger )totalCount andTitArray:(NSArray *)titleArray{
    
    self.totalAlertCount = totalCount;
    self.inPAlertView = [[InstallProAlertView alloc] initWithTotalCount:totalCount andTitleArray:titleArray andDataArr:self.dConfigData];
    self.inPAlertView.tag = 2888;
    self.inPAlertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.inPAlertView.userInteractionEnabled = YES;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    self.inPAlertView.bottom = keyWindow.top;
    self.inPAlertView.delegate = self;
    [self.view addSubview: self.inPAlertView];
    [self.inPAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64));
        make.left.right.top.mas_equalTo(0);
    }];
}

#pragma mark - 点击安装验收图片来源
- (void)creatPhotoOrCamaraView:(NSIndexPath *)index{
    
    self.selectImgIndex = index;
    [self creatPhotoSheet];
    
}

#pragma mark - 提交安装验收上传照片
- (void)subMitData{
    [self upLoadIntallImageData];
}

#pragma mark - 取消安装验收上传照片
- (void)cancel{
     [self dismissInstallAlertViewWithDuration:0.3f];
}

#pragma mark - show view
-(void)showInstallAlertViewWithDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        
         self.inPAlertView.bottom = self.view.bottom;
        
    } completion:^(BOOL finished) {
    }];
}

-(void)dismissInstallAlertViewWithDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        
         self.inPAlertView.bottom = self.view.top;
        
    } completion:^(BOOL finished) {
        
        [ self.inPAlertView removeFromSuperview];
        
    }];
}

#pragma mark - 弹出维修窗口
- (void)creatRepairListView{
    
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
    
    self.mReasonLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.mReasonLab.backgroundColor = [UIColor clearColor];
    self.mReasonLab.font = [UIFont systemFontOfSize:14];
    self.mReasonLab.textColor = [UIColor grayColor];
    self.mReasonLab.layer.borderWidth = .5f;
    self.mReasonLab.layer.cornerRadius = 4.f;
    self.mReasonLab.layer.masksToBounds = YES;
    self.mReasonLab.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    self.mReasonLab.text = @"  选择版位";
    self.mReasonLab.textAlignment = NSTextAlignmentLeft;
    self.mReasonLab.userInteractionEnabled = YES;
    [self.sheetBgView addSubview:self.mReasonLab];
    [self.mReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(bgVideoWidth - 30);
        make.height.mas_equalTo(30);
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
        make.top.mas_equalTo(self.mReasonLab.mas_bottom).offset(10);
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
        make.top.mas_equalTo(self.mReasonLab.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset( 10 + 40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
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
        make.top.mas_equalTo(self.resolvedBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(bgVideoWidth - 30);
        make.height.mas_equalTo(70);
    }];
    
    UIView *photoBgView = [[UIView alloc] init];
    photoBgView.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    photoBgView.layer.borderWidth = 1;
    photoBgView.layer.cornerRadius =5;
    [self.sheetBgView addSubview:photoBgView];
    [photoBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkTextView.mas_bottom).offset(10);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(bgVideoWidth - 30);
        make.height.mas_equalTo(120);
    }];
    
    UILabel *mTitleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    mTitleLab.backgroundColor = [UIColor clearColor];
    mTitleLab.font = [UIFont systemFontOfSize:14];
    mTitleLab.textColor = [UIColor blackColor];
    mTitleLab.text = @"最多上传三张照片";
    mTitleLab.textAlignment = NSTextAlignmentCenter;
    [photoBgView addSubview:mTitleLab];
    [mTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.centerX.mas_equalTo(self.sheetBgView.centerX);
        make.width.mas_equalTo(bgVideoWidth);
        make.height.mas_equalTo(20);
    }];
    
    for (int i = 0; i < 3; i ++) {
        
        UIImageView *fImageView  = [[UIImageView alloc] init];
        fImageView.tag = 1999 + i;
        fImageView.backgroundColor = [UIColor lightGrayColor];
        fImageView.userInteractionEnabled = YES;
        [photoBgView addSubview:fImageView];
        CGFloat fWidth = (bgVideoWidth - 40 - 30)/3;
        [fImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(mTitleLab.mas_bottom);
            make.left.mas_equalTo(10 + (i *10 + i *fWidth));
            make.width.mas_equalTo(fWidth);
            make.height.mas_equalTo(110 - 50);
        }];
        
        UIButton *deleteImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteImgBtn.tag = 2999 + i;
        [deleteImgBtn setTitle:@"删除" forState:UIControlStateNormal];
        deleteImgBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        deleteImgBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
        [deleteImgBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        deleteImgBtn.layer.borderWidth = .5f;
        deleteImgBtn.layer.cornerRadius = 2.f;
        deleteImgBtn.layer.masksToBounds = YES;
        [deleteImgBtn addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
        [photoBgView addSubview:deleteImgBtn];
        CGFloat dWidth = (bgVideoWidth - 52 - 30)/3;
        [deleteImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(fImageView.mas_bottom).offset(5);
            make.left.mas_equalTo(13 + (i *13 + i *dWidth));
            make.width.mas_equalTo(dWidth);
            make.height.mas_equalTo(20);
        }];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImagePress:)];
        tap.numberOfTapsRequired = 1;
        [fImageView addGestureRecognizer:tap];
    }
    
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
        make.top.mas_equalTo(photoBgView.mas_bottom).offset(15);
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
        make.top.mas_equalTo(photoBgView.mas_bottom).offset(15);
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

- (void)deleteClicked:(UIButton *)Btn{
    
    UIImageView *selectImgView = [self.view viewWithTag:Btn.tag - 1000];
    selectImgView.image = nil;
}

- (void)addImagePress:(id)sender{
    
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)sender;
    UIView *views = (UIView*) tap.view;
    NSUInteger tag = views.tag;
    self.selectImgTag = tag;
    [self creatPhotoSheet];
    
}

#pragma mark 弹出相册或是相机选择页面
- (void)creatPhotoSheet{
    
    InstallAlerTableViewCell *cell =  [self.inPAlertView.alertTableView cellForRowAtIndexPath:self.selectImgIndex];
    
    UIActionSheet *photoSheet;
    if (cell.instaImg.image == nil) {
        photoSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照",nil];
    }else{
        photoSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照",@"删除",nil];
    }
    [photoSheet showInView:self.view];
 
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
}

// UIActionSheetDelegate实现代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        [self selectImageFromAlbum];
        NSLog(@"点击了相册按钮");
    }
    else if (1 == buttonIndex)
    {
        [self selectImageFromCamera];
        NSLog(@"点击了拍照按钮");
    }else if (2 == buttonIndex)
    {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"删除"]) {
            InstallAlerTableViewCell *cell =  [self.inPAlertView.alertTableView cellForRowAtIndexPath:self.selectImgIndex];
            cell.instaImg.image = nil;
            NSLog(@"点击了删除按钮");
        }
        
    }
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置摄像头模式拍照模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [_imagePickerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:_imagePickerController animated:YES completion:nil];
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
    
    UIImageView *selectImgView = [self.view viewWithTag:self.selectImgTag];
    selectImgView.image = image;
    
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        
        if (self.taskListModel.task_type_id == 4) {
            UIImageView *selectImgView = [self.view viewWithTag:self.selectImgTag];
            selectImgView.image = info[UIImagePickerControllerEditedImage];
        }else{
            InstallAlerTableViewCell *cell =  [self.inPAlertView.alertTableView cellForRowAtIndexPath:self.selectImgIndex];
            cell.instaImg.image = info[UIImagePickerControllerEditedImage];
            NSLog(@"");
        }
        //压缩图片
        //NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}




- (void)ResolveClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.repairAlertModel.state = @"1";
        btn.layer.borderWidth = 2.f;
        if (self.unResolvedBtn.selected == YES) {
            self.unResolvedBtn.selected = NO;
            self.unResolvedBtn.layer.borderWidth = .5f;
        }
    }else{
        self.repairAlertModel.state = @"";
        btn.layer.borderWidth = .5f;
    }
}

- (void)unResolveClicked:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.repairAlertModel.state = @"2";
        btn.layer.borderWidth = 2.f;
        if (self.resolvedBtn.selected == YES) {
            self.resolvedBtn.selected = NO;
            self.resolvedBtn.layer.borderWidth = .5f;
        }
    }else{
        self.repairAlertModel.state = @"";
        btn.layer.borderWidth = .5f;
    }
}

#pragma mark - 点击版位选择
- (void)mReasonClicked{
    
    if (self.dConfigData.count > 0) {
        PositionListViewController *flVC = [[PositionListViewController alloc] init];
        float version = [UIDevice currentDevice].systemVersion.floatValue;
        if (version < 8.0) {
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
        } else {;
            flVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        flVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        flVC.dataSource = self.dConfigData;
        [self presentViewController:flVC animated:YES completion:nil];
        flVC.backDatas = ^(NSString *boxId,NSString *name) {
            self.mReasonLab.text = name;
            self.currentBoxId = boxId;
            
        };
    }
}

#pragma mark - 点击弹窗页面空白处
- (void)mListClicked{
    
    [self.mListView endEditing:YES];
    [self.sheetBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mListView.centerY).offset(0);
    }];
}

-(void)cancelClicked{
    [self dismissViewWithAnimationDuration:0.3f];
}

#pragma mark - 维修弹窗提交数据
-(void)submitClicked{
    
    if (isEmptyString(self.currentBoxId)){
        [MBProgressHUD showTextHUDWithText:@"请选择版位" inView:self.view];
    }else if (isEmptyString(self.repairAlertModel.state)) {
        [MBProgressHUD showTextHUDWithText:@"请选择是否解决" inView:self.view];
    }else{
        [self upLoadImageData];
    }
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.taskListModel.state_id == TaskStatusType_Completed) {
        return self.executeSource.count;
    }
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.taskListModel.state_id == TaskStatusType_Completed) {
        NSDictionary * info = [self.executeSource objectAtIndex:indexPath.row];
        if (self.taskListModel.task_type_id == TaskType_Repair) {
            RepairDetailCell * repairCell = [tableView dequeueReusableCellWithIdentifier:@"RepairDetailCell" forIndexPath:indexPath];
            [repairCell configWithInfo:info];
            return repairCell;
        }else if (self.taskListModel.task_type_id == TaskType_InfoCheck) {
            CheckDetailCell * checkCell = [tableView dequeueReusableCellWithIdentifier:@"CheckDetailCell" forIndexPath:indexPath];
            [checkCell configWithInfo:info];
            return checkCell;
        }else if (self.taskListModel.task_type_id == TaskType_NetTransform) {
            NetworkDetailCell * netWorkCell = [tableView dequeueReusableCellWithIdentifier:@"NetworkDetailCell" forIndexPath:indexPath];
            [netWorkCell configWithInfo:info];
            return netWorkCell;
        }else if (self.taskListModel.task_type_id == TaskType_Install) {
            InstallDetailCell * installCell = [tableView dequeueReusableCellWithIdentifier:@"InstallDetailCell" forIndexPath:indexPath];
            [installCell configWithInfo:info];
            return installCell;
        }
    }
    
    DeviceFaultTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceFaultTableViewCell" forIndexPath:indexPath];
    
    DeviceFaultModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithDeviceFaultModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if (self.taskListModel.state_id == TaskStatusType_Completed) {
        if (self.taskListModel.task_type_id == TaskType_Repair) {
            
            NSDictionary * info = [self.executeSource objectAtIndex:indexPath.row];
            NSString * remark = [NSString stringWithFormat:@"备注：%@", [info objectForKey:@"remark"]];
            
            CGFloat height = [HotTopicTools getHeightByWidth:(kMainBoundsWidth - 54.f) * scale title:remark font:kPingFangRegular(15.f * scale)];
            
            return 160.f * scale + height;
        }else if (self.taskListModel.task_type_id == TaskType_InfoCheck) {
            return 200.f * scale;
        }else if (self.taskListModel.task_type_id == TaskType_NetTransform) {
            return 360.f * scale;
        }else if (self.taskListModel.task_type_id == TaskType_Install) {
            return 180.f * scale;
        }
    }
    
    CGFloat height = 0.f;
    
    DeviceFaultModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (isEmptyString(model.fault_img_url)) {
        height = 117 * scale;
    }else{
        height = 186 * scale;
    }
    
    CGFloat descHeight = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 54.f * scale title:[@"故障现象：" stringByAppendingString:model.fault_desc] font:kPingFangRegular(15.f * scale)];
    height += descHeight;
    
    return height;
}

#pragma mark - 弹窗数据提交
- (void)subMitDataRequest
{

    NSString *taskType = [NSString stringWithFormat:@"%ld",self.taskListModel.task_type_id];
    if (isEmptyString(taskType)) {
        taskType = @"";
    }
    NSString *userId = [UserManager manager].user.userid;
    if (isEmptyString(userId)) {
        userId = @"";
    }
    NSString *boxId = self.currentBoxId;
    if (isEmptyString(boxId)) {
        boxId = @"";
    }
    NSString *taskId = self.taskListModel.cid;
    if (isEmptyString(taskId)) {
        taskId = @"";
    }
    NSString *repairState = self.repairAlertModel.state;
    if (isEmptyString(repairState)) {
        repairState = @"";
    }
    NSString *textViewStr = self.remarkTextView.text;
    if (isEmptyString(textViewStr)) {
        textViewStr = @"";
    }
    NSDictionary *dic;
    // 4 为维修类型
    if (self.taskListModel.task_type_id == 4) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:boxId,@"box_id",repairState,@"state",taskType,@"task_type",userId,@"user_id",taskId,@"task_id",[self.subMitPosionArray toJSONString],@"repair_img",textViewStr,@"remark", nil];
    }else{
        dic = [NSDictionary dictionaryWithObjectsAndKeys:boxId,@"box_id",repairState,@"state",taskType,@"task_type",userId,@"user_id",taskId,@"task_id",[self.subMitPosionArray toJSONString],@"repair_img",textViewStr,@"remark", nil];
    }
    
    SubmitTaskRequest * request = [[SubmitTaskRequest alloc] initWithPubData:dic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dadaDic = [NSDictionary dictionaryWithDictionary:response];
        if ([[dadaDic objectForKey:@"code"] integerValue] == 10000) {
            [MBProgressHUD showTextHUDWithText:[dadaDic objectForKey:@"msg"] inView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:RDTaskStatusDidChangeNotification object:nil];
            if (self.taskListModel.task_type_id == 4){
                [self dismissViewWithAnimationDuration:0.3];
            }else{
                [self dismissInstallAlertViewWithDuration:0.3];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dadaDic = [NSDictionary dictionaryWithDictionary:response];
        [MBProgressHUD showTextHUDWithText:[dadaDic objectForKey:@"msg"] inView:self.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

#pragma mark - 安装检测等弹窗图片上传
- (void)upLoadIntallImageData{
    
    [self.subMitPosionArray removeAllObjects];
    NSMutableArray *upImageArr = [[NSMutableArray alloc] init];
    NSMutableArray *pathArr = [[NSMutableArray alloc] init];
    UIImage *selectImg;
    __block int upCount = 0;
    for (int i = 0; i < self.totalAlertCount; i ++) {
        
        InstallAlerTableViewCell *cell =  [self.inPAlertView.alertTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
         selectImg = cell.instaImg.image;
        if (selectImg != nil) {
            [upImageArr addObject:selectImg];
            
            NSString *urlPath = @"http://devp.oss.littlehotspot.com";
            
            if (self.taskListModel.task_type_id == 8) {
                
                [pathArr addObject:self.taskListModel.hotel_id];
                
                NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i + 1],@"type",urlPath,@"img", nil];
                [self.subMitPosionArray addObject:tmpDic];
            }else if (self.taskListModel.task_type_id == 2){
                
                RestaurantRankModel *tmpModel = self.dConfigData[i];
                [pathArr addObject:tmpModel.box_id];
                
                NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:tmpModel.box_id,@"box_id",urlPath,@"img", nil];
                [self.subMitPosionArray addObject:tmpDic];
                
            }else{
                [self.subMitPosionArray addObject:urlPath];
            }
        }
    }
    
    if (self.taskListModel.task_type_id == 8) {
        
        if (upImageArr.count > 0) {
            [HotTopicTools uploadImageArray:upImageArr withHotelIDArray:pathArr progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                
            } success:^(NSString *path, NSInteger index) {
                NSMutableDictionary *tmpDic = self.subMitPosionArray[index];
                [tmpDic setObject:path forKey:@"img"];
                
                upCount++;
                if (upCount == upImageArr.count) {
                    [self subMitDataRequest];
                }
                
            } failure:^(NSError *error, NSInteger index) {
                NSMutableDictionary *tmpDic = self.subMitPosionArray[index];
                [tmpDic setObject:@"" forKey:@"img"];
                
                upCount++;
                if (upCount == upImageArr.count) {
                    [self subMitDataRequest];
                }
                
            }];
        }
        
      }else if (self.taskListModel.task_type_id == 2){
        if (upImageArr.count > 0) {
            [HotTopicTools uploadImageArray:upImageArr withBoxIDArray:pathArr progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            } success:^(NSString *path, NSInteger index) {
                NSMutableDictionary *tmpDic = self.subMitPosionArray[index];
                [tmpDic setObject:path forKey:@"img"];
                NSLog(@"---上传成功！");
                
                upCount++;
                if (upCount == upImageArr.count) {
                    [self subMitDataRequest];
                }
                
            } failure:^(NSError *error, NSInteger index) {
                NSMutableDictionary *tmpDic = self.subMitPosionArray[index];
                [tmpDic setObject:@"" forKey:@"img"];
                NSLog(@"---上传失败！");
                
                upCount++;
                if (upCount == upImageArr.count) {
                    [self subMitDataRequest];
                }
                
            }];
        }
        
    }else{
        if (upImageArr.count > 0) {
            [HotTopicTools  uploadImage:selectImg withHotelID:self.taskListModel.hotel_id progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            } success:^(NSString *path) {
                [self.subMitPosionArray removeAllObjects];
                [self.subMitPosionArray addObject:path];
                NSLog(@"---上传成功！");
                
                 [self subMitDataRequest];
                
            } failure:^(NSError *error) {
                [self.subMitPosionArray removeAllObjects];
                [self.subMitPosionArray addObject:@""];
                NSLog(@"---上传失败！");
                
                 [self subMitDataRequest];
                
            }];
        }
    }
}

#pragma mark - 获取版位信息
- (void)getBoxIdData{
    NSString *taskType = [NSString stringWithFormat:@"%ld",self.taskListModel.task_type_id];
    if (isEmptyString(taskType)) {
        taskType = @"";
    }
    NSString *userId = [UserManager manager].user.userid;
    if (isEmptyString(userId)) {
        userId = @"";
    }
    NSString *taskId = self.taskListModel.cid;
    if (isEmptyString(taskId)) {
        taskId = @"";
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:taskType,@"task_type",userId,@"user_id",taskId,@"task_id", nil];
    BoxDataRequest * request = [[BoxDataRequest alloc] initWithParamData:dic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dadaDic = [NSDictionary dictionaryWithDictionary:response];
        NSDictionary *resultDic = dadaDic[@"result"];
        NSArray *listArr = resultDic[@"list"];
        for (int i = 0; i < listArr.count; i ++) {
            RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] initWithDictionary:listArr[i]];
            [self.dConfigData addObject:tmpModel];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}
#pragma mark - 维修弹窗图片上传
- (void)upLoadImageData{

    [self.subMitPosionArray removeAllObjects];
    NSMutableArray *upImageArr = [[NSMutableArray alloc] init];
    NSMutableArray *pathArr = [[NSMutableArray alloc] init];
    NSArray *imgTagArr = [NSArray arrayWithObjects:@"1999",@"2000",@"2001", nil];
    
    __block int upCount = 0;
    for (int i = 0; i < imgTagArr.count; i ++) {

        UIImageView *selectImgView = [self.view viewWithTag:[imgTagArr[i] integerValue]];
        if (selectImgView.image != nil) {
            
            [upImageArr addObject:selectImgView.image];
            [pathArr addObject:self.currentBoxId];
        }
    }
    
    if (upImageArr.count > 0) {
        [HotTopicTools uploadImageArray:upImageArr withBoxIDArray:pathArr progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        } success:^(NSString *path, NSInteger index) {
            [self.subMitPosionArray addObject:path];
            NSLog(@"---上传成功！");
            
            upCount++;
            if (upCount == upImageArr.count) {
                [self subMitDataRequest];
            }
            
        } failure:^(NSError *error, NSInteger index) {
            [self.subMitPosionArray addObject:@""];
            NSLog(@"---上传失败！");
            
            upCount++;
            if (upCount == upImageArr.count) {
                [self subMitDataRequest];
            }
            
        }];
    }
}

- (void)setupDatas
{
    self.dataSource = [[NSMutableArray alloc] init];
    
    TaskListDetailRequest * request = [[TaskListDetailRequest alloc] initWithTaskID:self.tempModel.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            self.taskListModel = [[TaskModel alloc] initWithDictionary:result];
            self.taskListModel.cid = self.tempModel.cid;
            
            self.tempModel.state_id = self.taskListModel.state_id;
            self.tempModel.state = self.taskListModel.state;
            self.tempModel.appoint_exe_time = self.taskListModel.appoint_exe_time;
            self.tempModel.exeuser = self.taskListModel.exeuser;
            self.tempModel.appoint_time = self.taskListModel.appoint_time;
            self.tempModel.appoint_user = self.taskListModel.appoint_user;
            self.tempModel.complete_time = self.taskListModel.complete_time;
            self.tempModel.refuse_time = self.taskListModel.refuse_time;
        }
        
        NSArray * repairList = [result objectForKey:@"repair_list"];
        if ([repairList isKindOfClass:[NSArray class]] && repairList.count > 0) {
            
            for (NSInteger i = 0; i < repairList.count; i++) {
                NSDictionary * device = [repairList objectAtIndex:i];
                if ([device isKindOfClass:[NSDictionary class]]) {
                    DeviceFaultModel * model = [[DeviceFaultModel alloc] initWithDictionary:device];
                    [self.dataSource addObject:model];
                }
            }
        }
        
        [self.executeSource removeAllObjects];
        if (self.taskListModel.state_id == TaskStatusType_Completed) {
            NSArray * execute = [result objectForKey:@"execute"];
            if ([execute isKindOfClass:[NSArray class]]) {
                [self.executeSource addObjectsFromArray:execute];
            }
        }
        
        [self setupViews];
        
        if (self.taskListModel.task_type_id == 2 || self.taskListModel.task_type_id == 4 ) {
            // 请求维修版位信息
            [self getBoxIdData];
        }
        
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg inView:[UIApplication sharedApplication].keyWindow];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取任务失败" inView:[UIApplication sharedApplication].keyWindow];
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"获取任务失败" inView:[UIApplication sharedApplication].keyWindow];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
}

- (UIView *)refuseView
{
    if (!_refuseView) {
        _refuseView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _refuseView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
        
        UIView * contenView = [[UIView alloc] initWithFrame:CGRectMake(30, kMainBoundsHeight / 10, kMainBoundsWidth - 60, kMainBoundsHeight / 3)];
        contenView.backgroundColor = UIColorFromRGB(0xffffff);
        [_refuseView addSubview:contenView];
        contenView.layer.cornerRadius = 10.f;
        contenView.layer.masksToBounds = YES;
        
        self.refuseTextView = [[RDTextView alloc] initWithFrame:CGRectMake(10, 10, contenView.frame.size.width - 20, contenView.frame.size.height - 70)];
        self.refuseTextView.placeholder = @"请输入拒绝原因(例如：已经与业务人员沟通，版位正常)";
        self.refuseTextView.font = kPingFangRegular(16);
        self.refuseTextView.textColor = UIColorFromRGB(0x333333);
        self.refuseTextView.layer.cornerRadius = 5.f;
        self.refuseTextView.layer.masksToBounds = YES;
        self.refuseTextView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:.3f].CGColor;
        self.refuseTextView.layer.borderWidth = 1.f;
        [contenView addSubview:self.refuseTextView];
        
        UIButton * okButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(16) backgroundColor:[UIColor clearColor] title:@"提交" cornerRadius:5.f];
        okButton.layer.borderColor = UIColorFromRGB(0x444444).CGColor;
        okButton.layer.borderWidth = 1.f;
        [okButton addTarget:self action:@selector(refuseTask) forControlEvents:UIControlEventTouchUpInside];
        [contenView addSubview:okButton];
        [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-10.f);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(40);
        }];
    }
    return _refuseView;
}

- (void)refuseTask
{
    [RefuseRequest cancelRequest];
    RefuseRequest * request = [[RefuseRequest alloc] initWithDesc:self.refuseTextView.text taskID:self.taskListModel.cid userID:[UserManager manager].user.userid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self.refuseView removeFromSuperview];
        [self.bottomView removeAllSubviews];
        [self.bottomView removeFromSuperview];
        [self.tableView removeFromSuperview];
        
        [self setupDatas];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow];
        }else{
            [MBProgressHUD showTextHUDWithText:@"拒绝失败" inView:self.view];
        }
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD showTextHUDWithText:@"拒绝失败" inView:self.view];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if ([self.navigationController.topViewController isKindOfClass:NSClassFromString(@"TaskListViewController")]) {
        [[DeviceManager manager] stopMonitoring];
        [[DeviceManager manager] stopSearchDevice];
    }
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
}

- (void)dealloc
{
    [self removeNotification];
    [self removeSearchHotelNotification];
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
