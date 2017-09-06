//
//  RepairRecordHeaderView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RepairRecordHeaderView.h"

@interface RepairRecordHeaderView ()

@property (nonatomic, strong) UILabel * timeLabel;
@property (nonatomic, strong) UILabel * hotelLabel;

@end

@implementation RepairRecordHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.timeLabel.textColor = UIColorFromRGB(0x333333);
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.timeLabel.font = kPingFangRegular(14);
        [self.contentView addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.width.mas_lessThanOrEqualTo(150);
        }];
        
        self.hotelLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.hotelLabel.textColor = UIColorFromRGB(0x333333);
        self.hotelLabel.textAlignment = NSTextAlignmentLeft;
        self.hotelLabel.font = kPingFangRegular(14);
        [self.contentView addSubview:self.hotelLabel];
        [self.hotelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.equalTo(self.timeLabel.mas_right).offset(5);
            make.right.mas_equalTo(-10);
        }];
        
    }
    return self;
}

- (void)configWithModel:(RepairRecordModel *)model
{
    self.timeLabel.text = model.datetime;
    self.hotelLabel.text = [model.hotel_name stringByAppendingString:@"  维修记录"];
}

@end
