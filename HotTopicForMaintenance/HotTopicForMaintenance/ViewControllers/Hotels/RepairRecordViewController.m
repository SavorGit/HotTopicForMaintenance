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

@interface RepairRecordViewController ()

@property (nonatomic, strong) UserModel * user;
@property (nonatomic, assign) BOOL isChooseUser;
@property (nonatomic, strong) UITableView * userTableView;
@property (nonatomic, strong) NSMutableArray * allUsers;
@property (nonatomic, strong) NSMutableArray * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

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
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    [self createTitleButton];
    [self createUserTableView];
}

- (void)createUserTableView
{
//    self.allUsers = [NSMutableArray arrayWithArray:[UserManager manager].allUsers];
//    
//    self.userTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    self.userTableView.delegate = self;
//    self.userTableView.dataSource = self;
//    [self.userTableView setSeparatorInset:UIEdgeInsetsZero];
//    [self.userTableView setLayoutMargins:UIEdgeInsetsZero];
//    [self.view addSubview:self.userTableView];
//    [self.userTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(self.view.frame.size.height / 2);
//        make.left.mas_equalTo(20);
//        make.top.mas_equalTo(-self.view.frame.size.height / 2);
//        make.right.mas_equalTo(-20);
//    }];
//    self.userTableView.backgroundColor = UIColorFromRGB(0xf6f2ed);
}

- (void)getAllUsers
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载配置信息" inView:self.view];
    
    GetAllUserRequest * request = [[GetAllUserRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];
        if ([response objectForKey:@"result"]) {
            [UserManager manager].allUsers = [NSMutableArray arrayWithArray:[response objectForKey:@"result"]];
            [self createTitleButton];
        }else{
            [MBProgressHUD showTextHUDWithText:@"信息加载失败" inView:self.view];
        }
        [self setupViews];
        
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
    titleButton.titleLabel.font = [UIFont systemFontOfSize:16];
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
        
    }else{
        
    }
}

- (void)stratChooseUser
{
    
}

- (void)endChooseUser
{
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
