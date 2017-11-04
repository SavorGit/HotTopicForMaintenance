//
//  inforDetectionViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "inforDetectionViewController.h"
#import "NetworkTranTableViewCell.h"

@interface inforDetectionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSArray * titleArray; //表项标题
@end

@implementation inforDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatSubViews];
    // Do any additional setup after loading the view.
}

- (void)creatSubViews{
    
    self.title = @"网络改造";
    self.titleArray = [NSArray arrayWithObjects:@"选择酒楼",@"联系人",@"联系电话",@"地址",@"任务紧急程度", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
    }];
    
}

//- (void)subMitDataRequest
//{
//    NSDictionary *repairInforDicOne = [NSDictionary dictionaryWithObjectsAndKeys:@"123456",@"box_id",@"这这是测试",@"fault_desc",@"http://pic.",@"fault_img_url", nil];
//    NSDictionary *repairInforDic = [NSDictionary dictionaryWithObjectsAndKeys:@"123456",@"box_id",@"电源坏掉了",@"fault_desc",@"http://pic.",@"fault_img_url", nil];
//    NSArray *repairArray = [NSArray arrayWithObjects:repairInforDic,repairInforDicOne, nil];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.currHotelId,@"hotel_id",[NSString stringWithFormat:@"%ld",self.segTag],@"task_emerge",@"7",@"task_type",[UserManager manager].user.userid,@"publish_user_id",[repairArray toReadableJSONString],@"repair_info",@"永峰写字楼",@"addr",@"独孤求败",@"contractor",@"18500000000",@"mobile", nil];
//    PubTaskRequest * request = [[PubTaskRequest alloc] initWithPubData:dic];
//    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
//        
//        NSDictionary *dadaDic = [NSDictionary dictionaryWithDictionary:response];
//        if ([[dadaDic objectForKey:@"code"] integerValue] == 10000) {
//            [MBProgressHUD showTextHUDWithText:[dadaDic objectForKey:@"msg"] inView:self.view];
//        }
//        
//    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
//        
//    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
//        
//    }];
//}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.titleArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"RestaurantRankCell";
    NetworkTranTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NetworkTranTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.backgroundColor = UIColorFromRGB(0xf6f2ed);
    [cell configWithTitle:self.titleArray[indexPath.row] andContent:@"俏江南" andIdexPath:indexPath];
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 5;
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
