//
//  InstallProAlertView.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "InstallProAlertView.h"
#import "InstallAlerTableViewCell.h"
#import "Helper.h"
#import "UserManager.h"

@interface InstallProAlertView ()<UITableViewDelegate, UITableViewDataSource,InstallCellDelegate>

@property (nonatomic, strong) NSArray    *titleArray;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) UIImageView *sheetBgView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UILabel *numLabel;

@end

@implementation InstallProAlertView

- (instancetype)initWithTotalCount:(NSInteger )totalCount andTitleArray:(NSArray *)titleArray  andDataArr:(NSArray *)dataArray{
    
    if (self = [super init]) {
        self.titleArray = titleArray;
        self.totalCount = totalCount;
        self.dataArray = dataArray;
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    
    self.sheetBgView = [[UIImageView alloc] init];
    float bgVideoHeight = 0.f;
    if ([UserManager manager].isIphoneX == YES) {
        bgVideoHeight = [Helper autoHeightWith:kMainBoundsHeight - kStatusBarHeight - kNaviBarHeight - 50 - 170];
    }else{
        bgVideoHeight = [Helper autoHeightWith:kMainBoundsHeight - 64 - 100];
    }
    float bgVideoWidth = [Helper autoWidthWith:266];
    self.self.sheetBgView.frame = CGRectZero;
    self.sheetBgView.image = [UIImage imageNamed:@"wj_kong"];
    self.sheetBgView.backgroundColor = [UIColor whiteColor];
    self.sheetBgView.userInteractionEnabled = YES;
    self.sheetBgView.layer.borderColor = UIColorFromRGB(0xf6f2ed).CGColor;
    self.sheetBgView.layer.borderWidth = .5f;
    self.sheetBgView.layer.cornerRadius = 6.f;
    self.sheetBgView.layer.masksToBounds = YES;
    [self addSubview:self.sheetBgView];
    [self.sheetBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(bgVideoWidth,bgVideoHeight));
        make.center.mas_equalTo(self);
    }];

    _alertTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _alertTableView.dataSource = self;
    _alertTableView.delegate = self;
    _alertTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _alertTableView.backgroundColor = [UIColor  clearColor];
    _alertTableView.backgroundView = nil;
    _alertTableView.showsVerticalScrollIndicator = NO;
    [self.sheetBgView  addSubview:_alertTableView];
//    [_alertTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(bgVideoWidth,bgVideoHeight - 60));
//        make.centerX.mas_equalTo(self.sheetBgView);
//        make.top.mas_equalTo(10);
//    }];
    
    // 如果是弹窗类型为信息监测和网络改造
    if (self.titleArray != nil) {

        [_alertTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(bgVideoWidth,bgVideoHeight - 60));
            make.centerX.mas_equalTo(self.sheetBgView);
            make.top.mas_equalTo(10);
        }];

    }else{
        // 如果是弹窗类型为安装
        UIView *topView = [[UIView alloc] initWithFrame:CGRectZero];
        topView.backgroundColor = UIColorFromRGB(0xf6f2ed);
        [self.sheetBgView addSubview:topView];
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(bgVideoWidth, 40));
            make.top.left.mas_equalTo(0);
        }];

        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.textColor = [UIColor blackColor];
        textLabel.font = kPingFangRegular(14);
        textLabel.text = @"实际安装数量";
        [topView addSubview:textLabel];
        [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 20));
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
        }];


        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
        [addBtn addTarget:self action:@selector(addPress) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(- 10);
        }];

        self.numLabel = [[UILabel alloc]init];
        self.numLabel.font = [UIFont systemFontOfSize:15];
        self.numLabel.textColor = [UIColor blackColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.text = @"1";
        [topView addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 30));
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(addBtn.mas_left);
        }];

        UIButton * reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reduceBtn setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
        [reduceBtn addTarget:self action:@selector(reducePress) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:reduceBtn];
        [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(5);
            make.right.mas_equalTo(self.numLabel.mas_left);
        }];

        [_alertTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(bgVideoWidth,bgVideoHeight - 60 - 40));
            make.centerX.mas_equalTo(self.sheetBgView);
            make.top.mas_equalTo(10 + 40);
        }];
    }

    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self.dataArray.count > 0) {
        [self.submitBtn setTitle:@"保存" forState:UIControlStateNormal];
    }else{
        [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    }
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.submitBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [self.submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.submitBtn.layer.borderWidth = .5f;
    self.submitBtn.layer.cornerRadius = 2.f;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_alertTableView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset(50);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.layer.borderWidth = .5f;
    cancelBtn.layer.cornerRadius = 2.f;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetBgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_alertTableView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.sheetBgView.centerX).offset(- 50);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
}

- (void)addPress{
    self.numLabel.text = [NSString stringWithFormat:@"%d",[self.numLabel.text intValue] + 1];
//    [self.delegate addNPress];
}

- (void)reducePress{
    if (![self.numLabel.text isEqualToString:@"0"]) {
        self.numLabel.text = [NSString stringWithFormat:@"%d",[self.numLabel.text intValue] - 1];
    }
//    [self.delegate reduceNPress];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.totalCount;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"RepairHeaderCell";
    InstallAlerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[InstallAlerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    if (self.titleArray != nil) {
        [cell configWithContent:self.titleArray[indexPath.row] andIdexPath:indexPath andDataModel:nil];
    }else{
        if (self.dataArray.count > 0) {
            RestaurantRankModel *tmpModel = self.dataArray[indexPath.row];
            [cell configWithContent:@"安装流程单" andIdexPath:indexPath andDataModel:tmpModel];
//            tmpModel.seRepairImg = cell.instaImg.image;
        }else{
             [cell configWithContent:@"安装流程单" andIdexPath:indexPath andDataModel:nil];
        }
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(creatPhotoOrCamaraView:)]) {
        [self.delegate creatPhotoOrCamaraView:indexPath];
    }
}

- (void)addImgPress:(NSIndexPath *)index{
    if ([self.delegate respondsToSelector:@selector(creatPhotoOrCamaraView:)]) {
        [self.delegate creatPhotoOrCamaraView:index];
    }
}

- (void)submitClicked:(UIButton *)Btn{
    self.alertTableView.scrollEnabled = NO;
    if ([self.delegate respondsToSelector:@selector(subMitData:andRankNum:)]) {
        [self.delegate subMitData:Btn andRankNum:self.numLabel.text];
    }
}

- (void)cancelClicked{
    if ([self.delegate respondsToSelector:@selector(cancel)]) {
        [self.delegate cancel];
    }
}

@end
