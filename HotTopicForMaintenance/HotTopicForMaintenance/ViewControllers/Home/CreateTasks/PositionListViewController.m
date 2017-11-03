//
//  PositionListViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "PositionListViewController.h"
#import "RestaurantRankModel.h"
#import "PosionListTableViewCell.h"

@interface PositionListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) UIView *bgView;

@end

@implementation PositionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfo];
    [self creatSubViews];
    
    // Do any additional setup after loading the view.
}

- (void)initInfo{
    
    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
}

- (void)creatSubViews{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.borderColor = UIColorFromRGB(0xf6f2ed).CGColor;
    self.bgView.layer.borderWidth = .5f;
    self.bgView.layer.cornerRadius = 6.f;
    self.bgView.layer.masksToBounds = YES;
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 60,kMainBoundsHeight - 180));
        make.center.mas_equalTo(self.view);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.bgView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 60,kMainBoundsHeight - 215));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(0);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RestaurantRankModel * model = [self.dataSource objectAtIndex:indexPath.row];
    static NSString *cellID = @"RestaurantRankCell";
    PosionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[PosionListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (model.selectType == YES) {
        cell.selectImgView.hidden = NO;
    }else{
        cell.selectImgView.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell configWithModel:model];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RestaurantRankModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (_backDatas) {
        _backDatas(model.cid,model.box_name);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
