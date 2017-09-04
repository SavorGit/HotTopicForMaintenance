//
//  HomeUserInfoView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeUserInfoView.h"
#import "HotTopicTools.h"
#import "UserManager.h"
#import "RDAlertView.h"

@interface HomeUserInfoView ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * logoutButton;

@end

@implementation HomeUserInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createViews];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self createViews];
    }
    return self;
}

- (void)createViews
{
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.nameLabel.font = kPingFangRegular(15);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(kMainBoundsWidth - 185);
    }];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    self.logoutButton.titleLabel.font = kPingFangRegular(15);
    [self.logoutButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    self.logoutButton.layer.borderColor = UIColorFromRGB(0xc5c5c5).CGColor;
    self.logoutButton.layer.borderWidth = .5f;
    self.logoutButton.layer.cornerRadius = 3.f;
    self.logoutButton.layer.masksToBounds = YES;
    [self addSubview:self.logoutButton];
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(85);
        make.height.mas_equalTo(25);
    }];
    [self.logoutButton addTarget:self action:@selector(UserLogout) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * versionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    versionLabel.font = kPingFangRegular(15);
    versionLabel.textAlignment = NSTextAlignmentRight;
    versionLabel.text = [@"运维端 v" stringByAppendingString:kSoftwareVersion];
    [self addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-5);
        make.width.mas_equalTo(90);
    }];
}

- (void)UserLogout
{
    RDAlertAction * action1 = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
        
    } bold:NO];
    RDAlertAction * action2 = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
        [HotTopicTools removeFileOnPath:UserInfoCachePath];
        [UserManager manager].user = nil;
    } bold:YES];
    
    RDAlertView * alert = [[RDAlertView alloc] initWithTitle:@"提示" message:@"是否要注销当前登录账号"];
    [alert addActions:@[action1, action2]];
    [alert show];
}

- (void)reloadUserInfo
{
    if ([UserManager manager].user) {
        self.logoutButton.alpha = 1.f;
        self.nameLabel.text = [@" 登录账号：" stringByAppendingString:[UserManager manager].user.username];
    }else{
        self.logoutButton.alpha = 0.f;
        self.nameLabel.text = @" 登录账号：无";
    }
}

@end
