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
    [self.contentView addSubview:self.playeTypeLabel];
    [self.playeTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(18 * scale);
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
    [self.contentView addSubview:self.playTitleLabel];
    [self.playTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(67.5 * scale);
        make.height.mas_equalTo(16 * scale);
        make.right.mas_equalTo(self.playStatusImageView.mas_left).offset(-15 * scale);
    }];
}

- (void)configWithDict:(NSDictionary *)dict
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    NSString * type = [dict objectForKey:@"type"];
    self.playeTypeLabel.text = type;
    if (type.length == 2) {
        [self.playeTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(38 * scale);
        }];
    }else if (type.length == 3) {
        [self.playeTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45 * scale);
        }];
    }else{
        self.playeTypeLabel.text = [NSString stringWithFormat:@" %@  ", type];
    }
    
    self.playTitleLabel.text = [dict objectForKey:@"name"];
    
    BOOL flag = [[dict objectForKey:@"flag"] boolValue];
    if (flag) {
        [self.playStatusImageView setImage:[UIImage imageNamed:@"dui"]];
    }else{
        [self.playStatusImageView setImage:[UIImage imageNamed:@"cuo"]];
    }
}

- (void)configNoFlagWithDict:(NSDictionary *)dict
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    NSString * type = [dict objectForKey:@"type"];
    self.playeTypeLabel.text = type;
    if (type.length == 2) {
        [self.playeTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(38 * scale);
        }];
    }else if (type.length == 3) {
        [self.playeTypeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(45 * scale);
        }];
    }else{
        self.playeTypeLabel.text = [NSString stringWithFormat:@" %@  ", type];
    }
    
    self.playTitleLabel.text = [dict objectForKey:@"name"];
    
    self.playStatusImageView.hidden = YES;
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
