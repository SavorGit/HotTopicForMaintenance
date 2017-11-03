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

@interface TaskDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) TaskModel * taskListModel;

@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) UIView * refuseView;
@property (nonatomic, strong) RDTextView * refuseTextView;

@end

@implementation TaskDetailViewController

- (instancetype)initWithTaskModel:(TaskModel *)model
{
    if (self = [super init]) {
        self.taskListModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupDatas];
    [self setupViews];
}

- (void)setupViews
{
    self.title = @"任务详情";
    
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
        }
            
            break;
            
        case UserRoleType_HandleTask:
        {
            if (self.taskListModel.type == TaskType_Repair) {
                UIButton * repairButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"维修" cornerRadius:5.f];
                [repairButton addTarget:self action:@selector(repairButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.bottomView addSubview:repairButton];
                [repairButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(15.f * scale);
                    make.right.mas_equalTo(-15.f * scale);
                    make.height.mas_equalTo(44.f * scale);
                }];
            }else if (self.taskListModel.type == TaskType_Install) {
                UIButton * installButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"安装验收" cornerRadius:5.f];
                [installButton addTarget:self action:@selector(installButtonButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.bottomView addSubview:installButton];
                [installButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(15.f * scale);
                    make.right.mas_equalTo(-15.f * scale);
                    make.height.mas_equalTo(44.f * scale);
                }];
            }else if (self.taskListModel.type == TaskType_NetTransform) {
                UIButton * netWorkButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) backgroundColor:UIColorFromRGB(0x00bcee) title:@"处理完成" cornerRadius:5.f];
                [netWorkButton addTarget:self action:@selector(netWorkButtonButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
                [self.bottomView addSubview:netWorkButton];
                [netWorkButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(0);
                    make.left.mas_equalTo(15.f * scale);
                    make.right.mas_equalTo(-15.f * scale);
                    make.height.mas_equalTo(44.f * scale);
                }];
            }else if (self.taskListModel.type == TaskType_InfoCheck) {
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
    AssignViewController * vc = [[AssignViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//拒绝
- (void)refuseButtonDidClicked
{
    [self.navigationController.view addSubview:self.refuseView];
    [self.refuseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

//安装验收
- (void)installButtonButtonDidClicked
{
    
}

//维修
- (void)repairButtonDidClicked
{
    
}

//网络改造处理完成
- (void)netWorkButtonButtonDidClicked
{
    
}

//信息检测
- (void)checkButtonButtonDidClicked
{
    
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
    if (isEmptyString(model.imageURL)) {
        height = 117 * scale;
    }else{
        height = 186 * scale;
    }
    
    CGFloat descHeight = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 54.f * scale title:[@"故障现象：" stringByAppendingString:model.desc] font:kPingFangRegular(15.f * scale)];
    height += descHeight;
    
    return height;
}

- (void)setupDatas
{
    self.dataSource = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < 20; i++) {
        DeviceFaultModel * model = [[DeviceFaultModel alloc] init];
        model.name = @"郭春城专用";
        if (i%3 == 0) {
            model.desc = @"吃饭的时候撑到了";
        }else{
            model.desc = @"吃饭的时候撑到了吃饭的时候撑到了吃饭的时候撑到了吃饭的时候撑到了吃饭的时候撑到了吃饭的时候撑到了吃饭的时候撑到了吃饭的时候撑到了吃饭的时候撑到了吃饭的时候撑到了";
        }
        if (i%2 == 0) {
            model.imageURL = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509552271344&di=80a9cc59b6c25603b17df857bd279fbe&imgtype=0&src=http%3A%2F%2Fimg02.tooopen.com%2Fimages%2F20151223%2Ftooopen_sy_152513897829.jpg";
        }else{
            model.imageURL = @"";
        }
        [self.dataSource addObject:model];
    }
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
        [okButton addTarget:_refuseView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
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