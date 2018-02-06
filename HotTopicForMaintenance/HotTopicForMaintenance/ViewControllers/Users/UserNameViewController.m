//
//  UserNameViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/2/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "UserNameViewController.h"
#import "UserManager.h"
#import "HotTopicTools.h"

@interface UserNameViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * pArray;

@end

@implementation UserNameViewController

- (instancetype)initWithPubArray:(NSArray *)pArray
{
    if (self = [super init]) {
        self.pArray = pArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择酒楼人员";
    self.dataSource = [[NSMutableArray alloc] initWithArray:self.pArray];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(backButtonDidClicked)];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight) style:UITableViewStylePlain];
    self.tableView.backgroundColor = VCBackgroundColor;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCellCity"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublisherModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:NO completion:^{
    }];
    if (self.btnClick) {
        self.btnClick(model);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellCity" forIndexPath:indexPath];
    
    PublisherModel * model = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = model.remark;
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
}

@end
