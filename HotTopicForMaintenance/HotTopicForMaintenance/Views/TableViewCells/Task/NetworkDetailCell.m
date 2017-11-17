//
//  NetworkDetailCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "NetworkDetailCell.h"
#import "HotTopicTools.h"

@interface NetworkDetailCell ()

@property (nonatomic, strong) UIView * baseView;

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIImageView * photoImageView;
@property (nonatomic, strong) UIImageView * listImageView;

@property (nonatomic, strong) NSDictionary * info;

@end

@implementation NetworkDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self createNetworkCell];
    }
    return self;
}

- (void)createNetworkCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = VCBackgroundColor;
    self.contentView.backgroundColor = VCBackgroundColor;
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
    self.baseView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.f * scale);
        make.left.mas_equalTo(15.f * scale);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15.f);
    }];
    self.baseView.layer.cornerRadius = 10.f;
    self.baseView.layer.masksToBounds = YES;
    
    self.timeLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    self.timeLabel.text = @"操作时间 ";
    [self.baseView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.right.mas_equalTo(-12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.photoImageView.clipsToBounds = YES;
    self.photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.baseView addSubview:self.photoImageView];
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f*scale);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset(16.f * scale);
        make.right.mas_equalTo(-15.f * scale);
        make.height.mas_equalTo(120.f * scale);
    }];
    
    UILabel * transformLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentCenter];
    transformLabel.text = @"改造设备图";
    [self.baseView addSubview:transformLabel];
    [transformLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.photoImageView.mas_bottom).offset(6.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.right.mas_equalTo(-12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.baseView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f * scale);
        make.right.mas_equalTo(-15.f * scale);
        make.top.mas_equalTo(transformLabel.mas_bottom).offset(5.f);
        make.height.mas_equalTo(1.f);
    }];
    
    self.listImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.listImageView.clipsToBounds = YES;
    self.listImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.baseView addSubview:self.listImageView];
    [self.listImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f*scale);
        make.top.mas_equalTo(transformLabel.mas_bottom).offset(20.f * scale);
        make.right.mas_equalTo(-15.f * scale);
        make.height.mas_equalTo(120.f * scale);
    }];
    
    UILabel * listLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentCenter];
    listLabel.text = @"网络改造检测单";
    [self.baseView addSubview:listLabel];
    [listLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.listImageView.mas_bottom).offset(6.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.right.mas_equalTo(-12.f * scale);
        make.bottom.mas_equalTo(-10.f * scale);
    }];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDidClicked:)];
    tap1.numberOfTapsRequired = 1;
    self.photoImageView.userInteractionEnabled = YES;
    [self.photoImageView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDidClicked:)];
    tap2.numberOfTapsRequired = 1;
    self.listImageView.userInteractionEnabled = YES;
    [self.listImageView addGestureRecognizer:tap2];
}

- (void)photoDidClicked:(UITapGestureRecognizer *)tap
{
    NSArray * imageArray = [self.info objectForKey:@"repair_img"];
    if ([imageArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary * dict in imageArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSString * type = [dict objectForKey:@"type"];
                NSString * imageURL = [dict objectForKey:@"img"];
                if ([type isEqualToString:@"1"]) {
                    if (tap.view == self.photoImageView) {
                        [self showWindowImage:imageURL];
                        return;
                    }
                }else if ([type isEqualToString:@"2"]) {
                    if (tap.view == self.listImageView) {
                        [self showWindowImage:imageURL];
                        return;
                    }
                }
            }
        }
    }
}

- (void)configWithInfo:(NSDictionary *)info
{
    self.info = info;
    NSString * time = [info objectForKey:@"repair_time"];
    self.timeLabel.text = [NSString stringWithFormat:@"操作时间 %@", time];
    
    [self.photoImageView setImage:[UIImage imageNamed:@"zanwu"]];
    [self.listImageView setImage:[UIImage imageNamed:@"zanwu"]];
    NSArray * imageArray = [info objectForKey:@"repair_img"];
    if ([imageArray isKindOfClass:[NSArray class]]) {
        for (NSDictionary * dict in imageArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSString * type = [dict objectForKey:@"type"];
                NSString * imageURL = [dict objectForKey:@"img"];
                if ([type isEqualToString:@"1"]) {
                    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                }else if ([type isEqualToString:@"2"]) {
                    [self.listImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                }
            }
        }
    }
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
