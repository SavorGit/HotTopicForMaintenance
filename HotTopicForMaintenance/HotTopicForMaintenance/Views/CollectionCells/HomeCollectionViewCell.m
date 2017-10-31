//
//  HomeCollectionViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/30.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@interface HomeCollectionViewCell ()

@property (nonatomic, strong) UIImageView * logoImageView;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation HomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createViews];
    }
    return self;
}

- (void)createViews
{
    self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.logoImageView];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(41);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(-15);
    }];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = kPingFangMedium(16);
    self.titleLabel.textColor = UIColorFromRGB(0x52535d);
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(16);
        make.top.equalTo(self.logoImageView.mas_bottom).offset(12);
    }];
}

- (void)configWithModel:(MenuModel *)model
{
    [self.logoImageView setImage:[UIImage imageNamed:model.imageName]];
    self.titleLabel.text = model.title;
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.contentView.backgroundColor = UIColorFromRGB(0xf7f7f7);
    }else{
        self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    }
}

@end
