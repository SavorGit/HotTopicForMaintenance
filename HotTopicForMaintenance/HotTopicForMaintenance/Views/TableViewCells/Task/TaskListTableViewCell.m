//
//  TaskListTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskListTableViewCell.h"
#import "HotTopicTools.h"

@interface TaskListTableViewCell ()

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * timeView;

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
@property (nonatomic, strong) UILabel * refuseLabel;

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
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(49 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self.topView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
        make.right.mas_equalTo(-15 * scale);
    }];
    
    self.statusLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x62ad19) font:kPingFangMedium(15.f * scale) alignment:NSTextAlignmentLeft];
    self.statusLabel.text = @"已完成";
    [self.topView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15.f * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.cityLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x444444) font:kPingFangRegular(13.f * scale) alignment:NSTextAlignmentLeft];
    self.cityLabel.text = @"(北京)";
    [self.topView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.statusLabel.mas_right).offset(8);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.remarkLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(14.f * scale) alignment:NSTextAlignmentCenter];
    self.remarkLabel.backgroundColor = UIColorFromRGB(0xf54444);
    self.remarkLabel.text = @"紧急";
    [self.topView addSubview:self.remarkLabel];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(44.f * scale);
        make.height.mas_equalTo(18.f * scale);
        make.center.mas_equalTo(0);
    }];
    
    self.deviceNumLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentRight];
    [self.topView addSubview:self.deviceNumLabel];
    [self.deviceNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-20.f * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.handleLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(16.f * scale) alignment:NSTextAlignmentCenter];
    self.handleLabel.backgroundColor = UIColorFromRGB(0x5c6366);
    [self.contentView addSubview:self.handleLabel];
    [self.handleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f * scale);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(15.f * scale);
        make.width.mas_equalTo(53.5 * scale);
        make.height.mas_equalTo(49.f * scale);
    }];
    self.handleLabel.layer.cornerRadius = 15.f * scale;
    self.handleLabel.layer.masksToBounds = YES;
    
    self.hotelNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(16.f * scale) alignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.hotelNameLabel];
    [self.hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(15.f * scale);
        make.left.mas_equalTo(self.handleLabel.mas_right).offset(24.f * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(16.f * scale + 1);
    }];
    
    self.timeView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotelNameLabel.mas_bottom).offset(20.f * scale);
        make.left.mas_equalTo(self.handleLabel.mas_right).offset(24.f * scale);
        make.bottom.right.mas_equalTo(0);
    }];
    
    self.assignHandelLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.createLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.assignLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.completeLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.refuseLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
}

- (void)configWithTaskModel:(TaskModel *)model
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    [self.timeView removeAllSubviews];
    
    self.hotelNameLabel.text = model.hotel_name;
    self.handleLabel.text = model.task_type_desc;
    self.statusLabel.text = model.state;
    self.cityLabel.text = [NSString stringWithFormat:@"(%@)", model.region_name];
    
    if (isEmptyString(model.tv_nums)) {
        self.deviceNumLabel.hidden = YES;
    }else{
        self.deviceNumLabel.text = [NSString stringWithFormat:@"版位数量：%@", model.tv_nums];
        self.deviceNumLabel.hidden = NO;
    }
    
    if (model.task_emerge_id == 3) {
        self.remarkLabel.hidden = YES;
    }else{
        self.remarkLabel.text = model.task_emerge;
        self.remarkLabel.hidden = NO;
    }
    
    switch (model.state_id) {
        case TaskStatusType_WaitAssign:
        {
            self.createLabel.text = [NSString stringWithFormat:@"发布时间：%@ (%@)", model.create_time, model.publish_user];
            [self.timeView addSubview:self.createLabel];
            [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            
            self.statusLabel.textColor = UIColorFromRGB(0xf3881f);
        }
            break;
            
        case TaskStatusType_WaitHandle:
        {
            self.assignHandelLabel.text = [NSString stringWithFormat:@"指派执行时间：%@ (%@)", model.appoint_exe_time, model.appoint_user];
            self.createLabel.text = [NSString stringWithFormat:@"发布时间：%@ (%@)", model.create_time, model.publish_user];
            self.assignLabel.text = [NSString stringWithFormat:@"指派时间：%@ (%@)", model.appoint_time, model.appoint_user];
            [self.timeView addSubview:self.assignHandelLabel];
            [self.timeView addSubview:self.createLabel];
            [self.timeView addSubview:self.assignLabel];
            
            [self.assignHandelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.assignHandelLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            [self.assignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.createLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            
            self.statusLabel.textColor = UIColorFromRGB(0x26bcef);
        }
            break;
            
        case TaskStatusType_Completed:
        {
            self.assignHandelLabel.text = [NSString stringWithFormat:@"指派执行时间：%@ (%@)", model.appoint_exe_time, model.appoint_user];
            self.createLabel.text = [NSString stringWithFormat:@"发布时间：%@ (%@)", model.create_time, model.publish_user];
            self.assignLabel.text = [NSString stringWithFormat:@"指派时间：%@ (%@)", model.appoint_time, model.appoint_user];
            self.completeLabel.text = [NSString stringWithFormat:@"完成时间：%@ (%@)", model.complete_time, model.exeuser];
            [self.timeView addSubview:self.assignHandelLabel];
            [self.timeView addSubview:self.createLabel];
            [self.timeView addSubview:self.assignLabel];
            [self.timeView addSubview:self.completeLabel];
            
            [self.assignHandelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.assignHandelLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            [self.assignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.createLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            [self.completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.assignLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            
            self.statusLabel.textColor = UIColorFromRGB(0x62ad19);
        }
            break;
            
        case TaskStatusType_Refuse:
        {
            self.createLabel.text = [NSString stringWithFormat:@"发布时间：%@ (%@)", model.create_time, model.publish_user];
            self.refuseLabel.text = [NSString stringWithFormat:@"拒绝时间：%@", model.refuse_time];
            [self.timeView addSubview:self.createLabel];
            [self.timeView addSubview:self.refuseLabel];
            
            [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            [self.refuseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.createLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            
            self.statusLabel.textColor = UIColorFromRGB(0xf54444);
        }
            break;
            
        default:
            break;
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
