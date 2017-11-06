//
//  PosionListTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "PosionListTableViewCell.h"

@interface PosionListTableViewCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *reasonLabel;

@property (nonatomic, strong) UIImageView *leftImage;


@end

@implementation PosionListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = UIColorFromRGB(0xffffff);
    _bgView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
    _bgView.layer.borderWidth = .5f;
    _bgView.layer.cornerRadius = 5.f;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 30 - 60);
        make.height.mas_equalTo(38);
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(15);
    }];
    
    self.leftImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.leftImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.leftImage setImage:[UIImage imageNamed:@"selected"]];
    [_bgView addSubview:self.leftImage];
    [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.mas_equalTo(11);
        make.left.mas_equalTo(15);
    }];
    
    self.reasonLabel = [[UILabel alloc]init];
    self.reasonLabel.font = [UIFont systemFontOfSize:14];
    self.reasonLabel.textColor = UIColorFromRGB(0x434343);
    self.reasonLabel.textAlignment = NSTextAlignmentLeft;
    self.reasonLabel.text = @"版位";
    [_bgView addSubview:self.reasonLabel];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30- 20 - 60), 20));
        make.top.mas_equalTo(9);
        make.left.mas_equalTo(self.leftImage.mas_right).offset(10);
    }];
    
    self.selectImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.selectImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.selectImgView setImage:[UIImage imageNamed:@"selected"]];
    [_bgView addSubview:self.selectImgView];
    self.selectImgView.hidden = YES;
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.mas_equalTo(11);
        make.right.mas_equalTo(- 15);
    }];
    
}

- (void)configWithModel:(RestaurantRankModel *)model{
    
    self.reasonLabel.text = model.box_name;
    
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
