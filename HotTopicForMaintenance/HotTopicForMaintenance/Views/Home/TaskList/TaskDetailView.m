//
//  TaskDetailView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskDetailView.h"
#import "HotTopicTools.h"
#import "MBProgressHUD+Custom.h"

@interface TaskDetailView ()

@property (nonatomic, weak) TaskModel * model;

@property (nonatomic, strong) UIView * topView;
@property (nonatomic, strong) UIView * timeView;
@property (nonatomic, strong) UIView * bottomView;

@property (nonatomic, strong) UILabel * statusLabel;
@property (nonatomic, strong) UILabel * cityLabel;
@property (nonatomic, strong) UILabel * remarkLabel;
@property (nonatomic, strong) UILabel * deviceNumLabel;
@property (nonatomic, strong) UILabel * handleLabel;
@property (nonatomic, strong) UILabel * hotelNameLabel;

@property (nonatomic, strong) UILabel * localLabel;

@property (nonatomic, strong) UILabel * assignHandelTLabel;
@property (nonatomic, strong) UILabel * assignHandelLabel;

@property (nonatomic, strong) UILabel * createLabel;

@property (nonatomic, strong) UILabel * assignTLabel;
@property (nonatomic, strong) UILabel * assignLabel;

@property (nonatomic, strong) UILabel * completeTLabel;
@property (nonatomic, strong) UILabel * completeLabel;

@property (nonatomic, strong) UILabel * refuseLabel;

@property (nonatomic, strong) UILabel * installTeamLabel;

@property (nonatomic, strong) UILabel * refuseReasonLabel;

@property (nonatomic, strong) UILabel * contactsLabel;

@property (nonatomic, strong) UILabel * detailRemarkLabel;

@end

@implementation TaskDetailView

- (instancetype)initWithTaskModel:(TaskModel *)model
{
    
    CGFloat height = 206.f;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    switch (model.state_id) {
        case TaskStatusType_WaitAssign:
            height = 198.f * scale + 1;
            break;
            
        case TaskStatusType_WaitHandle:
        {
            if (model.task_type_id == TaskType_Install) {
                height = 275.f * scale + 3;
            }else{
                height = 245.f * scale + 2;
            }
        }
            break;
            
        case TaskStatusType_Completed:
            
        {
            if (model.task_type_id == TaskType_Install) {
                height = 300.f * scale + 3;
            }else{
                height = 275.f * scale + 2;
            }
        }
            break;
            
        case TaskStatusType_Refuse:
            height = 252.f * scale + 2;
            break;
            
        default:
            break;
    }
    
    if (self = [super initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, height)]) {
        self.model = model;
        [self createTaskDetailView];
        [self configWithTaskModel:model];
    }
    return self;
}

- (void)createTaskDetailView
{
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.topView];
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
    [self.topView addSubview:self.statusLabel];
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15.f * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.cityLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x444444) font:kPingFangRegular(13.f * scale) alignment:NSTextAlignmentLeft];
    [self.topView addSubview:self.cityLabel];
    [self.cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.statusLabel.mas_right).offset(8);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.remarkLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0xffffff) font:kPingFangMedium(14.f * scale) alignment:NSTextAlignmentCenter];
    self.remarkLabel.backgroundColor = UIColorFromRGB(0xf54444);
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
    [self addSubview:self.handleLabel];
    [self.handleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f * scale);
        make.top.mas_equalTo(self.topView.mas_bottom).offset(15.f * scale);
        make.width.mas_equalTo(53.5 * scale);
        make.height.mas_equalTo(49.f * scale);
    }];
    self.handleLabel.layer.cornerRadius = 15.f * scale;
    self.handleLabel.layer.masksToBounds = YES;
    
    self.hotelNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(16.f * scale) alignment:NSTextAlignmentLeft];
    [self addSubview:self.hotelNameLabel];
    [self.hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom).offset(15.f * scale);
        make.left.mas_equalTo(self.handleLabel.mas_right).offset(24.f * scale);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(16.f * scale + 1);
    }];
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(49.f * scale);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectZero];
    bottomLine.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self.bottomView addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    UIButton * contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactButton setTitle:@"联系" forState:UIControlStateNormal];
    [contactButton setTitleColor:UIColorFromRGB(0x66cc00) forState:UIControlStateNormal];
    contactButton.titleLabel.font = kPingFangRegular(15.f * scale);
    [self.bottomView addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomLine.mas_bottom).offset(10.f * scale);
        make.right.mas_equalTo(-20.f * scale);
        make.width.mas_equalTo(56.f * scale);
        make.height.mas_equalTo(25.f * scale);
    }];
    contactButton.layer.borderColor = UIColorFromRGB(0x66cc00).CGColor;
    contactButton.layer.borderWidth = 1.f;
    [contactButton addTarget:self action:@selector(contactButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.contactsLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    [self.bottomView addSubview:self.contactsLabel];
    [self.contactsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomLine.mas_bottom).offset(15.f * scale);
        make.left.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-20 * scale);
        make.height.mas_equalTo(15.f * scale + 1);
    }];
    
    self.timeView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotelNameLabel.mas_bottom).offset(20.f * scale);
        make.left.mas_equalTo(self.handleLabel.mas_right).offset(24.f * scale);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    self.detailRemarkLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    self.detailRemarkLabel.numberOfLines = 0;
    self.detailRemarkLabel.text = @"备注：无";
    [self.bottomView addSubview:self.detailRemarkLabel];
    
    if (self.model.state_id == TaskStatusType_WaitHandle || self.model.state_id == TaskStatusType_Completed) {
        
        if (self.model.task_type_id == TaskType_Install) {
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(79 * scale);
            }];
            
            self.installTeamLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
            [self.bottomView addSubview:self.installTeamLabel];
            [self.installTeamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contactsLabel.mas_bottom).offset(15.f * scale);
                make.left.mas_equalTo(20 * scale);
                make.right.mas_equalTo(-20 * scale);
                make.height.mas_equalTo(15.f * scale + 1);
            }];
            if (self.model.is_lead_install == 1) {
                self.installTeamLabel.text = @"带队安装：需要";
            }else{
                self.installTeamLabel.text = @"带队安装：不需要";
            }
        }
    }
    
    if (self.model.state_id == TaskStatusType_Refuse) {
        
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(79 * scale);
        }];
        
        self.refuseReasonLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
        [self.bottomView addSubview:self.refuseReasonLabel];
        [self.refuseReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contactsLabel.mas_bottom).offset(15.f * scale);
            make.left.mas_equalTo(20 * scale);
            make.right.mas_equalTo(-20 * scale);
            make.height.mas_equalTo(15.f * scale + 1);
        }];
        self.refuseReasonLabel.text = [NSString stringWithFormat:@"拒绝原因：%@", self.model.refuse_desc];
    }
    
    self.assignHandelTLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.assignHandelLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
     self.assignHandelLabel.numberOfLines = 0;
    
    self.createLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    
    self.assignTLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.assignLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.assignLabel.numberOfLines = 0;
    
    self.completeTLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.completeLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.completeLabel.numberOfLines = 0;
    
    self.refuseLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
}

- (void)contactButtonDidClicked
{
    NSString * telNumber = self.model.hotel_linkman_tel;
    if (isEmptyString(telNumber)) {
        [MBProgressHUD showTextHUDWithText:@"电话号码不存在" inView:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    [HotTopicTools callPhoneByNumber:self.model.hotel_linkman_tel];
}

- (void)configWithTaskModel:(TaskModel *)model
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    [self.timeView removeAllSubviews];
    
    CGFloat width = kMainBoundsWidth - 112.5 * scale;
    self.localLabel = [HotTopicTools labelWithFrame:CGRectMake(0, 0, width, 0) TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.localLabel.text = model.hotel_address;
    self.localLabel.numberOfLines = 0;
    [self.timeView addSubview:self.localLabel];
    CGFloat height1 = [HotTopicTools getHeightByWidth:width title:self.localLabel.text font:self.localLabel.font];
    [self.localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(height1);
        make.right.mas_equalTo(-20.f * scale);
    }];
    
    if (isEmptyString(model.desc)) {
        self.detailRemarkLabel.text = @"备注：无";
    }else{
        self.detailRemarkLabel.text = [NSString stringWithFormat:@"备注：%@", model.desc];
    }
    CGFloat height2 = [HotTopicTools getHeightByWidth:kMainBoundsWidth - 40 * scale title:self.detailRemarkLabel.text font:self.detailRemarkLabel.font];
    
    [self.detailRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-20 * scale);
        make.height.mas_equalTo(height2);
        make.bottom.mas_equalTo(-15 * scale);
    }];
    
    height2 += 30 * scale;
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView2.backgroundColor = UIColorFromRGB(0xd7d7d7);
    [self.bottomView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-height2);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(.5f);
    }];
    
    CGRect frame = self.frame;
    frame.size.height += (height1 + 10);
    frame.size.height += height2;
    self.frame = frame;
    
    self.hotelNameLabel.text = model.hotel_name;
    self.handleLabel.text = model.task_type_desc;
    self.statusLabel.text = model.state;
    self.cityLabel.text = [NSString stringWithFormat:@"(%@)", model.region_name];
    self.contactsLabel.text = [NSString stringWithFormat:@"联系方式：%@   %@", model.hotel_linkman, model.hotel_linkman_tel];
    
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
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(49 * scale + height2);
            }];
            
            self.createLabel.text = [NSString stringWithFormat:@"发布时间：%@ (%@)", model.create_time, model.publish_user];
            [self.timeView addSubview:self.createLabel];
            [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.localLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            
            self.statusLabel.textColor = UIColorFromRGB(0xf3881f);
        }
            break;
            
        case TaskStatusType_WaitHandle:
        {
            if (self.model.task_type_id == TaskType_Install) {
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(79 * scale + height2);
                }];
            }else{
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(49 * scale + height2);
                }];
            }
            
            self.assignHandelTLabel.text = @"指派执行时间：";
            self.assignHandelLabel.text = [NSString stringWithFormat:@"%@ (%@)", model.appoint_exe_time, model.exeuser];
            self.createLabel.text = [NSString stringWithFormat:@"发布时间：%@ (%@)", model.create_time, model.publish_user];
            self.assignLabel.text = [NSString stringWithFormat:@"指派时间：%@ (%@)", model.appoint_time, model.appoint_user];
            [self.timeView addSubview:self.assignHandelTLabel];
            [self.timeView addSubview:self.assignHandelLabel];
            [self.timeView addSubview:self.createLabel];
            [self.timeView addSubview:self.assignLabel];
            
            [self.assignHandelTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.localLabel.mas_bottom).offset(7);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(98.f *scale);
                make.height.mas_equalTo(21.67f);
            }];
            
            CGFloat ahHeight = [HotTopicTools getHeightByWidth:self.width - (92.5 + 98) *scale title:self.assignHandelLabel.text font:kPingFangRegular(14.f * scale)];
            
            [self.assignHandelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.localLabel.mas_bottom).offset(7);
                make.left.mas_equalTo(self.assignHandelTLabel.mas_right);
                make.width.mas_equalTo(self.width - (92.5 + 98) *scale);
                make.height.mas_equalTo(ahHeight);
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
            self.height = self.height + ahHeight - 21.67f;
        }
            break;
            
        case TaskStatusType_Completed:
        {
            if (self.model.task_type_id == TaskType_Install) {
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(79 * scale + height2);
                }];
            }else{
                [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(49 * scale + height2);
                }];
            }
            
            self.assignHandelTLabel.text = @"指派执行时间：";
            self.assignHandelLabel.text = [NSString stringWithFormat:@"%@ (%@)", model.appoint_exe_time, model.exeuser];
            self.createLabel.text = [NSString stringWithFormat:@"发布时间：%@ (%@)", model.create_time, model.publish_user];
            self.assignTLabel.text = @"指派时间：";
            self.assignLabel.text = [NSString stringWithFormat:@"%@ (%@)", model.appoint_time, model.appoint_user];
            
            self.completeTLabel.text = @"完成时间：";
            self.completeLabel.text = [NSString stringWithFormat:@"%@ (%@)", model.complete_time, model.exeuser];
            [self.timeView addSubview:self.assignHandelTLabel];
            [self.timeView addSubview:self.assignHandelLabel];
            [self.timeView addSubview:self.createLabel];
            [self.timeView addSubview:self.assignTLabel];
            [self.timeView addSubview:self.assignLabel];
            [self.timeView addSubview:self.completeTLabel];
            [self.timeView addSubview:self.completeLabel];
            
            [self.assignHandelTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.localLabel.mas_bottom).offset(7);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(98.f *scale);
                make.height.mas_equalTo(21.67f);
            }];
            
            CGFloat ahHeight = [HotTopicTools getHeightByWidth:self.width - (92.5 + 98) *scale title:self.assignHandelLabel.text font:kPingFangRegular(14.f * scale)];
            
            [self.assignHandelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.localLabel.mas_bottom).offset(7);
                make.left.mas_equalTo(self.assignHandelTLabel.mas_right);
                make.width.mas_equalTo(self.width - (92.5 + 98) *scale);
                make.height.mas_equalTo(ahHeight);
            }];
            
            [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.assignHandelLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            [self.assignTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.createLabel.mas_bottom).offset(7);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(70.f *scale);
                make.height.mas_equalTo(21.67f);
            }];
            
            CGFloat asHeight = [HotTopicTools getHeightByWidth:self.width - (92.5 + 70) *scale title:self.assignLabel.text font:kPingFangRegular(14.f * scale)];
            [self.assignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.createLabel.mas_bottom).offset(7);
                make.left.mas_equalTo(self.assignTLabel.mas_right);
                make.width.mas_equalTo(self.width - (92.5 + 70) *scale);
                make.height.mas_equalTo(asHeight);
            }];
            
            [self.completeTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.assignLabel.mas_bottom).offset(7);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(70.f *scale);
                make.height.mas_equalTo(21.67f);
            }];
            CGFloat cpHeight = [HotTopicTools getHeightByWidth:self.width - (92.5 + 70) *scale title:self.completeLabel.text font:kPingFangRegular(14.f * scale)];
            [self.completeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.assignLabel.mas_bottom).offset(7);
                make.left.mas_equalTo(self.completeTLabel.mas_right);
                make.width.mas_equalTo(self.width - (92.5 + 70) *scale);
                make.height.mas_equalTo(cpHeight);
            }];
            
            self.statusLabel.textColor = UIColorFromRGB(0x62ad19);
            self.height = self.height + ahHeight - 21.67f + asHeight - 21.67f + cpHeight - 21.67f;
        }
            break;
            
        case TaskStatusType_Refuse:
        {
            [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(79 * scale + height2);
            }];
            
            self.createLabel.text = [NSString stringWithFormat:@"发布时间：%@ (%@)", model.create_time, model.publish_user];
            self.refuseLabel.text = [NSString stringWithFormat:@"拒绝时间：%@ (%@)", model.refuse_time, model.appoint_user];
            [self.timeView addSubview:self.createLabel];
            [self.timeView addSubview:self.refuseLabel];
            
            [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.localLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
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

@end
