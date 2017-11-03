//
//  RepairViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RepairViewController.h"
#import "RepairHeaderTableCell.h"
#import "RepairContentTableCell.h"
#import "PositionListViewController.h"
#import "DamageConfigRequest.h"
#import "RestaurantRankModel.h"


@interface RepairViewController ()<UITableViewDelegate,UITableViewDataSource,RepairHeaderTableDelegate,RepairContentDelegate>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSArray * titleArray; //表项标题
@property (nonatomic, strong) NSArray * otherTitleArray; //表项标题
@property (nonatomic, assign) NSInteger sectionNum; //组数
@property (nonatomic, strong) NSMutableArray * dConfigData; //数据源

@end

@implementation RepairViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sectionNum = 1;
    [self demageConfigRequest];
    [self creatSubViews];
}

- (void)creatSubViews{
    
    _dConfigData = [[NSMutableArray alloc] init];
    self.title = @"发布任务";
    self.titleArray = [NSArray arrayWithObjects:@"选择酒楼",@"联系人",@"联系电话",@"地址",@"任务紧急程度",@"版位数量",  nil];
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
    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 50 *8)];
//    headerView.backgroundColor = UIColorFromRGB(0xf8f6f1);
//    _tableView.tableHeaderView = headerView;
    
}

- (void)addNPress{
      [self.tableView beginUpdates];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.sectionNum inSection:1];
      [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      self.sectionNum = self.sectionNum + 1;
      [self.tableView endUpdates];
    
}

- (void)reduceNPress{
    if (self.sectionNum > 1) {
        [self.tableView beginUpdates];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.sectionNum - 1 inSection:1];
        [self.tableView  deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.sectionNum = self.sectionNum - 1;
        [self.tableView endUpdates];
    }
    
}

- (void)selectPosion:(UIButton *)btn{
    
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
    flVC.backDatas = ^(NSString *damageIdString ,NSString *name) {
        [btn setTitle:name forState:UIControlStateNormal];
    };
}

- (void)demageConfigRequest
{
    DamageConfigRequest * request = [[DamageConfigRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSArray *listArray = [dataDict objectForKey:@"list"];
        
        for (int i = 0; i < listArray.count; i ++) {
            RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] initWithDictionary:listArray[i]];
            [self.dConfigData addObject:tmpModel];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleArray.count;
    }else if (section == 1){
        return self.sectionNum;
    }else{
        return self.otherTitleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"RepairHeaderCell";
//        RepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        RepairHeaderTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[RepairHeaderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        [cell configWithTitle:self.titleArray[indexPath.row] andContent:@"俏江南" andIdexPath:indexPath];
        return cell;
    }else {
        
        static NSString *cellID = @"RestaurantRankCell";
        RepairContentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        //            RepairTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[RepairContentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        [cell configWithContent:@"机顶盒故障"  andIdexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 50 *3 + 10;
    }
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
}

@end
