//
//  SystemStatusController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SystemStatusController.h"
#import "SystemStatusHeaderView.h"
#import "SystemStatusSectionHeaderView.h"
#import "SystemStatusHotelCell.h"
#import "SystemStatusBoxCell.h"

@interface SystemStatusController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString * cityID;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation SystemStatusController

- (instancetype)initWithCityID:(NSString *)cityID
{
    if (self = [super init]) {
        self.cityID = cityID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    self.tableView.tableHeaderView = [[SystemStatusHeaderView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else if (section == 2) {
        return 4;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SystemStatusHotelCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SystemStatusHotelCell" forIndexPath:indexPath];
        
        return cell;
    }else if (indexPath.section == 2) {
        SystemStatusBoxCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SystemStatusBoxCell" forIndexPath:indexPath];
        
        return cell;
    }
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SystemStatusCell"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            return 90 * scale;
        }
        return 70 * scale;
    }else if (indexPath.section == 2){
        if (indexPath.row == 3) {
            return 90 * scale;
        }
        return 70 * scale;
    }
    
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SystemStatusSectionHeaderView * headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"SystemStatusSectionHeaderView"];
    
    [headerView configWithType:section];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 53 * kMainBoundsWidth / 375.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10 * kMainBoundsWidth / 375.f;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        
        CGFloat scale = kMainBoundsWidth / 375.f;
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SystemStatusHotelCell class] forCellReuseIdentifier:@"SystemStatusHotelCell"];
        [_tableView registerClass:[SystemStatusBoxCell class] forCellReuseIdentifier:@"SystemStatusBoxCell"];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SystemStatusCell"];
        [_tableView registerClass:[SystemStatusSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"SystemStatusSectionHeaderView"];
        _tableView.contentInset = UIEdgeInsetsMake(10 * scale, 0, 10 * scale, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _tableView;
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
