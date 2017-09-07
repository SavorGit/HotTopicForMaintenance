//
//  ErrorDetailTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "ErrorDetailTableViewCell.h"

@interface ErrorDetailTableViewCell ()

@property (nonatomic, strong) UILabel * hotelLabel;
@property (nonatomic, strong) UILabel * InfoLabel;

@end

@implementation ErrorDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.hotelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.hotelLabel.textColor = UIColorFromRGB(0x333333);
    self.hotelLabel.textAlignment = NSTextAlignmentLeft;
    self.hotelLabel.font = kPingFangMedium(14);
    [self.contentView addSubview:self.hotelLabel];
    [self.hotelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-40);
        make.height.mas_equalTo(20);
    }];
    
    self.InfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.InfoLabel.textColor = UIColorFromRGB(0x666666);
    self.InfoLabel.textAlignment = NSTextAlignmentLeft;
    self.InfoLabel.font = kPingFangRegular(14);
    self.InfoLabel.numberOfLines = 0;
    [self.contentView addSubview:self.InfoLabel];
    [self.InfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hotelLabel.mas_bottom).mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-5);
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
    
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configWithModel:(ErrorDetailModel *)model
{
    self.hotelLabel.text = model.hotel_info;
    self.InfoLabel.text = [NSString stringWithFormat:@"%@\n%@", model.small_palt_info, model.box_info];
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
