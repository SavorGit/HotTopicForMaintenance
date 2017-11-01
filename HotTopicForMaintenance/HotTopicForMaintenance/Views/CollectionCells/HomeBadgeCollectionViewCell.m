//
//  HomeBadgeCollectionViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HomeBadgeCollectionViewCell.h"

@interface HomeBadgeCollectionViewCell ()

@property (nonatomic, strong) UILabel * badgeLabel;

@end

@implementation HomeBadgeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createBadgeViews];
    }
    return self;
}

- (void)createBadgeViews
{
    self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.badgeLabel.backgroundColor = UIColorFromRGB(0xff0000);
    self.badgeLabel.textColor = UIColorFromRGB(0xffffff);
    self.badgeLabel.font = kPingFangRegular(14);
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.badgeLabel];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(25);
        make.centerX.mas_equalTo(45);
        make.width.height.mas_equalTo(18);
    }];
    self.badgeLabel.layer.cornerRadius = 9;
    self.badgeLabel.layer.masksToBounds = YES;
}

- (void)setBadgeNumber:(NSInteger)number
{
    if (number == 0) {
        self.badgeLabel.hidden = YES;
    }else if (number > 9) {
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = @"9+";
    }else{
        self.badgeLabel.hidden = NO;
        self.badgeLabel.text = [NSString stringWithFormat:@"%ld", number];
    }
}

@end