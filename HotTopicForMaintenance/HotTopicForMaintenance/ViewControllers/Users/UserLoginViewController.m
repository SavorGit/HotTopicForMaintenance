//
//  UserLoginViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserLoginViewController.h"
#import "UserLoginRequest.h"
#import "UserManager.h"
#import "HotTopicTools.h"

@interface UserLoginViewController ()

@property (nonatomic, strong) UIView * loginView;
@property (nonatomic, strong) UIView * logoView;
@property (nonatomic, strong) UIView * userInputView;
@property (nonatomic, strong) UITextField * nameTextFiled;
@property (nonatomic, strong) UITextField * passwordTextFiled;

@end

@implementation UserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
}

- (void)setupViews
{
    self.loginView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.loginView];
    
    UILabel * versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    versionLabel.font = kPingFangRegular(16);
    versionLabel.textColor = UIColorFromRGB(0x333333);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.text = [@"v" stringByAppendingString:kSoftwareVersion];
    [self.view addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    
    [self createLogView];
    [self createUserInputView];
}

- (void)createLogView
{
    self.logoView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.loginView addSubview:self.logoView];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.loginView.frame.size.height / 3);
    }];
    UIImageView * logo = [[UIImageView alloc] initWithFrame:CGRectZero];
    [logo setImage:[UIImage imageNamed:@"logo"]];
    [self.logoView addSubview:logo];
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(40);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    UILabel * logoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    logoLabel.font = kPingFangRegular(15);
    logoLabel.textColor = UIColorFromRGB(0x333333);
    logoLabel.textAlignment = NSTextAlignmentCenter;
    logoLabel.text = @"小热点运维端";
    [self.logoView addSubview:logoLabel];
    [logoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logo.mas_bottom).offset(10);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
}

- (void)createUserInputView
{
    self.userInputView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.userInputView];
    [self.userInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoView.mas_bottom).offset(0);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    self.nameTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameTextFiled.font = kPingFangLight(15);
    self.nameTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTextFiled.placeholder = @"账号";
    [self.userInputView addSubview:self.nameTextFiled];
    [self.nameTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 5 * 3);
        make.height.mas_equalTo(35);
    }];
    
    self.passwordTextFiled = [[UITextField alloc] initWithFrame:CGRectZero];
    self.passwordTextFiled.font = kPingFangLight(15);
    self.passwordTextFiled.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordTextFiled.secureTextEntry = YES;
    self.passwordTextFiled.placeholder = @"密码";
    [self.userInputView addSubview:self.passwordTextFiled];
    [self.passwordTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameTextFiled.mas_bottom).offset(25);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth / 5 * 3);
        make.height.mas_equalTo(35);
    }];
    
    UIButton * loginButton = [[UIButton alloc] initWithFrame:CGRectZero];
    loginButton.titleLabel.font = kPingFangRegular(15);
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    loginButton.layer.borderColor = UIColorFromRGB(0xc5c5c5).CGColor;
    loginButton.layer.borderWidth = .5f;
    loginButton.layer.cornerRadius = 3.f;
    loginButton.layer.masksToBounds = YES;
    [self.userInputView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextFiled.mas_bottom).offset(50);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(40);
    }];
    [loginButton addTarget:self action:@selector(startLogin) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:UserAccountPath]) {
        NSDictionary * userInfo = [NSDictionary dictionaryWithContentsOfFile:UserAccountPath];
        NSString * name = [userInfo objectForKey:@"name"];
        NSString * password = [userInfo objectForKey:@"password"];
        if (!isEmptyString(name) && !isEmptyString(password)) {
            self.nameTextFiled.text = name;
            self.passwordTextFiled.text = password;
            [self startLogin];
        }
    }
}

- (void)startLogin
{
    NSString * name = self.nameTextFiled.text;
    if (isEmptyString(name)) {
        [MBProgressHUD showTextHUDWithText:@"请输入账号" inView:self.view];
        return;
    }
    
    NSString * password = self.passwordTextFiled.text;
    if (isEmptyString(password)) {
        [MBProgressHUD showTextHUDWithText:@"请输入密码" inView:self.view];
        return;
    }
    
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在登录" inView:self.view];
    UserLoginRequest * request = [[UserLoginRequest alloc] initWithName:name password:password];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:NO];

        
        NSDictionary * userInfo = [response objectForKey:@"result"];
        [HotTopicTools saveFileOnPath:UserAccountPath withDictionary:@{@"name":name,@"password":password}];
        UserModel * user = [[UserModel alloc] initWithDictionary:userInfo];
        
        NSDictionary * RoleList = [userInfo objectForKey:@"skill_list"];
        if (RoleList && [RoleList isKindOfClass:[NSDictionary class]]) {
            NSDictionary * roleInfo = [RoleList objectForKey:@"role_info"];
            if (roleInfo && [roleInfo isKindOfClass:[NSDictionary class]]) {
                NSInteger roleType = [[roleInfo objectForKey:@"id"] integerValue];
                NSString * roleName = [roleInfo objectForKey:@"name"];
                if (!isEmptyString(roleName)) {
                    user.roletype = roleType;
                    user.roleName = roleName;
                }
            }
        }
        
        NSArray * cityList = [RoleList objectForKey:@"manage_city"];
        if (cityList && [cityList isKindOfClass:[NSArray class]]) {
            for (NSInteger i = 0; i < cityList.count; i++) {
                NSDictionary * cityInfo  = [cityList objectAtIndex:i];
                CityModel * cityModel = [[CityModel alloc] initWithDictionary:cityInfo];
                [user.cityArray addObject:cityModel];
            }
        }
        
        if (user.roletype == UserRoleType_HandleTask) {
            NSArray * skillList = [RoleList objectForKey:@"skill_info"];
            if (skillList && [skillList isKindOfClass:[NSArray class]]) {
                for (NSInteger i = 0; i < skillList.count; i++) {
                    NSDictionary * skillInfo  = [skillList objectAtIndex:i];
                    SkillModel * skillModel = [[SkillModel alloc] initWithDictionary:skillInfo];
                    [user.skillArray addObject:skillModel];
                }
            }
            
            user.is_lead_install = [[RoleList objectForKey:@"is_lead_install"] integerValue];
        }
        
        [UserManager manager].user = user;
        [MBProgressHUD showTextHUDWithText:@"登录成功" inView:[UIApplication sharedApplication].keyWindow];
        [self closeKeyBorad];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        [hud hideAnimated:NO];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"登录失败，小热点正在休息~" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [hud hideAnimated:NO];
        [MBProgressHUD showTextHUDWithText:@"登录失败，网络出现问题了~" inView:self.view];
        
    }];
}

 - (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self closeKeyBorad];
}

- (void)closeKeyBorad
{
    if ([self.nameTextFiled canResignFirstResponder]) {
        [self.nameTextFiled resignFirstResponder];
    }
    if ([self.passwordTextFiled canResignFirstResponder]) {
        [self.passwordTextFiled resignFirstResponder];
    }
}

//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回当前屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
