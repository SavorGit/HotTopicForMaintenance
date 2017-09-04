//
//  HotelInfoTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HotelInfoTableViewCell.h"

@interface HotelInfoTableViewCell ()

@property (nonatomic, strong) UILabel * infoLabel;

@end

@implementation HotelInfoTableViewCell

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
    self.infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.infoLabel.textAlignment = NSTextAlignmentLeft;
    self.infoLabel.numberOfLines = 0;
    self.infoLabel.font = kPingFangRegular(14);
    self.infoLabel.textColor = UIColorFromRGB(0x333333);
    [self.contentView addSubview:self.infoLabel];
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
}

- (void)configWithInfo:(NSString *)info
{
    self.infoLabel.text = info;
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
