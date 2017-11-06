//
//  TaskTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskTableViewCell.h"

@interface TaskTableViewCell ()

@property (nonatomic, strong) UILabel * typeDescLabel;
@property (nonatomic, strong) UILabel * typeLogoLabel;

@end

@implementation TaskTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self createTaskCell];
    }
    return self;
}

- (void)createTaskCell
{
    self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.typeLogoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    self.typeLogoLabel.font = kPingFangMedium(16);
    self.typeLogoLabel.textColor = UIColorFromRGB(0xffffff);
    self.typeLogoLabel.backgroundColor = UIColorFromRGB(0x5c6366);
    self.typeLogoLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.typeLogoLabel];
    [self.typeLogoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(32);
    }];
    self.typeLogoLabel.layer.cornerRadius = 16;
    self.typeLogoLabel.layer.masksToBounds = YES;
    
    self.typeDescLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.typeDescLabel.font = kPingFangRegular(16);
    self.typeDescLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.typeDescLabel];
    [self.typeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.typeLogoLabel.mas_right).offset(20);
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(16);
    }];
}

- (void)configWithModel:(TaskListModel *)model
{
    self.typeDescLabel.text = model.type_Desc;
    self.typeLogoLabel.text = model.logo_Desc;
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
