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
#import "SearchHotelRequest.h"

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
}

- (void)initInfo{
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
}

- (void)creatSubViews{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 30, 33);
    [button addTarget:self action:@selector(navBackButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(27.5);
        make.left.mas_equalTo(3);
        make.size.mas_equalTo(CGSizeMake(30, 33));
    }];
    
    
    self.searchBgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.searchBgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.searchBgView];
    [self.searchBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.equalTo(button.mas_right).offset(0);
        make.right.mas_equalTo(0);
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
        make.right.mas_equalTo(- 33);
        make.width.mas_equalTo(kMainBoundsWidth - 76);
        make.height.mas_equalTo(30);
    }];
    
    if ([self.searchField canBecomeFirstResponder]) {
        [self.searchField becomeFirstResponder];
    }
}

- (void)navBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self dataRequest];
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

- (void)dataRequest
{
//    self.searchField.text = @"永峰";
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在搜索" inView:self.view];
    SearchHotelRequest * request = [[SearchHotelRequest alloc] initWithHotelName:self.searchField.text];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        [self.dataSource removeAllObjects];
        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSArray *resultArr = [dataDict objectForKey:@"list"];
        [self.dataSource removeAllObjects];
        for (int i = 0; i < resultArr.count; i ++) {
            RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] initWithDictionary:resultArr[i]];
            [self.dataSource addObject:tmpModel];
        }
        
        [self.tableView reloadData];
        if (self.dataSource.count == 0) {
            [MBProgressHUD showTextHUDWithText:@"没有找到对应的酒楼" inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取失败，小热点正在休息~" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:NO];
        [MBProgressHUD showTextHUDWithText:@"获取失败，网络出现问题了~" inView:self.view];
        
    }];
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
    
    RestaurantRankModel *tmpModel = [self.dataSource objectAtIndex:indexPath.row];
    RestaurantRankInforViewController *riVC = [[RestaurantRankInforViewController alloc] initWithDetaiID:tmpModel.cid WithHotelNam:tmpModel.name];
    [self.navigationController pushViewController:riVC animated:YES];
    
}

- (void)dealloc
{
    [SearchHotelRequest cancelRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
