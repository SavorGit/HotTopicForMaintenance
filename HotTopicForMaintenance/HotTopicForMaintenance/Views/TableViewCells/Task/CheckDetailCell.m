//
//  CheckDetailCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "CheckDetailCell.h"
#import "HotTopicTools.h"

@interface CheckDetailCell ()

@property (nonatomic, strong) UIView * baseView;

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UIImageView * photoImageView;

@property (nonatomic, strong) NSDictionary * info;

@end

@implementation CheckDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self createCheckCell];
    }
    return self;
}

- (void)createCheckCell
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
    
    UILabel * checkLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentCenter];
    checkLabel.text = @"信息检测单";
    [self.baseView addSubview:checkLabel];
    [checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.photoImageView.mas_bottom).offset(6.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.right.mas_equalTo(-12.f * scale);
        make.bottom.mas_equalTo(-10.f * scale);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDidClicked)];
    tap.numberOfTapsRequired = 1;
    self.photoImageView.userInteractionEnabled = YES;
    [self.photoImageView addGestureRecognizer:tap];
}

- (void)photoDidClicked
{
    [self showWindowImage:[self.info objectForKey:@"repair_img"]];
}


- (void)configWithInfo:(NSDictionary *)info
{
    self.info = info;
    NSString * time = [info objectForKey:@"repair_time"];
    NSArray * imageTemp = [info objectForKey:@"repair_img"];
    
    NSString * imageURL = @"";
    if ([imageTemp isKindOfClass:[NSArray class]]) {
        if (imageTemp.count > 0) {
            NSDictionary * dict = [imageTemp firstObject];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                imageURL = [dict objectForKey:@"img"];
            }
        }
    }
    self.timeLabel.text = [NSString stringWithFormat:@"操作时间 %@", time];
    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:imageURL]];
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
