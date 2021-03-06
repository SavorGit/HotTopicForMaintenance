//
//  ErrorReportTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ErrorReportTableViewCell.h"

@interface ErrorReportTableViewCell ()

@property (nonatomic, strong) UILabel * detailLabel;
@property (nonatomic, strong) UILabel * timeLabel;

@end

@implementation ErrorReportTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLabel.textColor = UIColorFromRGB(0x333333);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = kPingFangRegular(14);
    [self.contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-5);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(20);
    }];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.detailLabel.textColor = UIColorFromRGB(0x333333);
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.font = kPingFangRegular(14);
    self.detailLabel.numberOfLines = 0;
    [self.contentView addSubview:self.detailLabel];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-5);
        make.right.mas_equalTo(-40);
    }];
    
    UIImageView * moreImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    moreImageView.contentMode = UIViewContentModeScaleAspectFit;
    [moreImageView setImage:[UIImage imageNamed:@"more"]];
    [self.contentView addSubview:moreImageView];
    [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(- 15);
    }];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configWithModel:(ErrorReportModel *)model
{
    self.detailLabel.text = model.info;
    self.timeLabel.text = model.date;
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
