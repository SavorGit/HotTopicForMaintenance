//
//  SearchHotelViewController.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SearchHotelViewController.h"
#import "RestaurantRankModel.h"
#import "SearchTableViewCell.h"
#import "RestaurantRankInforViewController.h"

@interface SearchHotelViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, strong) UIView * searchBgView; //数据源
@property (nonatomic, strong) UITextField * searchField; //数据源


@end

@implementation SearchHotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self creatSubViews];
    [self initData];
}

- (void)initData{
    
    for (int i = 0; i < 10; i ++) {
        RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] init];
        tmpModel.string1 = @"V1";
        tmpModel.string2 = @"B9876545678";
        tmpModel.string3 = @"V1机顶盒";
        tmpModel.string4 = @"3分钟前";
        tmpModel.string5 = @"2017-08-28 08：08";
        tmpModel.string6 = @"08-28 17：39（郑伟）";
        tmpModel.stateType = 0;
        tmpModel.selectType = NO;
        
        [self.dataSource addObject:tmpModel];
    }
    [self.tableView reloadData];
}

- (void)initInfo{
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
    
    
}

- (void)creatSubViews{

    self.searchBgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.searchBgView];
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.right.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(60);
    }];
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchField.font = kPingFangLight(15);
    self.searchField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchField.placeholder = @"搜索酒楼";
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.delegate = self;
    [self.searchBgView addSubview:self.searchField];
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth - 40);
        make.height.mas_equalTo(30);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self closeKeyBorad];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self closeKeyBorad];
}

- (void)closeKeyBorad
{
    if ([self.searchField canResignFirstResponder]) {
        [self.searchField resignFirstResponder];
    }
}

#pragma mark -- 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(75);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
    }
    
    return _tableView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantRankModel * model = [self.dataSource objectAtIndex:indexPath.row];
    static NSString *cellID = @"RestaurantRankCell";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell configWithModel:model];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RestaurantRankInforViewController *riVC = [[RestaurantRankInforViewController alloc] init];
    [self.navigationController pushViewController:riVC animated:YES];
    
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
