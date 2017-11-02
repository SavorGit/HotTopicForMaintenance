//
//  TaskDetailView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskDetailView.h"
#import "HotTopicTools.h"

@interface TaskDetailView ()

@property (nonatomic, weak) TaskListModel * model;

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
@property (nonatomic, strong) UILabel * assignHandelLabel;
@property (nonatomic, strong) UILabel * createLabel;
@property (nonatomic, strong) UILabel * assignLabel;
@property (nonatomic, strong) UILabel * completeLabel;
@property (nonatomic, strong) UILabel * refuseLabel;

@property (nonatomic, strong) UILabel * contactsLabel;

@end

@implementation TaskDetailView

- (instancetype)initWithTaskListModel:(TaskListModel *)model
{
    
    CGFloat height = 206.f;
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    switch (model.type) {
        case 1:
            height = 198.f * scale + 1;
            break;
            
        case 2:
            height = 246.f * scale + 3;
            break;
            
        case 3:
            height = 270.f * scale + 4;
            break;
            
        case 4:
            height = 222.f * scale + 2;
            break;
            
        default:
            break;
    }
    
    if (self = [super initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, height)]) {
        self.model = model;
        [self createTaskDetailView];
        [self configWithTaskListModel:model];
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
        make.centerY.mas_equalTo(0);
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
        make.left.mas_equalTo(20);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    self.timeView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.timeView];
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hotelNameLabel.mas_bottom).offset(20.f * scale);
        make.left.mas_equalTo(self.handleLabel.mas_right).offset(24.f * scale);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    self.assignHandelLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.createLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.assignLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.completeLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.refuseLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
}

- (void)contactButtonDidClicked
{
    [HotTopicTools callPhoneByNumber:self.model.contactWay];
}

- (void)configWithTaskListModel:(TaskListModel *)model
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    [self.timeView removeAllSubviews];
    
    CGFloat width = kMainBoundsWidth - 112.5 * scale;
    self.localLabel = [HotTopicTools labelWithFrame:CGRectMake(0, 0, width, 0) TextColor:UIColorFromRGB(0x888888) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
    self.localLabel.text = model.localtion;
    self.localLabel.numberOfLines = 0;
    [self.timeView addSubview:self.localLabel];
    CGFloat height = [HotTopicTools getHeightByWidth:width title:self.localLabel.text font:self.localLabel.font];
    [self.localLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.height.mas_equalTo(height);
        make.right.mas_equalTo(-20.f * scale);
    }];
    
    CGRect frame = self.frame;
    frame.size.height += (height + 10);
    self.frame = frame;
    
    self.hotelNameLabel.text = model.hotelName;
    self.handleLabel.text = model.handleName;
    self.statusLabel.text = model.status;
    self.cityLabel.text = [NSString stringWithFormat:@"(%@)", model.cityName];
    self.contactsLabel.text = [NSString stringWithFormat:@"联系方式：%@   %@", model.contacts, model.contactWay];
    
    if (isEmptyString(model.deviceNumber)) {
        self.deviceNumLabel.hidden = YES;
    }else{
        self.deviceNumLabel.text = [@"版位数量：" stringByAppendingString:model.deviceNumber];
        self.deviceNumLabel.hidden = NO;
    }
    
    if (isEmptyString(model.remark)) {
        self.remarkLabel.hidden = YES;
    }else{
        self.remarkLabel.text = model.remark;
        self.remarkLabel.hidden = NO;
    }
    
    switch (model.type) {
        case 1:
        {
            self.createLabel.text = [@"发布时间：" stringByAppendingString:model.createTime];
            [self.timeView addSubview:self.createLabel];
            [self.createLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.localLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(14.f * scale + 1);
            }];
            
            self.statusLabel.textColor = UIColorFromRGB(0xf3881f);
        }
            break;
            
        case 2:
        {
            self.assignHandelLabel.text = [@"指派执行时间：" stringByAppendingString:model.assignHandleTime];
            self.createLabel.text = [@"发布时间：" stringByAppendingString:model.createTime];
            self.assignLabel.text = [@"指派时间：" stringByAppendingString:model.assignTime];
            [self.timeView addSubview:self.assignHandelLabel];
            [self.timeView addSubview:self.createLabel];
            [self.timeView addSubview:self.assignLabel];
            
            [self.assignHandelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.localLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
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
            
        case 3:
        {
            self.assignHandelLabel.text = [@"指派执行时间：" stringByAppendingString:model.assignHandleTime];
            self.createLabel.text = [@"发布时间：" stringByAppendingString:model.createTime];
            self.assignLabel.text = [@"指派时间：" stringByAppendingString:model.assignTime];
            self.completeLabel.text = [@"完成时间：" stringByAppendingString:model.completeTime];
            [self.timeView addSubview:self.assignHandelLabel];
            [self.timeView addSubview:self.createLabel];
            [self.timeView addSubview:self.assignLabel];
            [self.timeView addSubview:self.completeLabel];
            
            [self.assignHandelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.localLabel.mas_bottom).offset(10);
                make.left.right.mas_equalTo(0);
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
            
        case 4:
        {
            self.createLabel.text = [@"发布时间：" stringByAppendingString:model.createTime];
            self.refuseLabel.text = [@"拒绝时间：" stringByAppendingString:model.refuseTime];
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
