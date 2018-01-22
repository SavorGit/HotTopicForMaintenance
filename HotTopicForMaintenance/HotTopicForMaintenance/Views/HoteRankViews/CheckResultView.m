//
//  CheckResultView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "CheckResultView.h"
#import "HotTopicTools.h"

@interface CheckResultView ()

@property (nonatomic, strong) UIView * resultView;
@property (nonatomic, strong) NSDictionary * result;

@end

@implementation CheckResultView

- (instancetype)initWithResult:(NSDictionary *)result
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        [self createViews];
        
    }
    return self;
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    
    self.resultView = [[UIView alloc] initWithFrame:CGRectZero];
    self.resultView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.resultView];
    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(345 * scale);
        make.height.mas_equalTo(368 * scale);
    }];
    
    UILabel * titleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangMedium(16 * scale) alignment:NSTextAlignmentCenter];
    titleLabel.text = @"检测报告";
    [self.resultView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(19 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(18 * scale);
    }];
    
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView1.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self.resultView addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(19 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5 * scale);
    }];
    
    UILabel * platformLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    platformLabel.text = @"小平台：离线";
    [self.resultView addSubview:platformLabel];
    [platformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_bottom).offset(19 * scale);
        make.height.mas_equalTo(17 * scale);
        make.left.mas_equalTo(15 * scale);
    }];
    
    UILabel * boxLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    boxLabel.text = @"盐韵厅：在线 可以投屏点播";
    [self.resultView addSubview:boxLabel];
    [boxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(platformLabel.mas_bottom).offset(8 * scale);
        make.height.mas_equalTo(17 * scale);
        make.left.mas_equalTo(15 * scale);
    }];
    
    UILabel * networkLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    networkLabel.text = @"网络延时：外网(30秒)  内网(200毫秒)";
    [self.resultView addSubview:networkLabel];
    [networkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(boxLabel.mas_bottom).offset(8 * scale);
        make.height.mas_equalTo(17 * scale);
        make.left.mas_equalTo(15 * scale);
    }];
    
    UILabel * reasonLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    reasonLabel.text = @"离线原因（仅作为参考）";
    [self.resultView addSubview:reasonLabel];
    [reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(networkLabel.mas_bottom).offset(29 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(16 * scale);
    }];
    
    UILabel * reasonLabel1 = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    reasonLabel1.text = @"1、机顶盒没有开机";
    [self.resultView addSubview:reasonLabel1];
    [reasonLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reasonLabel.mas_bottom).offset(8 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(16 * scale);
    }];
    
    UILabel * reasonLabel2 = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    reasonLabel2.text = @"2、局域网拥堵";
    [self.resultView addSubview:reasonLabel2];
    [reasonLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reasonLabel1.mas_bottom).offset(8 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(16 * scale);
    }];
    
    UILabel * reasonLabel3 = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    reasonLabel3.text = @"3、外网网络断开等等";
    [self.resultView addSubview:reasonLabel3];
    [reasonLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(reasonLabel2.mas_bottom).offset(8 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(16 * scale);
    }];
    
    UIButton * reCheckButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0x24afec) font:kPingFangMedium(15 * scale) backgroundColor:[UIColor clearColor] title:@"重新测试" cornerRadius:3 * scale];
    reCheckButton.layer.borderColor = UIColorFromRGB(0x24afec).CGColor;
    reCheckButton.layer.borderWidth = 1 * scale;
    [self.resultView addSubview:reCheckButton];
    [reCheckButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(135 * scale / 2.f);
        make.bottom.mas_equalTo(-20 * scale);
        make.width.mas_equalTo(80 * scale);
        make.height.mas_equalTo(32 * scale);
    }];
    
    UIButton * okButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0x24afec) font:kPingFangMedium(15 * scale) backgroundColor:[UIColor clearColor] title:@"确定" cornerRadius:3 * scale];
    [okButton addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    okButton.layer.borderColor = UIColorFromRGB(0x24afec).CGColor;
    okButton.layer.borderWidth = 1 * scale;
    [self.resultView addSubview:okButton];
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(reCheckButton.mas_right).offset(50 * scale);
        make.bottom.mas_equalTo(-20 * scale);
        make.width.mas_equalTo(80 * scale);
        make.height.mas_equalTo(32 * scale);
    }];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)hidden
{
    [self removeFromSuperview];
}

@end
