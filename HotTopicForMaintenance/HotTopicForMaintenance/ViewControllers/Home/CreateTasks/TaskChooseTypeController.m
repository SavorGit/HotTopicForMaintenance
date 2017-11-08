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

@interface TaskChooseTypeController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray * datsSource;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation TaskChooseTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择任务类型";
    
    [self setupDatas];
    [self createTaskChooseView];
}

- (void)setupDatas
{
    TaskListModel * model1 = [[TaskListModel alloc] initWithType:TaskType_Install];
    TaskListModel * model2 = [[TaskListModel alloc] initWithType:TaskType_InfoCheck];
    TaskListModel * model3 = [[TaskListModel alloc] initWithType:TaskType_NetTransform];
    TaskListModel * model4 = [[TaskListModel alloc] initWithType:TaskType_Repair];
    
    self.datsSource = [NSArray arrayWithObjects:model1, model2, model3, model4, nil];
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
    
    if (indexPath.section == 0) {
        // 安装
        InstallAndAcceptViewController *ia = [[InstallAndAcceptViewController alloc] initWithTaskType:TaskType_Install];
        [self.navigationController pushViewController:ia animated:YES];
    }else if (indexPath.section == 1){
        // 巡检
        inforDetectionViewController *iv = [[inforDetectionViewController alloc] initWithTaskType:TaskType_InfoCheck];
        [self.navigationController pushViewController:iv animated:YES];
    }else if (indexPath.section == 2){
        // 网络
        NetworkTransforViewController *nt = [[NetworkTransforViewController alloc] initWithTaskType:TaskType_NetTransform];
        [self.navigationController pushViewController:nt animated:YES];
    }else if (indexPath.section == 3){
        // 维修
        InstallAndAcceptViewController *rc = [[InstallAndAcceptViewController alloc] initWithTaskType:TaskType_Repair];
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
