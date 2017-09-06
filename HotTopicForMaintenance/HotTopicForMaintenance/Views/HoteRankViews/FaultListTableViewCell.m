//
//  FaultListTableViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "FaultListTableViewCell.h"

@interface FaultListTableViewCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *reasonLabel;


@end

@implementation FaultListTableViewCell

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
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 30 - 60);
        make.height.mas_equalTo(38);
        make.top.mas_equalTo(2);
        make.left.mas_equalTo(15);
    }];
    
    self.reasonLabel = [[UILabel alloc]init];
    self.reasonLabel.font = [UIFont systemFontOfSize:14];
    self.reasonLabel.textColor = UIColorFromRGB(0x434343);
    self.reasonLabel.textAlignment = NSTextAlignmentLeft;
    self.reasonLabel.text = @"故障原因";
    [_bgView addSubview:self.reasonLabel];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30- 20 - 60), 20));
        make.top.mas_equalTo(9);
        make.left.mas_equalTo(15);
    }];
    
    self.selectImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.selectImgView.backgroundColor = [UIColor grayColor];
    self.selectImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.selectImgView.layer.cornerRadius = 20/2.0;
    self.selectImgView.layer.masksToBounds = YES;
    [self.selectImgView setImage:[UIImage imageNamed:@""]];
    [_bgView addSubview:self.selectImgView];
    self.selectImgView.hidden = YES;
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(9);
        make.right.mas_equalTo(- 15);
    }];

}

- (void)configWithModel:(RestaurantRankModel *)model{
    
    self.reasonLabel.text = model.reason;
    
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
