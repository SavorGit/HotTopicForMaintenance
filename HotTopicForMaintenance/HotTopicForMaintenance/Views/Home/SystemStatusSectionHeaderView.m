//
//  SystemStatusSectionHeaderView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/15.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "SystemStatusSectionHeaderView.h"
#import "HotTopicTools.h"

@interface SystemStatusSectionHeaderView ()

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * numberLabel;
@property (nonatomic, strong) UILabel * normalLabel;
@property (nonatomic, strong) UILabel * faultLabel;
@property (nonatomic, strong) UILabel * frozenLabel;

@property (nonatomic, strong) UIView * lineView;

@end

@implementation SystemStatusSectionHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(37 * scale);
        make.height.mas_equalTo(12 * scale);
    }];
    
    self.numberLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(20 * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImageView);
        make.top.mas_equalTo(self.logoImageView.mas_bottom);
        make.height.mas_equalTo(19 * scale);
    }];
    
    self.normalLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.normalLabel];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(92 * scale);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.faultLabel =[HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.faultLabel];
    [self.faultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(238 * scale);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.frozenLabel =[HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.frozenLabel];
    [self.frozenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.faultLabel.mas_right).offset(24 * scale);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectZero];
    self.lineView.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f * scale);
    }];
}

- (void)configWithType:(SystemStatusType)type info:(NSDictionary *)info
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    switch (type) {
        case SystemStatusType_Hotel:
        {
            self.lineView.hidden = NO;
            self.frozenLabel.hidden = YES;
            [self.logoImageView setImage:[UIImage imageNamed:@"jiulou"]];
            self.numberLabel.text = GetNoNullString([info objectForKey:@"hotel_all_nums"]);
            self.numberLabel.textColor = UIColorFromRGB(0xff4d55);
            self.normalLabel.text = [NSString stringWithFormat:@"正常 %@", GetNoNullString([info objectForKey:@"hotel_all_normal_nums"])];
            self.faultLabel.text = [NSString stringWithFormat:@"冻结 %@", GetNoNullString([info objectForKey:@"hotel_all_freeze_nums"])];
            [self.faultLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(238 * scale);
            }];
            [self.logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(37 * scale);
            }];
        }
            break;
            
        case SystemStatusType_Platform:
        {
            self.lineView.hidden = YES;
            self.frozenLabel.hidden = YES;
            [self.logoImageView setImage:[UIImage imageNamed:@"xiaopingtai"]];
            self.numberLabel.text = GetNoNullString([info objectForKey:@"all_nums"]);
            self.numberLabel.textColor = UIColorFromRGB(0x3aba9a);
            self.normalLabel.text = [NSString stringWithFormat:@"正常 %@", GetNoNullString([info objectForKey:@"normal_nums"])];
            self.faultLabel.text = [NSString stringWithFormat:@"冻结 %@", GetNoNullString([info objectForKey:@"freeze_nums"])];
            [self.faultLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(238 * scale);
            }];
            [self.logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(49 * scale);
            }];
        }
            break;
            
            
        case SystemStatusType_Box:
        {
            self.lineView.hidden = NO;
            self.frozenLabel.hidden = NO;
            [self.logoImageView setImage:[UIImage imageNamed:@"jidinghe"]];
            self.numberLabel.textColor = UIColorFromRGB(0x16abe5);
            self.numberLabel.text = GetNoNullString([info objectForKey:@"all_num"]);
            self.normalLabel.text = [NSString stringWithFormat:@"正常 %@", GetNoNullString([info objectForKey:@"normal_all_num"])];
            self.faultLabel.text = [NSString stringWithFormat:@"报损 %@", GetNoNullString([info objectForKey:@"break_all_num"])];
            self.frozenLabel.text = [NSString stringWithFormat:@"冻结 %@", GetNoNullString([info objectForKey:@"freeze_all_num"])];
            [self.faultLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(193 * scale);
            }];
            [self.logoImageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(49 * scale);
            }];
        }
            break;
            
        default:
            break;
    }
}

@end
