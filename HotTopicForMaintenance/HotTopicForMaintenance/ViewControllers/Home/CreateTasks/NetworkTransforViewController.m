//
//  NetworkTransforViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "NetworkTransforViewController.h"
#import "NetworkTranTableViewCell.h"
#import "PubTaskRequest.h"
#import "SearchHotelViewController.h"
#import "UserManager.h"
#import "MBProgressHUD+Custom.h"
#import "NSArray+json.h"

@interface NetworkTransforViewController ()<UITableViewDelegate,UITableViewDataSource,NetworkTranDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSArray * contentArray; //表项标题
@property (nonatomic, strong) NSArray * titleArray; //表项标题
@property (nonatomic, copy)   NSString *currHotelId;
@property (nonatomic, assign) NSInteger segTag;
@property (nonatomic, assign) NSInteger taskType;
@property (nonatomic, strong) UITextView *remarkTextView;

@end

@implementation NetworkTransforViewController

-(instancetype)initWithTaskType:(NSInteger )taskType{
    if (self = [super init]) {
        self.taskType = taskType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInfor];
    [self creatSubViews];
    // Do any additional setup after loading the view.
}

- (void)initInfor{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    [button setTitle:@"发布" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [button addTarget:self action:@selector(pubBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = backItem;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    self.segTag = 3;
    
}

- (void)pubBtnClicked
{
    if (self.currHotelId != nil) {
        [self subMitDataRequest];
    }else{
        [MBProgressHUD showTextHUDWithText:@"请先选择酒楼" inView:self.view];
    }
    
}

-(void)creatSubViews{
    
    self.titleArray = [NSArray arrayWithObjects:@"选择酒楼",@"联系人",@"联系电话",@"地址",@"任务紧急程度", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 215)];
    footView.backgroundColor = UIColorFromRGB(0xffffff);
    _tableView.tableFooterView = footView;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xc8c7cc);
    [footView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 20 , 0.3));
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(0);
    }];
    
    UILabel *remarkTitle =[[UILabel alloc] init];
    remarkTitle.text = @"备注 （200字内，非必填）";
    remarkTitle.font = kPingFangRegular(14);
    remarkTitle.textAlignment = NSTextAlignmentLeft;
    remarkTitle.textColor = UIColorFromRGB(0x434343);
    [footView addSubview:remarkTitle];
    [remarkTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30 , 20));
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    self.remarkTextView = [[UITextView alloc] initWithFrame:CGRectZero];
    self.remarkTextView.textColor = UIColorFromRGB(0x999999);
    self.remarkTextView.font = kPingFangRegular(14);
    self.remarkTextView.text = @" 请输入备注信息，建议到店时间等";
    self.remarkTextView.backgroundColor = [UIColor clearColor];
    self.remarkTextView.textAlignment = NSTextAlignmentLeft;
    self.remarkTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.remarkTextView.layer.borderColor = UIColorFromRGB(0xc8c7cc).CGColor;
    self.remarkTextView.layer.borderWidth = .5f;
    self.remarkTextView.keyboardType = UIKeyboardTypeDefault;
    self.remarkTextView.returnKeyType = UIReturnKeyDone;
    self.remarkTextView.scrollEnabled = YES;
    self.remarkTextView.delegate = self;
    self.remarkTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.remarkTextView];
    [self.remarkTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(remarkTitle.mas_bottom).offset(15);
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(140);
    }];
    
}

- (void)subMitDataRequest
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在发布任务" inView:self.navigationController.view];
    
    NetworkTranTableViewCell *cellOne = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NetworkTranTableViewCell *cellTwo = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    NetworkTranTableViewCell *cellThree = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.currHotelId,@"hotel_id",[NSString stringWithFormat:@"%ld",self.segTag],@"task_emerge",[NSString stringWithFormat:@"%ld",self.taskType],@"task_type",[UserManager manager].user.userid,@"publish_user_id",cellThree.inPutTextField.text,@"addr",cellOne.inPutTextField.text,@"contractor",cellTwo.inPutTextField.text,@"mobile",self.remarkTextView.text,@"desc", nil];
    PubTaskRequest * request = [[PubTaskRequest alloc] initWithPubData:dic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dadaDic = [NSDictionary dictionaryWithDictionary:response];
        if ([[dadaDic objectForKey:@"code"] integerValue] == 10000) {
            [MBProgressHUD showTextHUDWithText:[dadaDic objectForKey:@"msg"] inView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"发布成功" inView:self.navigationController.view];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"发布失败" inView:self.navigationController.view];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"发布失败" inView:self.navigationController.view];
        
    }];
}

-(void)hotelPress:(NSIndexPath *)index{
    
    SearchHotelViewController *shVC = [[SearchHotelViewController alloc] initWithClassType:1];
    [self.navigationController pushViewController:shVC animated:YES];
    shVC.backHotel = ^(RestaurantRankModel *model){
        
        self.currHotelId = model.cid;
        self.contentArray = [NSArray arrayWithObjects:model.name != nil?model.name:@"",model.contractor != nil?model.contractor:@"",model.mobile != nil?model.mobile:@"",model.addr != nil?model.addr:@"",@"紧急程度", nil];
        [_tableView beginUpdates];
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];
        
    };
}

- (void)Segmented:(NSInteger)segTag{
    self.segTag = segTag;
}

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
    cell.delegate = self;
    [cell configWithTitle:self.titleArray[indexPath.row] andContent:self.contentArray[indexPath.row] andIdexPath:indexPath];
    
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
    
    return 10;
}

#pragma mark - textView代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    //    self.currentTextView = textView;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@" 请输入备注信息，建议到店时间等"]) {
        self.remarkTextView.textColor = [UIColor grayColor];
        textView.text = @"";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else if (range.location < 100){
        return  YES;
    } else if (textView.text.length == 100) {
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@",textView.text);
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        self.remarkTextView.text = @" 请输入备注信息，建议到店时间等";
        self.remarkTextView.textColor = UIColorFromRGB(0x999999);
    }
    [textView resignFirstResponder];
    
}

//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
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
