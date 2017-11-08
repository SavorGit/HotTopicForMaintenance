//
//  TaskChooseTypeController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskChooseTypeController.h"
#import "TaskTableViewCell.h"
#import "NetworkTransforViewController.h"
#import "InstallAndAcceptViewController.h"
#import "inforDetectionViewController.h"
#import "GetCreateTaskListRequest.h"

@interface TaskChooseTypeController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * datsSource;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation TaskChooseTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择任务类型";
    
    [self setupDatas];
}

- (void)setupDatas
{
    self.datsSource = [[NSMutableArray alloc] init];
    GetCreateTaskListRequest * request = [[GetCreateTaskListRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSArray class]] && result.count > 0) {
            for (NSInteger i = 0; i < result.count; i++) {
                NSDictionary * dict = [result objectAtIndex:i];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    TaskListModel * model = [[TaskListModel alloc] initWithDictionary:dict];
                    [self.datsSource addObject:model];
                }
            }
        }
        [self createTaskChooseView];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取任务类型失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"获取任务类型失败" inView:self.view];
        
    }];
}

- (void)createTaskChooseView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[TaskTableViewCell class] forCellReuseIdentifier:@"TaskTableViewCell"];
    self.tableView.separatorColor = UIColorFromRGB(0xeeeeee);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datsSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TaskTableViewCell" forIndexPath:indexPath];
    
    TaskListModel * model = [self.datsSource objectAtIndex:indexPath.section];
    [cell configWithModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TaskListModel * model = [self.datsSource objectAtIndex:indexPath.section];
    if (model.type_id == TaskType_Install) {
        // 安装
        InstallAndAcceptViewController *ia = [[InstallAndAcceptViewController alloc] initWithTaskType:TaskType_Install];
        ia.title = model.type_name;
        [self.navigationController pushViewController:ia animated:YES];
    }else if (model.type_id == TaskType_InfoCheck){
        // 巡检
        inforDetectionViewController *iv = [[inforDetectionViewController alloc] initWithTaskType:TaskType_InfoCheck];
        iv.title = model.type_name;
        [self.navigationController pushViewController:iv animated:YES];
    }else if (model.type_id == TaskType_NetTransform){
        // 网络
        NetworkTransforViewController *nt = [[NetworkTransforViewController alloc] initWithTaskType:TaskType_NetTransform];
        nt.title = model.type_name;
        [self.navigationController pushViewController:nt animated:YES];
    }else if (model.type_id == TaskType_Repair){
        // 维修
        InstallAndAcceptViewController *rc = [[InstallAndAcceptViewController alloc] initWithTaskType:TaskType_Repair];
        rc.title = model.type_name;
        [self.navigationController pushViewController:rc animated:YES];
    }
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
