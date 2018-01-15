//
//  SystemStatusHotelCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/15.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "SystemStatusHotelCell.h"
#import "HotTopicTools.h"

@interface SystemStatusHotelCell ()

@property (nonatomic, strong) UILabel * deviceNameLabel;
@property (nonatomic, strong) UILabel * totalNumberLabel;
@property (nonatomic, strong) UILabel * normalLabel;
@property (nonatomic, strong) UILabel * frozenLabel;

@end

@implementation SystemStatusHotelCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    self.deviceNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15 * scale) alignment:NSTextAlignmentLeft];
    self.deviceNameLabel.text = @"一代";
    [self.contentView addSubview:self.deviceNameLabel];
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
