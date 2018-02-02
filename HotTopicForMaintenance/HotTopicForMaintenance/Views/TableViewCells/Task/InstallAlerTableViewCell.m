//
//  InstallAlerTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "InstallAlerTableViewCell.h"
#import "Helper.h"
#import "UIImageView+WebCache.h"

@interface InstallAlerTableViewCell()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *titlePosionLabel;
@property (nonatomic, strong) UIButton *addImgBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation InstallAlerTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    float bgVideoWidth = [Helper autoWidthWith:266];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    _bgView.layer.borderColor = UIColorFromRGB(0xf6f2ed).CGColor;
    _bgView.layer.borderWidth = .5f;
    _bgView.layer.cornerRadius = 5.f;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(bgVideoWidth - 30);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
    }];
    
    self.imgBgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imgBgView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imgBgView setImage:[UIImage imageNamed:@"zanwu"]];
    [self.imgBgView setBackgroundColor:[UIColor clearColor]];
    [_bgView addSubview:self.imgBgView];
    CGFloat scale = kMainBoundsWidth/375.f;
    [self.imgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((bgVideoWidth - 60) *scale, 60 *scale));
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(_bgView);
    }];
    
    self.instaImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.instaImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.instaImg setBackgroundColor:[UIColor clearColor]];
    [self.imgBgView addSubview:self.instaImg];
//    CGFloat scale = kMainBoundsWidth/375.f;
    [self.instaImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((bgVideoWidth - 60) *scale, 60 *scale));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
    self.titlePosionLabel = [[UILabel alloc]init];
    self.titlePosionLabel.font = [UIFont systemFontOfSize:14];
    self.titlePosionLabel.textColor = UIColorFromRGB(0x434343);
    self.titlePosionLabel.textAlignment = NSTextAlignmentCenter;
    self.titlePosionLabel.text = @"安装流程单";
    [_bgView addSubview:self.titlePosionLabel];
    [self.titlePosionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(self.instaImg.mas_bottom);
        make.centerX.mas_equalTo(_bgView);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImgPress)];
    tap.numberOfTapsRequired = 1;
    [self.instaImg addGestureRecognizer:tap];
}

- (void)configWithContent:(NSString *)titleString andIdexPath:(NSIndexPath *)index andDataModel:(RestaurantRankModel *)model{

    self.titlePosionLabel.text = titleString;
    if (!isEmptyString(model.repair_img)) {
        [self.instaImg sd_setImageWithURL:[NSURL URLWithString:model.repair_img] placeholderImage:[UIImage imageNamed:@""]];
//        [self.instaImg sd_setImageWithURL:[NSURL URLWithString:model.repair_img]];
    }else{
        [self.instaImg setImage:model.seRepairImg];
        if (model.seRepairImg == nil) {
            [self.imgBgView setImage:[UIImage imageNamed:@"zanwu"]];
        }
    }
}

- (void)addImgPress{
    if ([self.delegate respondsToSelector:@selector(addImgPress:)]) {
        [self.delegate addImgPress:self.indexPath];
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
