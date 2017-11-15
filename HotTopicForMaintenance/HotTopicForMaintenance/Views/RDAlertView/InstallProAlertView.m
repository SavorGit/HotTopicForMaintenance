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

@interface InstallProAlertView ()<UITableViewDelegate, UITableViewDataSource,InstallCellDelegate>

@property (nonatomic, strong) NSArray    *titleArray;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) UIImageView *sheetBgView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, strong) NSArray *dataArray;

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
    float bgVideoHeight = [Helper autoHeightWith:kMainBoundsHeight - 64 - 100];
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
    [_alertTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(bgVideoWidth,bgVideoHeight - 60));
        make.centerX.mas_equalTo(self.sheetBgView);
        make.top.mas_equalTo(10);
    }];
    
    self.submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.submitBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [self.submitBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.submitBtn.layer.borderWidth = .5f;
    self.submitBtn.layer.cornerRadius = 2.f;
    self.submitBtn.layer.masksToBounds = YES;
    [self.submitBtn addTarget:self action:@selector(submitClicked) forControlEvents:UIControlEventTouchUpInside];
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
            if (indexPath.row < self.dataArray.count) {
                RestaurantRankModel *tmpModel = self.dataArray[indexPath.row];
                [cell configWithContent:@"安装流程单" andIdexPath:indexPath andDataModel:tmpModel];
            }else{
                [cell configWithContent:@"安装流程单" andIdexPath:indexPath andDataModel:nil];
            }
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

- (void)submitClicked{
    if ([self.delegate respondsToSelector:@selector(subMitData)]) {
         [self.delegate subMitData];
    }
}

- (void)cancelClicked{
    if ([self.delegate respondsToSelector:@selector(cancel)]) {
        [self.delegate cancel];
    }
}

@end
