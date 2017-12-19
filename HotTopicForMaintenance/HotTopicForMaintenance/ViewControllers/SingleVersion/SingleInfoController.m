//
//  SingleInfoController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/12/19.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "SingleInfoController.h"
#import "HotTopicTools.h"
#import "UserManager.h"
#import "SearchHotelViewController.h"

@interface SingleInfoController ()

@property (nonatomic, strong) UILabel * locationLabel;
@property (nonatomic, strong) UILabel * nameLabel;

@end

@implementation SingleInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"更新换画";
    [self createSingleInfo];
}

- (void)createSingleInfo
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UILabel * searchLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:[UIFont systemFontOfSize:15 * scale] alignment:NSTextAlignmentLeft];
    searchLabel.layer.cornerRadius = 5.f;
    searchLabel.layer.masksToBounds = YES;
    searchLabel.layer.borderColor = [UIColor blackColor].CGColor;
    searchLabel.layer.borderWidth = .5f;
    searchLabel.text = @"  搜索酒楼";
    [self.view addSubview:searchLabel];
    [searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40.f * scale);
        make.left.mas_equalTo(30.f * scale);
        make.right.mas_equalTo(-30.f * scale);
        make.height.mas_equalTo(40.f * scale);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchLabelDidTap:)];
    searchLabel.userInteractionEnabled = YES;
    tap.numberOfTapsRequired = 1;
    [searchLabel addGestureRecognizer:tap];
    
    self.nameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17 * scale] alignment:NSTextAlignmentLeft];
    self.nameLabel.text = [NSString stringWithFormat:@"当前登录用户:%@", [UserManager manager].user.username];
    [self.view addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50.f * scale);
        make.bottom.mas_equalTo(-80.f * scale);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-50.f * scale);
    }];
    
    self.locationLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:[UIColor grayColor] font:[UIFont systemFontOfSize:17 * scale] alignment:NSTextAlignmentLeft];
    self.locationLabel.numberOfLines = 0;
    self.locationLabel.text = [NSString stringWithFormat:@"当前位置:%@", [UserManager manager].locationName];
    [self.view addSubview:self.locationLabel];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(50.f * scale);
        make.bottom.mas_equalTo(self.nameLabel.mas_top).offset(-20.f * scale);
        make.right.mas_equalTo(-50.f * scale);
    }];
}

- (void)searchLabelDidTap:(UITapGestureRecognizer *)tap
{
    SearchHotelViewController * search = [[SearchHotelViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
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
