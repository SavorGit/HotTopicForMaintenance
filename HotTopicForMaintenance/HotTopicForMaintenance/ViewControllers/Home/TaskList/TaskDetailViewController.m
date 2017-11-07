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

@interface TaskDetailViewController ()<UITableViewDelegate, UITableViewDataSource,InstallProAlertDelegate,UITextViewDelegate>

@property (nonatomic, strong) TaskModel * tempModel;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * dConfigData; //版位信息
@property (nonatomic, strong) TaskModel * taskListModel;

@property (nonatomic, assign) BOOL hasNotification;

@property (nonatomic, strong) UIView *mListView;
@property (nonatomic, strong) UIImageView *sheetBgView;
@property (nonatomic, strong) UITextView *remarkTextView;
@property (nonatomic, strong) UILabel *mReasonLab;
@property (nonatomic, strong) UIButton * unResolvedBtn;
@property (nonatomic, strong) UIButton * resolvedBtn;
@property (nonatomic, strong) UIButton * submitBtn;
@property (nonatomic, strong) TaskRepairAlertModel *repairAlertModel;

@property (nonatomic, strong) InstallProAlertView *inPAlertView;

@property (nonatomic, strong) UIView * bottomView;

//点击拒绝的弹窗
@property (nonatomic, strong) UIView * refuseView;
@property (nonatomic, strong) RDTextView * refuseTextView;

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
    self.dConfigData = [[NSMutableArray alloc] init];
    [self setupDatas];
    [self addNotification];
//    [self setupViews];
}

- (void)removeNotification
{
    if (self.hasNotification) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:RDTaskStatusDidChangeNotification object:nil];
    }
}

- (void)addNotification
{
    if (!self.hasNotification) {
        self.hasNotification = YES;
        if ([UserManager manager].user.roletype == UserRoleType_AssignTask) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskStatusDidChange) name:RDTaskStatusDidChangeNotification object:nil];
        }
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
    self.tableView.backgroundColor = VCBackgroundColor;
    [self.tableView registerClass:[DeviceFaultTableViewCell class] forCellReuseIdentifier:@"DeviceFaultTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    TaskDetailView * view = [[TaskDetailView alloc] initWithTaskModel:self.taskListModel];
    self.tableView.tableHeaderView = view;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 98.f * scale)];
    
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
    [self creatInstallListView:10];
}

//维修
- (void)repairButtonDidClicked
{
    [self creatRepairListView];
}

//网络改造处理完成
- (void)netWorkButtonButtonDidClicked
{
    [self creatInstallListView:2];
}

//信息检测
- (void)checkButtonButtonDidClicked
{
    [self creatInstallListView:2];
}

#pragma mark - 弹出安装验收，网络改造，信息检测窗口
- (void)creatInstallListView:(NSUInteger )totalCount{
    
    self.inPAlertView = [[InstallProAlertView alloc] initWithTotalCount:totalCount];
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

#pragma mark - 提交上传照片
- (void)subMitData{
    [self dismissInstallAlertViewWithDuration:0.3f];
}

#pragma mark - 取消上传照片
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
        fImageView.backgroundColor = [UIColor cyanColor];
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
        [deleteImgBtn addTarget:self action:@selector(deleteClicked) forControlEvents:UIControlEventTouchUpInside];
        [photoBgView addSubview:deleteImgBtn];
        CGFloat dWidth = (bgVideoWidth - 52 - 30)/3;
        [deleteImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(fImageView.mas_bottom).offset(5);
            make.left.mas_equalTo(13 + (i *13 + i *dWidth));
            make.width.mas_equalTo(dWidth);
            make.height.mas_equalTo(20);
        }];
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
    };
}

#pragma mark - 请求版位信息
- (void)boxConfigRequest
{
    GetBoxListRequest * request = [[GetBoxListRequest alloc] initWithHotelId:self.self.taskListModel.cid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray *listArray = [response objectForKey:@"result"];
        
        for (int i = 0; i < listArray.count; i ++) {
            RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] initWithDictionary:listArray[i]];
            [self.dConfigData addObject:tmpModel];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
    }];
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

-(void)submitClicked{
    [self dismissViewWithAnimationDuration:0.3f];
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
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceFaultTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DeviceFaultTableViewCell" forIndexPath:indexPath];
    
    DeviceFaultModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithDeviceFaultModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.f;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    DeviceFaultModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (isEmptyString(model.fault_image_url)) {
        height = 117 * scale;
    }else{
        height = 186 * scale;
    }
    
    CGFloat descHeight = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 54.f * scale title:[@"故障现象：" stringByAppendingString:model.fault_desc] font:kPingFangRegular(15.f * scale)];
    height += descHeight;
    
    return height;
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
        
        [self setupViews];
        
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

- (void)dealloc
{
    [self removeNotification];
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
