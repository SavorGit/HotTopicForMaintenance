//
//  RepairViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RepairViewController.h"
#import "RepairTableViewCell.h"

@interface RepairViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSArray * titleArray; //表项标题
@property (nonatomic, strong) NSArray * otherTitleArray; //表项标题

@end

@implementation RepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubViews];
    
    // Do any additional setup after loading the view.
}

- (void)creatSubViews{
    
//    [self.tableView beginUpdates];
//    [self.tableView insertSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationLeft];
//    [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:3] withRowAnimation:UITableViewRowAnimationLeft];
//    [self.tableView endUpdates];
    
    self.title = @"发布任务";
    self.titleArray = [NSArray arrayWithObjects:@"选择酒楼",@"联系人",@"联系电话",@"地址",@"任务紧急程度", nil];
    self.otherTitleArray = [NSArray arrayWithObjects:@"版位名称",@"故障现象",@"故障照片", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleArray.count;
    }else if (section == 1){
        return self.otherTitleArray.count + 1;
    }else{
        return self.otherTitleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"RestaurantRankCell";
    RepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[RepairTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor lightGrayColor];
    
    if (indexPath.section == 0) {
        [cell configWithTitle:self.titleArray[indexPath.row] andContent:@"俏江南" andIdexPath:indexPath];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            [cell configWithTitle:@"版位数量" andContent:@"俏江南" andIdexPath:indexPath];
        }else{
            [cell configWithTitle:self.otherTitleArray[indexPath.row - 1] andContent:@"俏江南" andIdexPath:indexPath];
        }
        
    }else{
        [cell configWithTitle:self.otherTitleArray[indexPath.row] andContent:@"俏江南" andIdexPath:indexPath];
    }
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
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
