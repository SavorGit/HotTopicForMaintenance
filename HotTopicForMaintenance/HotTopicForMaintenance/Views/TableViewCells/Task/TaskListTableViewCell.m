//
//  TaskListTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskListTableViewCell.h"

@interface TaskListTableViewCell ()

@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * cityLabel;
@property (nonatomic, strong) UILabel * remarkLabel;
@property (nonatomic, strong) UILabel * deviceNumLabel;
@property (nonatomic, strong) UILabel * handleLabel;
@property (nonatomic, strong) UILabel * hotelNameLabel;
@property (nonatomic, strong) UILabel * assignHandelLabel;
@property (nonatomic, strong) UILabel * createLabel;
@property (nonatomic, strong) UILabel * assignLabel;
@property (nonatomic, strong) UILabel * completeLabel;

@end

@implementation TaskListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self createTaskListCell];
    }
    return self;
}

- (void)createTaskListCell
{
    
}

- (void)configWithTaskListModel:(TaskListModel *)model
{
    
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
