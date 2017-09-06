//
//  FaultListViewController.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "FaultListViewController.h"
#import "RestaurantRankModel.h"
#import "FaultListTableViewCell.h"
//#import "Masonry.h"

@interface FaultListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * dataSource; //数据源
@property (nonatomic, strong) UIView *bgView;

@end

@implementation FaultListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self initInfo];
    [self creatSubViews];
    [self initData];
    
}

- (void)initData{
    
    for (int i = 0; i < 10; i ++) {
        RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] init];
        tmpModel.string1 = @"V1";
        tmpModel.string2 = @"B9876545678";
        tmpModel.string3 = @"V1机顶盒";
        tmpModel.string4 = @"3分钟前";
        tmpModel.string5 = @"2017-08-28 08：08";
        tmpModel.string6 = @"08-28 17：39（郑伟）";
        tmpModel.stateType = 0;
        tmpModel.selectType = NO;
        
        [self.dataSource addObject:tmpModel];
    }
    [self.tableView reloadData];
}

- (void)initInfo{
    
    self.view.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0];
    _dataSource = [[NSMutableArray alloc] initWithCapacity:100];
    
    
}

- (void)creatSubViews{
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 60,kMainBoundsHeight - 180));
        make.center.mas_equalTo(self.view);
    }];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelBtn.layer.borderWidth = .5f;
    cancelBtn.layer.cornerRadius = 2.f;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn addTarget:self action:@selector(quitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(10);
        make.centerX.equalTo(self.bgView.mas_centerX).offset(- 55);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
    
    UIButton * saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.backgroundColor = [UIColor whiteColor];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    saveBtn.layer.borderColor = UIColorFromRGB(0xe0dad2).CGColor;
    [saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    saveBtn.layer.borderWidth = .5f;
    saveBtn.layer.cornerRadius = 2.f;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(saveClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(10);
        make.centerX.equalTo(self.bgView.mas_centerX).offset(55);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
}

- (void)quitClicked{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveClicked{
    
    if (_backDatas) {
        _backDatas(@"机顶盒故障");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
        _tableView.showsVerticalScrollIndicator = NO;
        [self.bgView addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 60,kMainBoundsHeight - 240));
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(0);
        }];
    }
    
    return _tableView;
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
    FaultListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[FaultListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
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
    model.selectType = !model.selectType;
    FaultListTableViewCell *tmpCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (model.selectType == YES) {
        tmpCell.selectImgView.hidden = NO;
    }else{
        tmpCell.selectImgView.hidden = YES;
    }
    
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