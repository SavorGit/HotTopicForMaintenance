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
#import "RepairViewController.h"

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
    TaskModel * model1 = [[TaskModel alloc] initWithType:TaskType_Install];
    TaskModel * model2 = [[TaskModel alloc] initWithType:TaskType_InfoCheck];
    TaskModel * model3 = [[TaskModel alloc] initWithType:TaskType_NetTransform];
    TaskModel * model4 = [[TaskModel alloc] initWithType:TaskType_Repair];
    
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
    
    TaskModel * model = [self.datsSource objectAtIndex:indexPath.section];
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
        InstallAndAcceptViewController *ia = [[InstallAndAcceptViewController alloc] init];
        [self.navigationController pushViewController:ia animated:YES];
    }else if (indexPath.section == 1){
        NetworkTransforViewController *nt = [[NetworkTransforViewController alloc] init];
        [self.navigationController pushViewController:nt animated:YES];
    }else if (indexPath.section == 2){
        inforDetectionViewController *iv = [[inforDetectionViewController alloc] init];
        [self.navigationController pushViewController:iv animated:YES];
    }else if (indexPath.section == 3){
        RepairViewController *rc = [[RepairViewController alloc] init];
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