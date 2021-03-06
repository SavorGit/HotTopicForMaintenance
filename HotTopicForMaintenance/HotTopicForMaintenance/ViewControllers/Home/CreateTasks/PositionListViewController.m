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

@interface PositionListViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) UIView *bgView;

@end

@implementation PositionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubViews];
    
    // Do any additional setup after loading the view.
}

- (void)creatSubViews{
    
    self.view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
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
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.bgView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
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
    cell.leftImage.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = indexPath.row;
    
    [cell configWithModel:model];
    
    UITapGestureRecognizer * tapCell = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell:)];
    tapCell.numberOfTapsRequired = 1;
    tapCell.delegate = self;
    [cell addGestureRecognizer:tapCell];
    
    return cell;
    
}

- (void)tapCell:(UIGestureRecognizer *)gesture{
    
    PosionListTableViewCell *cell = (PosionListTableViewCell *)gesture.view;
    cell.leftImage.hidden = NO;
    RestaurantRankModel * model = [self.dataSource objectAtIndex:gesture.view.tag];
    if ([self.seDataArray containsObject:model.box_id]) {
        [MBProgressHUD showTextHUDWithText:@"请不要选择重复版位" inView:self.view];
    }else{
        if (_backDatas) {
            _backDatas(model.box_id,model.box_name);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
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
