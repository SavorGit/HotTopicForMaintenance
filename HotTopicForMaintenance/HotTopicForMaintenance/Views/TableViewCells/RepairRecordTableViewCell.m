//
//  RepairRecordTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RepairRecordTableViewCell.h"
#import "HotTopicTools.h"

@interface RepairRecordTableViewCell ()

@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * recordLabel;
@property (nonatomic, strong) UILabel * remarkLabel;

@end

@implementation RepairRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = [UIColor clearColor];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusLabel.textColor = UIColorFromRGB(0x333333);
    self.statusLabel.textAlignment = NSTextAlignmentLeft;
    self.statusLabel.font = kPingFangRegular(14);
    [self.contentView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(kMainBoundsWidth / 2);
    }];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.textColor = UIColorFromRGB(0x333333);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = kPingFangRegular(14);
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(kMainBoundsWidth / 2);
    }];
    
    self.remarkLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.remarkLabel.textColor = UIColorFromRGB(0x333333);
    self.remarkLabel.numberOfLines = 0;
    self.remarkLabel.font = kPingFangRegular(14);
    [self.contentView addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    
    self.recordLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.recordLabel.textColor = UIColorFromRGB(0x333333);
    self.recordLabel.textAlignment = NSTextAlignmentLeft;
    self.recordLabel.numberOfLines = 0;
    self.recordLabel.font = kPingFangRegular(14);
    [self.contentView addSubview:self.recordLabel];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(self.remarkLabel.mas_top).offset(-5);
    }];
}

- (void)configWithModel:(RepairRecordDetailModel *)model
{
    self.statusLabel.text = model.state;
    self.timeLabel.text = model.create_time;
    
    if (isEmptyString(model.repair_error)) {
        self.recordLabel.text = @"维修记录：无";
    }else{
        self.recordLabel.text = [@"维修记录：" stringByAppendingString:model.repair_error];
    }
    
    if (isEmptyString(model.remark)) {
        [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(20);
        }];
        self.remarkLabel.text = @"备注：无";
    }else{
        NSString * str = [@"备注：" stringByAppendingString:model.remark];
        
        CGFloat height = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 20 title:str font:kPingFangRegular(14)];
        [self.remarkLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
        self.remarkLabel.text = str;
    }
}

@end
