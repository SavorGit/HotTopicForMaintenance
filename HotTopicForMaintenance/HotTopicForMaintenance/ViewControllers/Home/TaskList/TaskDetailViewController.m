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

@interface TaskDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) TaskListModel * taskListModel;

@end

@implementation TaskDetailViewController

- (instancetype)initWithTaskListModel:(TaskListModel *)model
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
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = VCBackgroundColor;
    [self.tableView registerClass:[DeviceFaultTableViewCell class] forCellReuseIdentifier:@"DeviceFaultTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    TaskDetailView * view = [[TaskDetailView alloc] initWithTaskListModel:self.taskListModel];
    self.tableView.tableHeaderView = view;
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
