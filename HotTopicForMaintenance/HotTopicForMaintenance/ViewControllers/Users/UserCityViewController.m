//
//  UserCityViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "UserCityViewController.h"
#import "UserManager.h"
#import "HotTopicTools.h"

@interface UserCityViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation UserCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择城市";
    self.dataSource = [[NSMutableArray alloc] initWithArray:[UserManager manager].user.cityArray];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonDidClicked)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight) style:UITableViewStylePlain];
//    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = VCBackgroundColor;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellCity"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UILabel * headerLabel = [HotTopicTools labelWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 40) TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(18) alignment:NSTextAlignmentLeft];
    headerLabel.text = [NSString stringWithFormat:@"  当前城市：%@", [UserManager manager].user.currentCity.region_name];
    self.tableView.tableHeaderView = headerLabel;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (![model.cid isEqualToString:[UserManager manager].user.currentCity.cid]) {
        [UserManager manager].user.currentCity = model;
        [[NSNotificationCenter defaultCenter] postNotificationName:RDUserCityDidChangeNotification object:nil];
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellCity" forIndexPath:indexPath];
    
    CityModel * model = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = model.region_name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)backButtonDidClicked
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
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
