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
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(19 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5 * scale);
    }];
    
    UILabel * statusLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    statusLabel.text = @"小平台：离线";
    [self.resultView addSubview:statusLabel];
    [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_bottom).offset(19 * scale);
        make.height.mas_equalTo(17 * scale);
        make.left.mas_equalTo(15 * scale);
    }];
}

@end
