//
//  SystemStatusHeaderView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/15.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "SystemStatusHeaderView.h"
#import "HotTopicTools.h"

@interface SystemStatusHeaderView ()

@property (nonatomic, strong) UILabel * updateTimeLabel;

//酒楼
@property (nonatomic, strong) UILabel * hotelOnlineLabel;
@property (nonatomic, strong) UILabel * hotelOutlineLabel;
@property (nonatomic, strong) UILabel * hotelStatusLabel;

//小平台
@property (nonatomic, strong) UILabel * platformNormaLabel;
@property (nonatomic, strong) UILabel * platformFaultLabel;

//机顶盒
@property (nonatomic, strong) UILabel * boxNormaLabel;
@property (nonatomic, strong) UILabel * boxFaultLabel;
@property (nonatomic, strong) UILabel * blackListLabel;

@end

@implementation SystemStatusHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    if (self = [super initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 315 * scale)]) {
        [self createViews];
    }
    return self;
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.backgroundColor = [UIColor whiteColor];
    
//在线状态
    UILabel * onLineStatusLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x62ad19) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    onLineStatusLabel.text = @"在线状态";
    [self addSubview:onLineStatusLabel];
    [onLineStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.updateTimeLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x999999) font:kPingFangRegular(13 * scale) alignment:NSTextAlignmentLeft];
    self.updateTimeLabel.text = @"更新时间：2017-01-08  09:30";
    [self addSubview:self.updateTimeLabel];
    [self.updateTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20 * scale);
        make.left.mas_equalTo(onLineStatusLabel.mas_right).offset(10 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    UIButton * refreshButton = [HotTopicTools buttonWithTitleColor:[UIColor whiteColor] font:kPingFangRegular(14 * scale) backgroundColor:[UIColor clearColor] title:@""];
    [refreshButton setBackgroundImage:[UIImage imageNamed:@"shuaxin"] forState:UIControlStateNormal];
    [self addSubview:refreshButton];
    [refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(48 * scale);
        make.height.mas_equalTo(23 * scale);
    }];
    
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView1.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(onLineStatusLabel.mas_bottom).offset(19 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f * scale);
    }];
    
//酒楼
    UILabel * hotelLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    hotelLabel.text = @"酒楼";
    [self addSubview:hotelLabel];
    [hotelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_bottom).offset(19 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * hotelOnlineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [hotelOnlineImageView setImage:[UIImage imageNamed:@"zaixian"]];
    [self addSubview:hotelOnlineImageView];
    [hotelOnlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hotelLabel).offset(3 * scale);
        make.left.mas_equalTo(92 * scale);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.hotelOnlineLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.hotelOnlineLabel.text = @"在线  98";
    [self addSubview:self.hotelOnlineLabel];
    [self.hotelOnlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hotelLabel);
        make.left.mas_equalTo(hotelOnlineImageView.mas_right).offset(5 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * hotelOutlineImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [hotelOutlineImageView setImage:[UIImage imageNamed:@"lixian"]];
    [self addSubview:hotelOutlineImageView];
    [hotelOutlineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hotelLabel).offset(3 * scale);
        make.left.mas_equalTo(238 * scale);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.hotelOutlineLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.hotelOutlineLabel.text = @"离线  16";
    [self addSubview:self.hotelOutlineLabel];
    [self.hotelOutlineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(hotelLabel);
        make.left.mas_equalTo(hotelOutlineImageView.mas_right).offset(5 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.hotelStatusLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(13 * scale) alignment:NSTextAlignmentLeft];
    self.hotelStatusLabel.text = @"(离线小于72小时：6     离线大于72小时：10)";
    [self addSubview:self.hotelStatusLabel];
    [self.hotelStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hotelOnlineImageView);
        make.top.mas_equalTo(self.hotelOnlineLabel.mas_bottom).offset(10 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
//小平台
    UILabel * platformLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    platformLabel.text = @"小平台";
    [self addSubview:platformLabel];
    [platformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotelStatusLabel.mas_bottom).offset(29 * scale);
        make.left.mas_equalTo(hotelLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * platformNormalImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [platformNormalImageView setImage:[UIImage imageNamed:@"zaixian"]];
    [self addSubview:platformNormalImageView];
    [platformNormalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(platformLabel).offset(3 * scale);
        make.left.mas_equalTo(hotelOnlineImageView);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.platformNormaLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.platformNormaLabel.text = @"正常  34";
    [self addSubview:self.platformNormaLabel];
    [self.platformNormaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(platformLabel);
        make.left.mas_equalTo(self.hotelOnlineLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * platformFaultImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [platformFaultImageView setImage:[UIImage imageNamed:@"lixian"]];
    [self addSubview:platformFaultImageView];
    [platformFaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(platformNormalImageView);
        make.left.mas_equalTo(hotelOutlineImageView);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.platformFaultLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.platformFaultLabel.text = @"异常  70";
    [self addSubview:self.platformFaultLabel];
    [self.platformFaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(platformLabel);
        make.left.mas_equalTo(self.hotelOutlineLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
//机顶盒
    UILabel * boxLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    boxLabel.text = @"机顶盒";
    [self addSubview:boxLabel];
    [boxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(platformLabel.mas_bottom).offset(29 * scale);
        make.left.mas_equalTo(hotelLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * boxNormalImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [boxNormalImageView setImage:[UIImage imageNamed:@"zaixian"]];
    [self addSubview:boxNormalImageView];
    [boxNormalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boxLabel).offset(3 * scale);
        make.left.mas_equalTo(hotelOnlineImageView);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.boxNormaLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.boxNormaLabel.text = @"正常  34";
    [self addSubview:self.boxNormaLabel];
    [self.boxNormaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boxLabel);
        make.left.mas_equalTo(self.hotelOnlineLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * boxFaultImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [boxFaultImageView setImage:[UIImage imageNamed:@"lixian"]];
    [self addSubview:boxFaultImageView];
    [boxFaultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boxNormalImageView);
        make.left.mas_equalTo(hotelOutlineImageView);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.boxFaultLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.boxFaultLabel.text = @"异常  94";
    [self addSubview:self.boxFaultLabel];
    [self.boxFaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boxLabel);
        make.left.mas_equalTo(self.hotelOutlineLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * blackListImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [blackListImageView setImage:[UIImage imageNamed:@"hmd"]];
    [self addSubview:blackListImageView];
    [blackListImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boxLabel.mas_bottom).offset(22 * scale);
        make.left.mas_equalTo(hotelOnlineImageView);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.blackListLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.blackListLabel.text = @"黑名单  299";
    [self addSubview:self.blackListLabel];
    [self.blackListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boxLabel.mas_bottom).offset(18 * scale);
        make.left.mas_equalTo(self.hotelOnlineLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView2.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.blackListLabel.mas_bottom).offset(19 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f * scale);
    }];
    
    UILabel * remarkLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x999999) font:kPingFangRegular(12.5 * scale) alignment:NSTextAlignmentCenter];
    remarkLabel.text = @"(在线指10分钟以内；离线指大于10分钟；异常指大于72小时)";
    [self addSubview:remarkLabel];
    [remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-24 * scale);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(14 * scale);
    }];
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
}

@end
