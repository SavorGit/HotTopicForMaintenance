//
//  RepairDetailCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RepairDetailCell.h"
#import "HotTopicTools.h"

@interface RepairDetailCell ()

@property (nonatomic, strong) UIView * baseView;

@property (nonatomic, strong) UILabel * userNameLabel;
@property (nonatomic, strong) UILabel * boxNameLabel;
@property (nonatomic, strong) UILabel * stateLabel;
@property (nonatomic, strong) UILabel * remarkLabel;
@property (nonatomic, strong) UILabel * handleTimeLabel;

@property (nonatomic, strong) UIImageView * Photo1;
@property (nonatomic, strong) UIImageView * Photo2;
@property (nonatomic, strong) UIImageView * Photo3;

@property (nonatomic, strong) NSDictionary * info;

@end

@implementation RepairDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self createRepairCell];
    }
    return self;
}

- (void)createRepairCell
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

    self.userNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    self.userNameLabel.text = @"执行人：";
    [self.baseView addSubview:self.userNameLabel];
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.right.mas_equalTo(-12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    self.boxNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    self.boxNameLabel.text = @"维修版位：";
    [self.baseView addSubview:self.boxNameLabel];
    [self.boxNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(6.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.right.mas_equalTo(-12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    self.stateLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    [self.baseView addSubview:self.stateLabel];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.userNameLabel.mas_bottom).offset(6.f * scale);
        make.left.mas_equalTo(self.boxNameLabel.mas_right).offset(12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    self.remarkLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    self.remarkLabel.text = @"备注：";
    CGFloat height = [HotTopicTools getHeightByWidth:(kMainBoundsWidth - 54.f) * scale title:self.remarkLabel.text font:self.remarkLabel.font];
    [self.baseView addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stateLabel.mas_bottom).offset(6.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.right.mas_equalTo(-12.f * scale);
        make.height.mas_equalTo(height);
    }];
    
    UILabel * photoLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    [self.baseView addSubview:photoLabel];
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.remarkLabel.mas_bottom).offset(6.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    photoLabel.text = @"照片：";
    
    self.Photo1 = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.Photo1.tag = 100;
    self.Photo1.clipsToBounds = YES;
    self.Photo1.contentMode = UIViewContentModeScaleAspectFill;
    [self.baseView addSubview:self.Photo1];
    [self.Photo1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(photoLabel.mas_right).offset(6.f*scale);
        make.top.mas_equalTo(self.remarkLabel.mas_bottom).offset(6.f * scale);
        make.width.mas_equalTo(80.f * scale);
        make.height.mas_equalTo(self.Photo1.mas_width).multipliedBy(17.f/30.f);
    }];
    
    self.Photo2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.Photo2.tag = 101;
    self.Photo2.clipsToBounds = YES;
    self.Photo2.contentMode = UIViewContentModeScaleAspectFill;
    [self.baseView addSubview:self.Photo2];
    [self.Photo2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.Photo1.mas_right).offset(6.f*scale);
        make.top.mas_equalTo(self.remarkLabel.mas_bottom).offset(6.f * scale);
        make.width.mas_equalTo(80.f * scale);
        make.height.mas_equalTo(self.Photo1.mas_width).multipliedBy(17.f/30.f);
    }];
    
    self.Photo3 = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.Photo3.tag = 102;
    self.Photo3.clipsToBounds = YES;
    self.Photo3.contentMode = UIViewContentModeScaleAspectFill;
    [self.baseView addSubview:self.Photo3];
    [self.Photo3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.Photo2.mas_right).offset(6.f*scale);
        make.top.mas_equalTo(self.remarkLabel.mas_bottom).offset(6.f * scale);
        make.width.mas_equalTo(80.f * scale);
        make.height.mas_equalTo(self.Photo1.mas_width).multipliedBy(17.f/30.f);
    }];
    
    self.handleTimeLabel =[HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    self.handleTimeLabel.text = @"操作时间：";
    [self.baseView addSubview:self.handleTimeLabel];
    [self.handleTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.Photo1.mas_bottom).mas_equalTo(6.f * scale);
        make.left.mas_equalTo(12.f * scale);
        make.height.mas_equalTo(15.f * scale + 1);
        make.right.mas_equalTo(-12.f * scale);
    }];
    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDidClicked:)];
    tap1.numberOfTapsRequired = 1;
    self.Photo1.userInteractionEnabled = YES;
    [self.Photo1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDidClicked:)];
    tap2.numberOfTapsRequired = 1;
    self.Photo2.userInteractionEnabled = YES;
    [self.Photo2 addGestureRecognizer:tap2];
    
    UITapGestureRecognizer * tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoDidClicked:)];
    tap3.numberOfTapsRequired = 1;
    self.Photo3.userInteractionEnabled = YES;
    [self.Photo3 addGestureRecognizer:tap3];
}

- (void)photoDidClicked:(UITapGestureRecognizer *)tap
{
    NSArray * imageArray = [self.info objectForKey:@"repair_img"];
    [self showWindowImage:[imageArray objectAtIndex:tap.view.tag - 100]];
}

- (void)configWithInfo:(NSDictionary *)info
{
    self.info = info;
    NSString * userName = [info objectForKey:@"username"];
    NSString * time = [info objectForKey:@"repair_time"];
    NSString * boxName = [info objectForKey:@"box_name"];
    NSString * state = [info objectForKey:@"state"];
    NSString * remark = [info objectForKey:@"remark"];
    NSArray * imageArray = [info objectForKey:@"repair_img"];
    
    self.userNameLabel.text = [NSString stringWithFormat:@"执行人：%@", userName];
    self.boxNameLabel.text = [NSString stringWithFormat:@"维修版位：%@", boxName];
    if ([state isEqualToString:@"1"]) {
        self.stateLabel.text = @"已解决";
    }else if ([state isEqualToString:@"2"]) {
        self.stateLabel.text = @"未解决";
    }
    self.remarkLabel.text = [NSString stringWithFormat:@"备注：%@", remark];
    self.handleTimeLabel.text = [NSString stringWithFormat:@"操作时间：%@", time];
    
    if ([imageArray isKindOfClass:[NSArray class]]) {
        for (NSInteger i = 0; i < imageArray.count; i++) {
            UIImageView * imageView = (UIImageView *)[self.baseView viewWithTag:100+i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[imageArray objectAtIndex:i]]];
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
