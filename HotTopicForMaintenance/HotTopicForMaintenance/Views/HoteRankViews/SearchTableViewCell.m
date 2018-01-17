//
//  SearchTableViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SearchTableViewCell.h"

@interface SearchTableViewCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *hotelLabel;
@property (nonatomic, strong) UIImageView *nextImgView;

@end

@implementation SearchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    _bgView.layer.borderColor = UIColorFromRGB(0xf6f2ed).CGColor;
    _bgView.layer.borderWidth = .5f;
    _bgView.layer.cornerRadius = 5.f;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(46);
        make.top.mas_equalTo(4);
        make.left.mas_equalTo(15);
    }];
    
    self.hotelLabel = [[UILabel alloc]init];
    self.hotelLabel.font = [UIFont systemFontOfSize:14];
    self.hotelLabel.textColor = UIColorFromRGB(0x434343);
    self.hotelLabel.textAlignment = NSTextAlignmentLeft;
    self.hotelLabel.text = @"故障原因";
    [_bgView addSubview:self.hotelLabel];
    [self.hotelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30- 20), 20));
        make.top.mas_equalTo(13);
        make.left.mas_equalTo(15);
    }];
    
    self.nextImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.nextImgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.nextImgView setImage:[UIImage imageNamed:@"more"]];
    [_bgView addSubview:self.nextImgView];
    [self.nextImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(- 15);
    }];
    
}

- (void)configWithModel:(RestaurantRankModel *)model{
    
    self.hotelLabel.text = model.name;
    
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
