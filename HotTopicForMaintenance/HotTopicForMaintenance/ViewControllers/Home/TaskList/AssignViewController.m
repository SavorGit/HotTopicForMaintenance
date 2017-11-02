//
//  AssignViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AssignViewController.h"
#import "HotTopicTools.h"

@interface AssignViewController ()

@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UILabel * dateLabel;

@property (nonatomic, strong) UIDatePicker * datePicker;
@property (nonatomic, strong) UIView * blackView;

@end

@implementation AssignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"指派人员";
    [self createHeaderView];
}

- (void)createHeaderView
{
    self.headerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.headerView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UILabel * taskLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(16.f * scale) alignment:NSTextAlignmentLeft];
    taskLabel.text = @"任务详情";
    [self.headerView addSubview:taskLabel];
    [taskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20.f * scale);
        make.left.mas_equalTo(15.f * scale);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(16.f * scale + 1);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(taskLabel.mas_bottom).offset(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1.f);
    }];
    
    UIView * taskView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:taskView];
    [taskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40.f * scale);
    }];
    
    UILabel * taskNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    taskNameLabel.text = @"维修";
    [taskView addSubview:taskNameLabel];
    [taskNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25.f * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UILabel * hotelNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    hotelNameLabel.text = @"旺顺阁鱼头泡饼王府井店";
    [taskView addSubview:hotelNameLabel];
    [hotelNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(taskNameLabel.mas_right).offset(15.f * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UILabel * deviceNumberLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    deviceNumberLabel.text = @"版位数量：13";
    [taskView addSubview:deviceNumberLabel];
    [deviceNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(hotelNameLabel.mas_right).offset(15.f * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
    lineView2.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.headerView addSubview:lineView2];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(taskView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(5.f);
    }];
    
    UIView * timeView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.headerView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(40.f * scale);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeViewDidTap)];
    tap.numberOfTapsRequired = 1;
    [timeView addGestureRecognizer:tap];
    
    UILabel * assignLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(16.f * scale) alignment:NSTextAlignmentLeft];
    assignLabel.text = @"执行日期";
    [timeView addSubview:assignLabel];
    [assignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15.f * scale);
    }];
    
    self.dateLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(15.f * scale) alignment:NSTextAlignmentLeft];
    [timeView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(assignLabel.mas_right).offset(40.f * scale);
    }];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [timeView addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:@"more"]];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f * scale);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(16.f * scale);
    }];
    
    self.blackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.6f];
    
    [self.blackView addSubview:self.datePicker];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, self.datePicker.frame.origin.y - 50, kMainBoundsWidth, 50)];
    view.backgroundColor = UIColorFromRGB(0xffffff);
    [self.blackView addSubview:view];
    
    UIButton * cancle = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(18) backgroundColor:[UIColor clearColor] title:@"取消"];
    cancle.frame = CGRectMake(10, 10, 60, 40);
    [view addSubview:cancle];
    [cancle addTarget:self.blackView action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * button = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0x333333) font:kPingFangRegular(18) backgroundColor:[UIColor clearColor] title:@"完成"];
    button.frame = CGRectMake(kMainBoundsWidth - 70, 10, 60, 40);
    [view addSubview:button];
    [button addTarget:self action:@selector(dateDidBeChoose) forControlEvents:UIControlEventTouchUpInside];
}

- (void)timeViewDidTap
{
    [self.navigationController.view addSubview:self.blackView];
}

- (void)dateDidBeChoose
{
    NSDate * date = self.datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    self.dateLabel.text = [formatter stringFromDate:date];
    
    [self.blackView removeFromSuperview];
}

- (UIDatePicker *)datePicker
{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, kMainBoundsHeight / 3 * 2, kMainBoundsWidth, kMainBoundsHeight / 3)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.minimumDate = [NSDate date];
        _datePicker.backgroundColor = UIColorFromRGB(0xffffff);
    }
    return _datePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
