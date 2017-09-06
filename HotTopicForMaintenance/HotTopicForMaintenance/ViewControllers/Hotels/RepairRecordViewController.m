//
//  RepairRecordViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RepairRecordViewController.h"
#import "UserManager.h"
#import "GetAllUserRequest.h"
#import "GetRepairRecordListRequest.h"
#import "RepairRecordTableViewCell.h"
#import "RepairRecordModel.h"
#import "RepairRecordDetailModel.h"
#import "HotTopicTools.h"
#import "MJRefresh.h"

@interface RepairRecordViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UserModel * user;
@property (nonatomic, assign) BOOL isChooseUser;
@property (nonatomic, strong) UITableView * userTableView;
@property (nonatomic, strong) NSMutableArray * allUsers;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, assign) NSInteger pageNumber;

@end

@implementation RepairRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.user = [UserManager manager].user;
    self.isChooseUser = NO;
    
    if ([UserManager manager].allUsers) {
        [self setupViews];
    }else{
        [self getAllUsers];
    }
}

- (void)setupViews
{
    self.pageNumber = 1;
    [self createTitleButton];
    [self createTableView];
    [self createUserTableView];
    [self requestRecordList];
}

- (void)requestRecordList
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载维修记录" inView:self.view];
    
    self.pageNumber = 1;
    [self.dataSource removeAllObjects];
    
    [self requestRedordWithPageNumber:self.pageNumber success:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        if ([dataDict objectForKey:@"list"]) {
            
            NSArray * array = [dataDict objectForKey:@"list"];
            for (NSInteger i = 0; i < array.count; i++) {
                NSDictionary * dict = [array objectAtIndex:i];
                RepairRecordModel * model = [[RepairRecordModel alloc] initWithDictionary:dict];
                
                NSArray * listArray = [dict objectForKey:@"repair_list"];
                
                model.recordList = [NSMutableArray new];
                for (NSInteger i = 0; i < listArray.count; i++) {
                    RepairRecordDetailModel * detailModel = [[RepairRecordDetailModel alloc] initWithDictionary:[listArray objectAtIndex:i]];
                    [model.recordList addObject:detailModel];
                }
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
            self.pageNumber++;
            [hud hideAnimated:YES];
            
        }else{
            
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
            
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"加载失败" inView:self.view];
        
    }];
    
}

- (void)createTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.tableView registerClass:[RepairRecordTableViewCell class] forCellReuseIdentifier:@"RepairRecordCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)createUserTableView
{
    self.allUsers = [NSMutableArray arrayWithArray:[UserManager manager].allUsers];
    
    self.userTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.userTableView.backgroundColor = VCBackgroundColor;
    self.userTableView.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
    self.userTableView.layer.borderWidth = .5f;
    self.userTableView.delegate = self;
    self.userTableView.dataSource = self;
    [self.userTableView setSeparatorInset:UIEdgeInsetsZero];
    [self.userTableView setLayoutMargins:UIEdgeInsetsZero];
    [self.userTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"userTableViewCell"];
    [self.view addSubview:self.userTableView];
    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(280);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(-280);
        make.right.mas_equalTo(-20);
    }];
}

- (void)getAllUsers
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载用户信息" inView:self.view];
    
    GetAllUserRequest * request = [[GetAllUserRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"result"]) {
            
            [UserManager manager].allUsers = [NSMutableArray new];
            NSArray * array = [response objectForKey:@"result"];
            for (NSInteger i = 0; i < array.count; i++) {
                UserModel * model = [[UserModel alloc] initWithDictionary:[array objectAtIndex:i]];
                [[UserManager manager].allUsers addObject:model];
            }
            [self createTitleButton];
            [hud hideAnimated:NO];
            [self setupViews];
            
        }else{
            
            [hud hideAnimated:NO];
            [MBProgressHUD showTextHUDWithText:@"信息加载失败" inView:self.view];
            
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        [MBProgressHUD showTextHUDWithText:@"信息加载失败" inView:self.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:NO];
        [MBProgressHUD showTextHUDWithText:@"信息加载失败" inView:self.view];
        
    }];
}

- (void)createTitleButton
{
    NSString * title = self.user.nickname;
    
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setImage:[UIImage imageNamed:@"xlxz"] forState:UIControlStateNormal];
    titleButton.titleLabel.font = kPingFangRegular(16);
    [titleButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [titleButton addTarget:self action:@selector(titleButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
    titleButton.imageView.contentMode = UIViewContentModeCenter;
    
    CGFloat maxWidth = kMainBoundsWidth - 150;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGSize size = [title boundingRectWithSize:CGSizeMake(1000, 30) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    if (size.width > maxWidth) {
        size.width = maxWidth;
    }
    titleButton.frame = CGRectMake(0, (kMainBoundsWidth - size.width - 30) / 2, size.width + 30, size.height);
    
    [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, size.width + 15, 0, 0)];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10 + 10)];
    
    [titleButton setTitle:title forState:UIControlStateNormal];
    self.navigationItem.titleView = titleButton;
}

- (void)titleButtonDidBeClicked
{
    self.isChooseUser = !self.isChooseUser;
    if (self.isChooseUser) {
        [self stratChooseUser];
    }else{
        [self endChooseUser];
    }
}

- (void)stratChooseUser
{
    UIButton * button = (UIButton *)self.navigationItem.titleView;
    button.userInteractionEnabled = NO;
    
    self.isChooseUser = YES;
    [self.userTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:.2f animations:^{
        [self.view layoutIfNeeded];
        button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        button.userInteractionEnabled = YES;
    }];
}

- (void)endChooseUser
{
    UIButton * button = (UIButton *)self.navigationItem.titleView;
    button.userInteractionEnabled = NO;
    
    self.isChooseUser = NO;
    [self.userTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-280);
    }];
    [UIView animateWithDuration:.2f animations:^{
        [self.view layoutIfNeeded];
        button.imageView.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        button.userInteractionEnabled = YES;
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.userTableView) {
        return 1;
    }
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.userTableView) {
        return self.allUsers.count;
    }
    
    RepairRecordModel * model = [self.dataSource objectAtIndex:section];
    return model.recordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.userTableView) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"userTableViewCell" forIndexPath:indexPath];
        
        UserModel * user = [self.allUsers objectAtIndex:indexPath.row];
        cell.textLabel.text = user.nickname;
        cell.textLabel.font = kPingFangRegular(15);
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    RepairRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RepairRecordCell" forIndexPath:indexPath];
    RepairRecordModel * model = [self.dataSource objectAtIndex:indexPath.section];
    [cell configWithModel:[model.recordList objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.userTableView) {
        return 40;
    }
    
    RepairRecordModel * model = [self.dataSource objectAtIndex:indexPath.section];
    RepairRecordDetailModel * detailModel = [model.recordList objectAtIndex:indexPath.row];
    
    CGFloat height = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 30 title:[@"维修记录：" stringByAppendingString:detailModel.repair_error] font:kPingFangRegular(14)];
    
    return 61 + height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.userTableView) {
        self.user = [self.allUsers objectAtIndex:indexPath.row];
        [self createTitleButton];
        UIButton * button = (UIButton *)self.navigationItem.titleView;
        button.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        [self endChooseUser];
        [self requestRecordList];
    }
}

- (void)requestRedordWithPageNumber:(NSInteger)pageNumber success:(BGSuccessCompletionBlock)successCompletionBlock businessFailure:(BGBusinessFailureBlock)businessFailureBlock networkFailure:(BGNetworkFailureBlock)networkFailureBlock
{
    GetRepairRecordListRequest * request = [[GetRepairRecordListRequest alloc] initWithUserID:self.user.userid pageNum:[NSString stringWithFormat:@"%ld", pageNumber]];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        successCompletionBlock(request, response);
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        businessFailureBlock(request, response);
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        networkFailureBlock(request, error);
        
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
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
