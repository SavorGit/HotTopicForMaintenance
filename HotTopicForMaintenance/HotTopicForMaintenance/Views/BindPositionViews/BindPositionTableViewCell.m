//
//  BindPositionTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BindPositionTableViewCell.h"
#import "HotTopicTools.h"

@interface BindPositionTableViewCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *leftImgView;
@property (nonatomic, strong) UILabel *wifiNameLabel;

@property (nonatomic, strong) UILabel *tvNameLabel;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *boxNameLabel;
@property (nonatomic, strong) UILabel *macAddressLabel;

@property (nonatomic, strong) UIButton *bindBtn;

@end

@implementation BindPositionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = UIColorFromRGB(0xffffff);
    _bgView.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    _bgView.layer.borderWidth = .5f;
    _bgView.layer.cornerRadius = 5.f;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 20);
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
    
    self.leftImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.leftImgView.backgroundColor = [UIColor grayColor];
    self.leftImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.leftImgView.layer.cornerRadius = 20/2.0;
    self.leftImgView.layer.masksToBounds = YES;
    [_bgView addSubview:self.leftImgView];
    [self.leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
    }];
    
    self.wifiNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(14.f) alignment:NSTextAlignmentLeft];
    self.wifiNameLabel.text = @"V001";
    [_bgView addSubview:self.wifiNameLabel];
    [self.wifiNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 20));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.leftImgView.mas_right).offset(10);
    }];
    
    self.tvNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(14.f) alignment:NSTextAlignmentLeft];
    self.tvNameLabel.text = @"电视名称：";
    [_bgView addSubview:self.tvNameLabel];
    [self.tvNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 45 - 80 - 10, 20));
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(self.wifiNameLabel.mas_right).offset(10);
    }];
    
    self.roomNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(14.f) alignment:NSTextAlignmentLeft];
    self.roomNameLabel.text = @"包间名称：";
    [_bgView addSubview:self.roomNameLabel];
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 45 - 80 - 10, 20));
        make.top.mas_equalTo(self.tvNameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.wifiNameLabel.mas_right).offset(10);
    }];
    
    self.boxNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(14.f) alignment:NSTextAlignmentLeft];
    self.boxNameLabel.text = @"机顶盒名称：";
    [_bgView addSubview:self.boxNameLabel];
    [self.boxNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 45 - 80 - 10, 20));
        make.top.mas_equalTo(self.roomNameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.wifiNameLabel.mas_right).offset(10);
    }];
    
    self.macAddressLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(14.f) alignment:NSTextAlignmentLeft];
    self.macAddressLabel.text = @"MAC地址：";
    [_bgView addSubview:self.macAddressLabel];
    [self.macAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 45 - 80 - 10, 20));
        make.top.mas_equalTo(self.boxNameLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.wifiNameLabel.mas_right).offset(10);
    }];
    
    self.bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bindBtn setBackgroundColor:[UIColor blueColor]];
    self.bindBtn.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    self.bindBtn.layer.borderWidth = .5f;
    self.bindBtn.layer.cornerRadius = 5.f;
    self.bindBtn.layer.masksToBounds = YES;
    [self.bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [self.bindBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.bindBtn addTarget:self action:@selector(selectImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:self.bindBtn];
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 35));
        make.centerY.mas_equalTo(_bgView.mas_centerY);
        make.right.mas_equalTo(_bgView.mas_right).offset(- 15);
    }];

}

- (void)configWithModel:(RestaurantRankModel *)model{
    
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
