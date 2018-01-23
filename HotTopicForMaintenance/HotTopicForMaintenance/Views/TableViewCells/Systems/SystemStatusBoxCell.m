//
//  SystemStatusBoxCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/16.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "SystemStatusBoxCell.h"
#import "HotTopicTools.h"

@interface SystemStatusBoxCell ()

@property (nonatomic, strong) UILabel * deviceNameLabel;
@property (nonatomic, strong) UILabel * totalNumberLabel;
@property (nonatomic, strong) UILabel * normalLabel;
@property (nonatomic, strong) UILabel * faultLabel;
@property (nonatomic, strong) UILabel * frozenLabel;

@end

@implementation SystemStatusBoxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.deviceNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    self.deviceNameLabel.text = @"设备";
    [self.contentView addSubview:self.deviceNameLabel];
    [self.deviceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.top.mas_equalTo(19 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    self.totalNumberLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    self.totalNumberLabel.text = @"总数  0";
    [self.contentView addSubview:self.totalNumberLabel];
    [self.totalNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(92 * scale);
        make.top.mas_equalTo(self.deviceNameLabel);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * normalImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [normalImageView setImage:[UIImage imageNamed:@"zaixian"]];
    [self.contentView addSubview:normalImageView];
    [normalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.totalNumberLabel);
        make.top.mas_equalTo(self.totalNumberLabel.mas_bottom).offset(11 * scale);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.normalLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.normalLabel.text = @"正常  0";
    [self.contentView addSubview:self.normalLabel];
    [self.normalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.totalNumberLabel.mas_bottom).offset(8 * scale);
        make.left.mas_equalTo(normalImageView.mas_right).offset(5 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * faultImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [faultImageView setImage:[UIImage imageNamed:@"lixian"]];
    [self.contentView addSubview:faultImageView];
    [faultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(193 * scale);
        make.top.mas_equalTo(normalImageView);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.faultLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.faultLabel.text = @"报损  0";
    [self.contentView addSubview:self.faultLabel];
    [self.faultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.normalLabel);
        make.left.mas_equalTo(faultImageView.mas_right).offset(5 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
    
    UIImageView * frozenImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [frozenImageView setImage:[UIImage imageNamed:@"dongjie"]];
    [self.contentView addSubview:frozenImageView];
    [frozenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.faultLabel.mas_right).offset(24 * scale);
        make.top.mas_equalTo(normalImageView);
        make.width.height.mas_equalTo(11 * scale);
    }];
    
    self.frozenLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15 * scale) alignment:NSTextAlignmentLeft];
    self.frozenLabel.text = @"冻结  0";
    [self.contentView addSubview:self.frozenLabel];
    [self.frozenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.normalLabel);
        make.left.mas_equalTo(frozenImageView.mas_right).offset(5 * scale);
        make.height.mas_equalTo(17 * scale);
    }];
}

- (void)configWithDict:(NSDictionary *)dict
{
    self.deviceNameLabel = [dict objectForKey:@"name"];
    self.totalNumberLabel.text = [NSString stringWithFormat:@"总数  %@", GetNoNullString([dict objectForKey:@"box_all_num" ])];;
    self.normalLabel.text = [NSString stringWithFormat:@"正常  %@", GetNoNullString([dict objectForKey:@"box_normal_all_num" ])];
    self.faultLabel.text = [NSString stringWithFormat:@"报损  %@", GetNoNullString([dict objectForKey:@"box_freeze_all_num" ])];
    self.frozenLabel.text = [NSString stringWithFormat:@"冻结  %@", GetNoNullString([dict objectForKey:@"freeze_all_num" ])];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
