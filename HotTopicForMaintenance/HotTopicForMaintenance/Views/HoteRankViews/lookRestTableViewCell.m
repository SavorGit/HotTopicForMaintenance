//
//  lookRestTableViewCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "lookRestTableViewCell.h"

@interface lookRestTableViewCell()

@property (nonatomic, strong) UILabel *serialNumLab;
@property (nonatomic, strong) UILabel *stbLocationLab;
@property (nonatomic, strong) UILabel *stbMacLab;
@property (nonatomic, strong) UILabel *stbStateLab;

@end

@implementation lookRestTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.serialNumLab = [[UILabel alloc]init];
    self.serialNumLab.font = [UIFont systemFontOfSize:14];
    self.serialNumLab.textColor = UIColorFromRGB(0x434343);
    self.serialNumLab.textAlignment = NSTextAlignmentCenter;
    self.serialNumLab.text = @"1";
    [self addSubview:self.serialNumLab];
    [self.serialNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 10)/4 - 15, 20));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(10);
    }];
    
    self.stbLocationLab = [[UILabel alloc]init];
    self.stbLocationLab.font = [UIFont systemFontOfSize:14];
    self.stbLocationLab.textColor = UIColorFromRGB(0x434343);
    self.stbLocationLab.textAlignment = NSTextAlignmentCenter;
    self.stbLocationLab.text = @"包间V1";
    [self addSubview:self.stbLocationLab];
    [self.stbLocationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 10)/4, 20));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(self.serialNumLab.mas_right);
    }];
    
    self.stbMacLab = [[UILabel alloc]init];
    self.stbMacLab.font = [UIFont systemFontOfSize:14];
    self.stbMacLab.textColor = UIColorFromRGB(0x434343);
    self.stbMacLab.textAlignment = NSTextAlignmentCenter;
    self.stbMacLab.text = @"192denerhg";
    [self addSubview:self.stbMacLab];
    [self.stbMacLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 10)/4 + 15, 20));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(self.stbLocationLab.mas_right);
    }];
    
    self.stbStateLab = [[UILabel alloc]init];
    self.stbStateLab.font = [UIFont systemFontOfSize:14];
    self.stbStateLab.textColor = UIColorFromRGB(0x434343);
    self.stbStateLab.textAlignment = NSTextAlignmentLeft;
    self.stbStateLab.text = @"正常";
    [self addSubview:self.stbStateLab];
    [self.stbStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 10)/4 - 15, 20));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(self.stbMacLab.mas_right).offset(15);
    }];
    
}

- (void)configWithModel:(LookHotelInforModel *)model{
    
    self.serialNumLab.text = model.room_name;
    self.stbLocationLab.text = model.bmac_name;
    self.stbMacLab.text = model.bmac_addr;
    self.stbMacLab.text = model.bstate;
    
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
