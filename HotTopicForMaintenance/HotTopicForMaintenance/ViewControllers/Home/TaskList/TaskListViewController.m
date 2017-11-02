//
//  TaskListViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskListViewController.h"
#import "TaskListModel.h"
#import "TaskListTableViewCell.h"
#import "TaskDetailViewController.h"

@interface TaskListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) TaskListType taskType;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation TaskListViewController

- (instancetype)initWithTaskListType:(TaskListType)type
{
    if (self = [super init]) {
        self.taskType = type;
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TaskListModel * model = [self.dataSource objectAtIndex:indexPath.section];
    TaskDetailViewController * vc = [[TaskDetailViewController alloc] initWithTaskListModel:model];
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
    TaskListModel * model = [self.dataSource objectAtIndex:indexPath.section];
    
    TaskListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"TaskListTableViewCell" forIndexPath:indexPath];
    [cell configWithTaskListModel:model];
    
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
    TaskListModel * model = [self.dataSource objectAtIndex:indexPath.section];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    switch (model.type) {
        case 1:
            return 134.f * scale + 1;
            break;
            
        case 2:
            return 182.f * scale + 3;
            break;
            
        case 3:
            return 206.f * scale + 4;
            break;
            
        case 4:
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
    
    switch (self.taskType) {
        case TaskListType_All:
            
        {
            for (NSInteger i = 0; i < 5; i++) {
                
                TaskListModel * model1 = [[TaskListModel alloc] init];
                model1.type = 3;
                model1.status = @"已完成";
                model1.handleName = @"维修";
                model1.cityName = @"北京";
                model1.remark = @"紧急";
                model1.deviceNumber = @"10";
                model1.hotelName = @"旺顺阁鱼头泡饼王府井店";
                model1.assignHandleTime = @"2017-09-26 (成通)";
                model1.createTime = @"2017-09-26 09:20 (辛丽娟)";
                model1.assignTime = @"2017-09-26 09:20 (宗艳丽)";
                model1.completeTime = @"2017-09-26 09:20 (成通)";
                model1.localtion = @"北京市东城区王府井大街新东安广场A123";
                model1.contacts = @"李师傅";
                model1.contactWay = @"13012345678";
                [self.dataSource addObject: model1];
                
                TaskListModel * model2 = [[TaskListModel alloc] init];
                model2.type = 4;
                model2.status = @"已拒绝";
                model2.handleName = @"安装";
                model2.cityName = @"北京";
                model2.deviceNumber = @"10";
                model2.hotelName = @"旺顺阁鱼头泡饼王府井店";
                model2.createTime = @"2017-09-26 09:20 (辛丽娟)";
                model2.refuseTime = @"2017-09-26 09:20 (宗艳丽)";
                model2.localtion = @"北京市东城区王府井大街新东安广场A123";
                model2.contacts = @"李师傅";
                model2.contactWay = @"13012345678";
                [self.dataSource addObject: model2];
                
                TaskListModel * model3 = [[TaskListModel alloc] init];
                model3.type = 1;
                model3.status = @"待指派";
                model3.handleName = @"网络";
                model3.cityName = @"北京";
                model3.hotelName = @"旺顺阁鱼头泡饼王府井店";
                model3.createTime = @"2017-09-26 09:20 (辛丽娟)";
                model3.localtion = @"北京市东城区王府井大街新东安广场A123";
                model3.contacts = @"李师傅";
                model3.contactWay = @"13012345678";
                [self.dataSource addObject: model3];
                
                TaskListModel * model4 = [[TaskListModel alloc] init];
                model4.type = 2;
                model4.status = @"待处理";
                model4.handleName = @"检测";
                model4.cityName = @"北京";
                model4.hotelName = @"旺顺阁鱼头泡饼王府井店";
                model4.assignHandleTime = @"2017-09-26 (成通)";
                model4.createTime = @"2017-09-26 09:20 (辛丽娟)";
                model4.assignTime = @"2017-09-26 09:20 (宗艳丽)";
                model4.localtion = @"北京市东城区王府井大街新东安广场A123";
                model4.contacts = @"李师傅";
                model4.contactWay = @"13012345678";
                [self.dataSource addObject: model4];
            }
        }
            
            break;
            
        case TaskListType_WaitAssign:
            
        {
            for (NSInteger i = 0; i < 20; i++) {
                TaskListModel * model3 = [[TaskListModel alloc] init];
                model3.type = 1;
                model3.status = @"待指派";
                model3.handleName = @"网络";
                model3.cityName = @"北京";
                model3.hotelName = @"旺顺阁鱼头泡饼王府井店";
                model3.createTime = @"2017-09-26 09:20 (辛丽娟)";
                model3.localtion = @"北京市东城区王府井大街新东安广场A123";
                model3.contacts = @"李师傅";
                model3.contactWay = @"13012345678";
                [self.dataSource addObject: model3];
            }
        }
            
            break;
            
        case TaskListType_WaitHandle:
            
        {
            for (NSInteger i = 0; i < 20; i++) {
                TaskListModel * model4 = [[TaskListModel alloc] init];
                model4.type = 2;
                model4.status = @"待处理";
                model4.handleName = @"检测";
                model4.cityName = @"北京";
                model4.hotelName = @"旺顺阁鱼头泡饼王府井店";
                model4.assignHandleTime = @"2017-09-26 (成通)";
                model4.createTime = @"2017-09-26 09:20 (辛丽娟)";
                model4.assignTime = @"2017-09-26 09:20 (宗艳丽)";
                model4.localtion = @"北京市东城区王府井大街新东安广场A123";
                model4.contacts = @"李师傅";
                model4.contactWay = @"13012345678";
                [self.dataSource addObject: model4];
            }
        }
            
            break;
            
        case TaskListType_Completed:
            
        {
            for (NSInteger i = 0; i < 20; i++) {
                TaskListModel * model1 = [[TaskListModel alloc] init];
                model1.type = 3;
                model1.status = @"已完成";
                model1.handleName = @"维修";
                model1.cityName = @"北京";
                model1.remark = @"紧急";
                model1.deviceNumber = @"10";
                model1.hotelName = @"旺顺阁鱼头泡饼王府井店";
                model1.assignHandleTime = @"2017-09-26 (成通)";
                model1.createTime = @"2017-09-26 09:20 (辛丽娟)";
                model1.assignTime = @"2017-09-26 09:20 (宗艳丽)";
                model1.completeTime = @"2017-09-26 09:20 (成通)";
                model1.localtion = @"北京市东城区王府井大街新东安广场A123";
                model1.contacts = @"李师傅";
                model1.contactWay = @"13012345678";
                [self.dataSource addObject: model1];
            }
        }
            
            break;
            
        default:
            break;
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
