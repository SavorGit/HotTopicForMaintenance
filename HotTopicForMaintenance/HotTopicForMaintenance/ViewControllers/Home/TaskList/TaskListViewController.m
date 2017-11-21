//
//  TaskListViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskModel.h"
#import "TaskListTableViewCell.h"
#import "TaskDetailViewController.h"
#import "MJRefresh.h"
#import "AssignRoleTaskListRequest.h"
#import "CreateRoleTasklistRequest.h"
#import "HandleRoleListRequest.h"
#import "LookRoleListRequest.h"
#import "UserManager.h"

@interface TaskListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) TaskListType taskType;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL hasNotification;

@end

@implementation TaskListViewController

- (instancetype)initWithTaskListType:(TaskListType)type
{
    if (self = [super init]) {
        self.taskType = type;
        self.page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupDatas];
}

- (void)setupViews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = VCBackgroundColor;
    [self.tableView registerClass:[TaskListTableViewCell class] forCellReuseIdentifier:@"TaskListTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self addNotification];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMore)];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:RDTaskStatusDidChangeNotification object:nil];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel * model = [self.dataSource objectAtIndex:indexPath.section];
    
    TaskDetailViewController * vc = [[TaskDetailViewController alloc] initWithTaskModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel * model = [self.dataSource objectAtIndex:indexPath.section];
    
    TaskListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TaskListTableViewCell" forIndexPath:indexPath];
    [cell configWithTaskModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 6.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskModel * model = [self.dataSource objectAtIndex:indexPath.section];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    switch (model.state_id) {
        case TaskStatusType_WaitAssign:
            return 134.f * scale + 1;
            break;
            
        case TaskStatusType_WaitHandle:
            return 182.f * scale + 3;
            break;
            
        case TaskStatusType_Completed:
            return 206.f * scale + 4;
            break;
            
        case TaskStatusType_Refuse:
            return 158.f * scale + 2;
            break;
            
        default:
            break;
    }
    
    return 150.f;
}

- (void)setupDatas
{
    self.dataSource = [NSMutableArray new];
    
    [self requestWithPage:1 success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self setupViews];
        NSArray * taskList = [response objectForKey:@"result"];
        if ([taskList isKindOfClass:[NSArray class]] && taskList.count > 0) {
            for (NSInteger i = 0; i < taskList.count; i++) {
                
                NSDictionary * task = [taskList objectAtIndex:i];
                if ([task isKindOfClass:[NSDictionary class]]) {
                    TaskModel * model = [[TaskModel alloc] initWithDictionary:task];
                    [self.dataSource addObject:model];
                }
            }
        }
        
        [self.tableView reloadData];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response isKindOfClass:[NSError class]]) {
            [MBProgressHUD showTextHUDWithText:@"获取任务失败" inView:self.view];
        }else{
            NSString * msg = [response objectForKey:@"msg"];
            if (isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg inView:self.view];
            }else{
                [MBProgressHUD showTextHUDWithText:@"获取任务失败" inView:self.view];
            }
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"获取任务失败" inView:self.view];
        
    }];
}

- (void)refreshData
{
    [self requestWithPage:1 success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray * taskList = [response objectForKey:@"result"];
        [self.dataSource removeAllObjects];
        if ([taskList isKindOfClass:[NSArray class]] && taskList.count > 0) {
            for (NSInteger i = 0; i < taskList.count; i++) {
                
                NSDictionary * task = [taskList objectAtIndex:i];
                if ([task isKindOfClass:[NSDictionary class]]) {
                    TaskModel * model = [[TaskModel alloc] initWithDictionary:task];
                    [self.dataSource addObject:model];
                }
            }
        }
        
        self.page = 1;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            NSString * msg = [response objectForKey:@"msg"];
            if (isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg inView:self.view];
            }else{
                [MBProgressHUD showTextHUDWithText:@"获取任务失败" inView:self.view];
            }
        }else{
               [MBProgressHUD showTextHUDWithText:@"网络出现问题了" inView:self.view];
        }
        
        [self.tableView.mj_header endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"获取任务失败" inView:self.view];
        [self.tableView.mj_header endRefreshing];
        
    }];
}

- (void)getMore
{
    [self requestWithPage:self.page+1 success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray * taskList = [response objectForKey:@"result"];
        if ([taskList isKindOfClass:[NSArray class]] && taskList.count > 0) {
            for (NSInteger i = 0; i < taskList.count; i++) {
                
                NSDictionary * task = [taskList objectAtIndex:i];
                if ([task isKindOfClass:[NSDictionary class]]) {
                    TaskModel * model = [[TaskModel alloc] initWithDictionary:task];
                    [self.dataSource addObject:model];
                }
            }
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            self.page++;
        }else{
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取任务失败" inView:self.view];
        }
        [self.tableView.mj_footer endRefreshing];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"获取任务失败" inView:self.view];
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)requestWithPage:(NSInteger)page success:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock
{
    switch ([UserManager manager].user.roletype) {
        case UserRoleType_CreateTask:
        {
            CreateRoleTasklistRequest * list = [[CreateRoleTasklistRequest alloc] initWithPage:page state:self.taskType userID:[UserManager manager].user.userid];
            [list sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:businessFailureBlock];
        }
            break;
            
        case UserRoleType_AssignTask:
        {
            AssignRoleTaskListRequest * list = [[AssignRoleTaskListRequest alloc] initWithPage:page state:self.taskType userID:[UserManager manager].user.userid];
            [list sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:businessFailureBlock];
        }
            break;
            
        case UserRoleType_HandleTask:
        {
            HandleRoleListRequest * list = [[HandleRoleListRequest alloc] initWithPage:page state:self.taskType userID:[UserManager manager].user.userid];
            [list sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:businessFailureBlock];
        }
            break;
            
        case UserRoleType_LookTask:
        {
            LookRoleListRequest * list = [[LookRoleListRequest alloc] initWithPage:page state:self.taskType userID:[UserManager manager].user.userid];
            [list sendRequestWithSuccess:successCompletionBlock businessFailure:businessFailureBlock networkFailure:businessFailureBlock];
        }
            
        default:
            break;
    }
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
