//
//  SearchHotelViewController.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SearchHotelViewController.h"
#import "SearchTableViewCell.h"
#import "RestaurantRankInforViewController.h"
#import "SearchHotelRequest.h"
#import "AutoEnableView.h"
#import "UserManager.h"

@interface SearchHotelViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, strong) UITextField * searchField;
@property (nonatomic, assign) NSInteger classType;


@end

@implementation SearchHotelViewController

- (instancetype)initWithClassType:(NSInteger)classType
{
    if (self = [super init]) {
        self.classType = classType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self creatSubViews];
}

- (void)initInfo{
    
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
}

- (void)creatSubViews{
    
    AutoEnableView * searchView = [[AutoEnableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth - 60 - 15, 30)];
    searchView.backgroundColor = UIColorFromRGB(0x00a8e0);
    searchView.layer.cornerRadius = 5.f;
    searchView.layer.masksToBounds = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searchView];
    
    self.searchField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.searchField.font = kPingFangLight(15);
    self.searchField.borderStyle = UITextBorderStyleRoundedRect;
    self.searchField.placeholder = @"搜索酒楼";
    self.searchField.returnKeyType = UIReturnKeySearch;
    self.searchField.delegate = self;
    self.searchField.tintColor = kNavBackGround;
    [searchView addSubview:self.searchField];
    [self.searchField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    if ([self.searchField canBecomeFirstResponder]) {
        [self.searchField becomeFirstResponder];
    }
}

- (void)navBackButtonClicked:(UIButton *)sender
{
    if (self.searchField.isFirstResponder) {
        [self.searchField resignFirstResponder];
    }
    [super navBackButtonClicked:sender];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (isEmptyString(self.searchField.text)) {
        [MBProgressHUD showTextHUDWithText:@"请输入酒楼名称" inView:self.view];
        return NO;
    }
    
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
    BGNetworkRequest * request;
    if ([UserManager manager].user.roletype == UserRoleType_SingleVersion) {
        
    }else{
        request = [[SearchHotelRequest alloc] initWithHotelName:self.searchField.text];
    }
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
            make.edges.mas_equalTo(0);
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
    if (self.classType == 1) {
        if (_backHotel) {
            _backHotel(tmpModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        RestaurantRankInforViewController *riVC = [[RestaurantRankInforViewController alloc] initWithDetaiID:tmpModel.cid WithHotelNam:tmpModel.name];
        [self.navigationController pushViewController:riVC animated:YES];
    }
}

- (void)dealloc
{
    [self closeKeyBorad];
    [SearchHotelRequest cancelRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
