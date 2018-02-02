//
//  BoxInfoTableHeaderView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "BoxInfoTableHeaderView.h"
#import "HotTopicTools.h"
#import "DownLoadListViewController.h"
#import "HotTopicTools.h"

@interface BoxInfoTableHeaderView ()

@property (nonatomic, strong) UILabel * boxNameLabel; //机顶盒名称
@property (nonatomic, strong) UILabel * boxMaclabel; //机顶盒MAC地址

@property (nonatomic, strong) UILabel * lastHeartTimeLabel; //最后心跳时间
@property (nonatomic, strong) UILabel * lastLogUploadTimeLabel; //最后日志上传时间
@property (nonatomic, strong) UILabel * repairListLabel; //维修记录

@property (nonatomic, strong) UILabel * currentStatusLabel; //当前状态
@property (nonatomic, strong) UILabel * mediaStatusLabel; //节目状态
@property (nonatomic, strong) UIButton * mediaDownLoadingButton; //节目查看正在下载
@property (nonatomic, strong) UILabel * adStatusLabel; //广告状态
@property (nonatomic, strong) UIButton * adDownLoadingButton; //广告查看正在下载

@property (nonatomic, strong) UIButton * pushListButton; //发布内容列表
@property (nonatomic, strong) UILabel * mediaDateLabel; //节目期号
@property (nonatomic, strong) UILabel * adDateLabel; //广告期号

@end

@implementation BoxInfoTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.backgroundColor = [UIColor whiteColor];
    
    self.frame = CGRectMake(0, 0, kMainBoundsWidth, 435 * scale);
    
    self.boxNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    self.boxNameLabel.text = @"无";
    [self addSubview:self.boxNameLabel];
    [self.boxNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.boxMaclabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.boxMaclabel.text = @"无";
    [self addSubview:self.boxMaclabel];
    [self.boxMaclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.boxNameLabel);
        make.left.mas_equalTo(self.boxNameLabel.mas_right).offset(20 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIButton * testButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0x00bcee) font:kPingFangMedium(15 * scale) backgroundColor:[UIColor clearColor] title:@"一键测试" cornerRadius:3 * scale];
    [testButton addTarget:self action:@selector(testButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    testButton.layer.borderColor = UIColorFromRGB(0x00bcee).CGColor;
    testButton.layer.borderWidth = 1 * scale;
    [self addSubview:testButton];
    [testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(7 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(80 * scale);
        make.height.mas_equalTo(32 * scale);
    }];
    
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView1.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self addSubview:lineView1];
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(46 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    UILabel * lastHeartTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    lastHeartTitleLabel.text = @"最后心跳时间：";
    [self addSubview:lastHeartTitleLabel];
    [lastHeartTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView1.mas_bottom).offset(19 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.lastHeartTimeLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.lastHeartTimeLabel.text = @"无";
    [self addSubview:self.lastHeartTimeLabel];
    [self.lastHeartTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastHeartTitleLabel);
        make.left.mas_equalTo(lastHeartTitleLabel.mas_right);
        make.height.mas_equalTo(lastHeartTitleLabel);
    }];
    
    UILabel * lastUploadTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    lastUploadTitleLabel.text = @"最后日志上传时间：";
    [self addSubview:lastUploadTitleLabel];
    [lastUploadTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastHeartTitleLabel.mas_bottom).offset(18 * scale);
        make.left.mas_equalTo(lastHeartTitleLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.lastLogUploadTimeLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.lastLogUploadTimeLabel.text = @"无";
    [self addSubview:self.lastLogUploadTimeLabel];
    [self.lastLogUploadTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastUploadTitleLabel);
        make.left.mas_equalTo(lastUploadTitleLabel.mas_right);
        make.height.mas_equalTo(lastUploadTitleLabel);
    }];
    
    UILabel * repairTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    repairTitleLabel.text = @"维修记录：";
    [self addSubview:repairTitleLabel];
    [repairTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastUploadTitleLabel.mas_bottom).offset(18 * scale);
        make.left.mas_equalTo(lastHeartTitleLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.repairListLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.repairListLabel.numberOfLines = 0;
    self.repairListLabel.text = @"无";
    [self addSubview:self.repairListLabel];
    [self.repairListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(repairTitleLabel);
        make.left.mas_equalTo(repairTitleLabel.mas_right);
        make.width.mas_equalTo(270 * scale);
    }];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView2.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.repairListLabel.mas_bottom).offset(19 * scale);
        make.height.mas_equalTo(19 * scale);
        make.left.right.mas_equalTo(0);
    }];
    
    UILabel * currentStatusTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    currentStatusTitleLabel.text = @"当前状态：";
    [self addSubview:currentStatusTitleLabel];
    [currentStatusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_bottom).offset(19 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.currentStatusLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.currentStatusLabel.text = @"无";
    [self addSubview:self.currentStatusLabel];
    [self.currentStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(currentStatusTitleLabel);
        make.left.mas_equalTo(currentStatusTitleLabel.mas_right);
        make.height.mas_equalTo(currentStatusTitleLabel);
    }];
    
    UILabel * mediaStatusTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    mediaStatusTitleLabel.text = @"节目状态：";
    [self addSubview:mediaStatusTitleLabel];
    [mediaStatusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(currentStatusTitleLabel.mas_bottom).offset(18 * scale);
        make.left.mas_equalTo(currentStatusTitleLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.mediaStatusLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.mediaStatusLabel.text = @"无";
    [self addSubview:self.mediaStatusLabel];
    [self.mediaStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mediaStatusTitleLabel);
        make.left.mas_equalTo(mediaStatusTitleLabel.mas_right);
        make.height.mas_equalTo(mediaStatusTitleLabel);
    }];
    
    self.mediaDownLoadingButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xff4d55) font:kPingFangRegular(13 * scale) backgroundColor:[UIColor clearColor] title:@"查看正在下载" cornerRadius:2 * scale];
    self.mediaDownLoadingButton.layer.borderColor = UIColorFromRGB(0xff4d55).CGColor;
    self.mediaDownLoadingButton.layer.borderWidth = .5 * scale;
    [self.mediaDownLoadingButton addTarget:self action:@selector(lookMediaCurrentDownLoad) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.mediaDownLoadingButton];
    [self.mediaDownLoadingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mediaStatusTitleLabel).offset(-2 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(94 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    self.mediaDownLoadingButton.hidden = YES;
    
    UILabel * adStatusTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    adStatusTitleLabel.text = @"广告状态：";
    [self addSubview:adStatusTitleLabel];
    [adStatusTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mediaStatusTitleLabel.mas_bottom).offset(18 * scale);
        make.left.mas_equalTo(mediaStatusTitleLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.adStatusLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.adStatusLabel.text = @"无";
    [self addSubview:self.adStatusLabel];
    [self.adStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(adStatusTitleLabel);
        make.left.mas_equalTo(adStatusTitleLabel.mas_right);
        make.height.mas_equalTo(adStatusTitleLabel);
    }];
    
    self.adDownLoadingButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xff4d55) font:kPingFangRegular(13 * scale) backgroundColor:[UIColor clearColor] title:@"查看正在下载" cornerRadius:2 * scale];
    [self.adDownLoadingButton addTarget:self action:@selector(lookADCurrentDownLoad) forControlEvents:UIControlEventTouchUpInside];
    self.adDownLoadingButton.layer.borderColor = UIColorFromRGB(0xff4d55).CGColor;
    self.adDownLoadingButton.layer.borderWidth = .5 * scale;
    [self addSubview:self.adDownLoadingButton];
    [self.adDownLoadingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(adStatusTitleLabel).offset(-2 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(94 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    self.adDownLoadingButton.hidden = YES;
    
    UIView * lineView3 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView3.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self addSubview:lineView3];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(adStatusTitleLabel.mas_bottom).offset(19 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5 * scale);
    }];
    
    UILabel * currentPlayTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    currentPlayTitleLabel.text = @"当前播放列表";
    [self addSubview:currentPlayTitleLabel];
    [currentPlayTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView3.mas_bottom).offset(19 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.pushListButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0x00b7f5) font:kPingFangRegular(13 * scale) backgroundColor:[UIColor clearColor] title:@"发布内容列表" cornerRadius:2 * scale];
    [self.pushListButton addTarget:self action:@selector(pushButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    self.pushListButton.layer.borderColor = UIColorFromRGB(0x00b7f5).CGColor;
    self.pushListButton.layer.borderWidth = .5 * scale;
    [self addSubview:self.pushListButton];
    [self.pushListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(currentPlayTitleLabel.mas_top).offset(-2 * scale);
        make.right.mas_equalTo(-15 * scale);
        make.width.mas_equalTo(94 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * mediaDateTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    mediaDateTitleLabel.text = @"节目期号：";
    [self addSubview:mediaDateTitleLabel];
    [mediaDateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(currentPlayTitleLabel.mas_bottom).offset(14 * scale);
        make.left.mas_equalTo(currentPlayTitleLabel);
        make.height.mas_equalTo(16 * scale);
    }];
    
    self.mediaDateLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    self.mediaDateLabel.text = @"无";
    [self addSubview:self.mediaDateLabel];
    [self.mediaDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mediaDateTitleLabel);
        make.left.mas_equalTo(mediaDateTitleLabel.mas_right);
        make.height.mas_equalTo(mediaDateTitleLabel);
    }];
    
    UILabel * adDateTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    adDateTitleLabel.text = @"广告期号：";
    [self addSubview:adDateTitleLabel];
    [adDateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mediaDateTitleLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(mediaDateTitleLabel);
        make.height.mas_equalTo(16 * scale);
    }];
    
    self.adDateLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x666666) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    self.adDateLabel.text = @"无";
    [self addSubview:self.adDateLabel];
    [self.adDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(adDateTitleLabel);
        make.left.mas_equalTo(adDateTitleLabel.mas_right);
        make.height.mas_equalTo(adDateTitleLabel);
    }];
    
    UIView * lineView4 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView4.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self addSubview:lineView4];
    [lineView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_equalTo(.5 * scale);
        make.bottom.mas_equalTo(-10 * scale);
    }];
}

- (void)configWithDict:(NSDictionary *)dict
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.boxNameLabel.text = GetNoNullString([dict objectForKey:@"box_name"]);
    self.boxMaclabel.text = GetNoNullString([dict objectForKey:@"box_mac"]);
    self.lastHeartTimeLabel.text = GetNoNullString([dict objectForKey:@"last_heart_time"]);
    self.lastLogUploadTimeLabel.text = GetNoNullString([dict objectForKey:@"log_upload_time"]);
    self.currentStatusLabel.text = GetNoNullString([dict objectForKey:@"loss_hours"]);
    self.mediaStatusLabel.text = GetNoNullString([dict objectForKey:@"pro_period_state"]);
    self.adStatusLabel.text = GetNoNullString([dict objectForKey:@"ads_period_state"]);
    self.mediaDateLabel.text = GetNoNullString([dict objectForKey:@"pro_period"]);
    self.adDateLabel.text = GetNoNullString([dict objectForKey:@"ads_period"]);
    
    if (isEmptyString([dict objectForKey:@"pro_download_period"])) {
        self.mediaDownLoadingButton.hidden = YES;
    }else{
        self.mediaDownLoadingButton.hidden = NO;
    }
    
    if (isEmptyString([dict objectForKey:@"ads_download_period"])) {
        self.adDownLoadingButton.hidden = YES;
    }else{
        self.adDownLoadingButton.hidden = NO;
    }
    
    NSArray * repairArray = [dict objectForKey:@"repair_record"];
    NSString * repairText;
    if ([repairArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary * info in repairArray) {
            
            if (isEmptyString(repairText)) {
                repairText = [NSString stringWithFormat:@"%@  (%@)", [info objectForKey:@"nickname"], [info objectForKey:@"ctime"]];
            }else{
                repairText = [repairText stringByAppendingString:[NSString stringWithFormat:@"\n%@  (%@)", [info objectForKey:@"nickname"], [info objectForKey:@"ctime"]]];
            }
            
        }
    }
    self.repairListLabel.text = repairText;
    
    CGFloat height = [HotTopicTools getHeightByWidth:270 * scale title:self.repairListLabel.text font:self.repairListLabel.font];
    CGRect frame = self.frame;
    frame.size.height += height - 15 * scale;
    self.frame = frame;
}

- (void)lookMediaCurrentDownLoad
{
    if (_delegate && [_delegate respondsToSelector:@selector(mediaDownLoadButtonDidClicked)]) {
        [_delegate mediaDownLoadButtonDidClicked];
    }
}

- (void)lookADCurrentDownLoad
{
    if (_delegate && [_delegate respondsToSelector:@selector(adDownLoadButtonDidClicked)]) {
        [_delegate adDownLoadButtonDidClicked];
    }
}

- (void)testButtonDidClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(testButtonDidClicked)]) {
        [_delegate testButtonDidClicked];
    }
}

- (void)pushButtonDidClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(pushListButtonDidClicked)]) {
        [_delegate pushListButtonDidClicked];
    }
}

@end
