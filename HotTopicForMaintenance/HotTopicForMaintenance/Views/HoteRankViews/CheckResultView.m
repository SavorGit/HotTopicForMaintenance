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

@property (nonatomic, copy) void (^handle)();
@property (nonatomic, strong) UIView * resultView;
@property (nonatomic, strong) NSDictionary * result;

@end

@implementation CheckResultView

- (instancetype)initWithResult:(NSDictionary *)result reCheckHandle:(void (^)())handle
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.handle = handle;
        self.result = result;
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
    platformLabel.text = [NSString stringWithFormat:@"%@：%@", [self.result objectForKey:@"small_device_name"], [self.result objectForKey:@"small_device_state"]];
    [self.resultView addSubview:platformLabel];
    [platformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_bottom).offset(19 * scale);
        make.height.mas_equalTo(17 * scale);
        make.left.mas_equalTo(15 * scale);
    }];
    
    UILabel * boxLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x222222) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    boxLabel.text = [NSString stringWithFormat:@"%@：%@", [self.result objectForKey:@"box_device_name"],[self.result objectForKey:@"box_device_state"]];
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
    
    NSArray * reasonList = [self.result objectForKey:@"remark"];
    NSString * reason;
    for (NSInteger i = 0; i < reasonList.count; i++) {
        
        NSString * str = [reasonList objectAtIndex:i];
        if (i == 0) {
            reason = str;
        }else{
            reason = [reason stringByAppendingString:[NSString stringWithFormat:@"\n%@", str]];
        }
        
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:reason];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5 * scale; // 调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, reason.length)];
    
    UILabel * reasonLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    reasonLabel.numberOfLines = 0;
    reasonLabel.attributedText = attributedString;
    [self.resultView addSubview:reasonLabel];
    [reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(networkLabel.mas_bottom).offset(29 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
    }];
    
    UIButton * reCheckButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0x24afec) font:kPingFangMedium(15 * scale) backgroundColor:[UIColor clearColor] title:@"重新测试" cornerRadius:3 * scale];
    [reCheckButton addTarget:self action:@selector(reCheckDidClicked) forControlEvents:UIControlEventTouchUpInside];
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

- (void)reCheckDidClicked
{
    [self hidden];
    if (self.handle) {
        self.handle();
    }
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
