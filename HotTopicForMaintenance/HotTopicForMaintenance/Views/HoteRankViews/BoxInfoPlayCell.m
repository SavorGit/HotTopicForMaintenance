//
//  BoxInfoPlayCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "BoxInfoPlayCell.h"
#import "HotTopicTools.h"

@interface BoxInfoPlayCell ()

@property (nonatomic, strong) UILabel * playeTypeLabel;
@property (nonatomic, strong) UILabel * playTitleLabel;
@property (nonatomic, strong) UIImageView * playStatusImageView;

@end

@implementation BoxInfoPlayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.playeTypeLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(12 * scale) alignment:NSTextAlignmentCenter];
    self.playeTypeLabel.backgroundColor = UIColorFromRGB(0xbbbbbb);
    self.playeTypeLabel.layer.cornerRadius = 1.5 * scale;
    self.playeTypeLabel.layer.masksToBounds = YES;
    self.playeTypeLabel.text = @"宣传片";
    [self.contentView addSubview:self.playeTypeLabel];
    [self.playeTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(18 * scale);
        make.width.mas_equalTo(45 * scale);
    }];
    
    self.playStatusImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.playStatusImageView setImage:[UIImage imageNamed:@"dui"]];
    [self.contentView addSubview:self.playStatusImageView];
    [self.playStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15 * scale);
        make.width.height.mas_equalTo(18 * scale);
    }];
    
    self.playTitleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(14 * scale) alignment:NSTextAlignmentLeft];
    self.playTitleLabel.text = @"OUTSIDE北海岸的冲浪者80秒";
    [self.contentView addSubview:self.playTitleLabel];
    [self.playTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(67.5 * scale);
        make.height.mas_equalTo(16 * scale);
        make.right.mas_equalTo(self.playStatusImageView.mas_left).offset(-15 * scale);
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
