//
//  DeviceFaultTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "DeviceFaultTableViewCell.h"
#import "HotTopicTools.h"
#import "UIImageView+WebCache.h"

@interface DeviceFaultTableViewCell ()

@property (nonatomic, strong) UIView * baseView;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * descLabel;
@property (nonatomic, strong) UILabel * photoLabel;
@property (nonatomic, strong) UIImageView * photoImageView;

@end

@implementation DeviceFaultTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self createDeviceFaultCell];
    }
    return self;
}

- (void)createDeviceFaultCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = VCBackgroundColor;
    self.contentView.backgroundColor = VCBackgroundColor;
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
    self.baseView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.f * scale);
        make.left.mas_equalTo(15.f * scale);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15.f);
    }];
    self.baseView.layer.cornerRadius = 10.f;
    self.baseView.layer.masksToBounds = YES;
    
    self.nameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    [self.baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.right.mas_equalTo(-12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    self.descLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    self.descLabel.numberOfLines = 0;
    [self.baseView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(16.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.right.mas_equalTo(-12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    self.photoLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    [self.baseView addSubview:self.photoLabel];
    [self.photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(16.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)configWithDeviceFaultModel:(DeviceFaultModel *)model
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    if (isEmptyString(model.imageURL)) {
        [self.photoImageView removeFromSuperview];
        self.photoLabel.text = @"故障照片：无";
    }else{
        self.photoLabel.text = @"故障照片：";
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]];
        if (!self.photoImageView.superview) {
            [self.baseView addSubview:self.photoImageView];
            [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.descLabel.mas_bottom).offset(16.f * scale);
                make.left.mas_equalTo(self.photoLabel.mas_right).offset(10.f * scale);
                make.width.mas_equalTo(150.f * scale);
                make.height.mas_equalTo(self.photoImageView.mas_width).multipliedBy(169.f/300.f);
            }];
        }
    }
    
    self.nameLabel.text = [@"版位名称：" stringByAppendingString:model.name];
    self.descLabel.text = [@"故障现象：" stringByAppendingString:model.desc];
    
    CGFloat height = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 54.f * scale title:self.descLabel.text font:self.descLabel.font];
    [self.descLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
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
