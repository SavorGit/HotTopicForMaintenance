//
//  InstallAndAcceptViewController.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/10/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "InstallAndAcceptViewController.h"
#import "RepairHeaderTableCell.h"
#import "RepairContentTableCell.h"
#import "PositionListViewController.h"
#import "DamageConfigRequest.h"
#import "GetBoxListRequest.h"
#import "RestaurantRankModel.h"
#import "RepairContentModel.h"
#import "SearchHotelViewController.h"
#import "PubTaskRequest.h"
#import "UserManager.h"
#import "MBProgressHUD+Custom.h"
#import "NSArray+json.h"
#import "HotTopicTools.h"
#import "Helper.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface InstallAndAcceptViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,RepairHeaderTableDelegate,RepairContentDelegate,UITextFieldDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSArray *dataArr; //表项标题
@property (nonatomic, strong) NSArray * contentArray; //表项标题
@property (nonatomic, strong) NSMutableArray * otherContentArray; //表项标题
@property (nonatomic, assign) NSInteger sectionNum; //组数
@property (nonatomic, strong) NSMutableArray * dConfigData; //数据源
@property (nonatomic, strong) NSMutableArray *subMitPosionArray; //上传版位信息数据源
@property (nonatomic, copy) NSString *currHotelId;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *maskingView;

@property (nonatomic, assign) NSInteger taskType;
@property (nonatomic, assign) NSInteger segTag;

@end

@implementation InstallAndAcceptViewController

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
}

- (void)pubBtnClicked
{
    [self subMitDataRequest];
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
    
    self.segTag = 3;
    self.sectionNum = 1;
    self.subMitPosionArray = [[NSMutableArray alloc] init];
    self.otherContentArray = [[NSMutableArray alloc] init];
    
}

- (void)subMitDataRequest
{
    [self upLoadImageData];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.currHotelId,@"hotel_id",[NSString stringWithFormat:@"%ld",self.segTag],@"task_emerge",[NSString stringWithFormat:@"%ld",self.taskType],@"task_type",[UserManager manager].user.userid,@"publish_user_id",[self.subMitPosionArray toReadableJSONString],@"repair_info",@"永峰写字楼",@"addr",@"独孤求败",@"contractor",@"18500000000",@"mobile", nil];
    
    PubTaskRequest * request = [[PubTaskRequest alloc] initWithPubData:dic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dadaDic = [NSDictionary dictionaryWithDictionary:response];
        if ([[dadaDic objectForKey:@"code"] integerValue] == 10000) {
            [MBProgressHUD showTextHUDWithText:[dadaDic objectForKey:@"msg"] inView:self.view];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)upLoadImageData{
    
    NSMutableArray *upImageArr = [[NSMutableArray alloc] init];
    NSMutableArray *pathArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.sectionNum; i ++) {
        RepairContentTableCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:1]];
        RepairContentModel *tmpModel = [self.otherContentArray objectAtIndex:i];
        
        tmpModel.upImgUrl = [NSString stringWithFormat:@"http://devp.oss.littlehotspot.com/log/mobile/ios/MaintenanceImage/%@/upImg%i",[Helper getCurrentTimeWithFormat:@"yyyyMMdd"],i];
        if (cell.fImageView.image != nil) {
            [upImageArr addObject:cell.fImageView.image];
        }else{
            [upImageArr addObject:[UIImage imageNamed:@"selected"]];
        }
        [pathArr addObject:[NSString stringWithFormat:@"upImg%i",i]];
        
        NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:tmpModel.boxId,@"box_id",cell.inPutTextField.text,@"fault_desc",tmpModel.upImgUrl,@"fault_img_url", nil];
        [self.subMitPosionArray addObject:tmpDic];
    }
    
    [HotTopicTools uploadImageArray:upImageArr withPath:pathArr progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } success:^(NSString *path) {
        NSLog(@"---上传成功！");
    } failure:^{
        
    }];
}

- (void)creatSubViews{
    
    _dConfigData = [[NSMutableArray alloc] init];
    self.currHotelId = [[NSString alloc] init];
    self.title = @"安装与验收";
    if (self.taskType == 7) {
        self.title = @"维修";
    }
    
    self.dataArr = [NSArray arrayWithObjects:@"选择酒楼",@"联系人",@"联系电话",@"地址",@"任务紧急程度",@"版位数量",nil];
    RepairContentModel * tmpModel = [[RepairContentModel alloc] init];
    tmpModel.imgHType = 0;
    [self.otherContentArray addObject:tmpModel];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

- (void)addNPress{
    
    RepairContentModel * tmpModel = [[RepairContentModel alloc] init];
    tmpModel.imgHType = 0;
    [self.otherContentArray addObject:tmpModel];
    
    [self.tableView beginUpdates];
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.sectionNum inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    self.sectionNum = self.sectionNum + 1;
    [self.tableView endUpdates];
    
}

- (void)reduceNPress{
    
    if (self.sectionNum > 1) {
        [self.tableView beginUpdates];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.sectionNum - 1 inSection:1];
        [self.tableView  deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        self.sectionNum = self.sectionNum - 1;
        [self.tableView endUpdates];
        
        [self.otherContentArray removeLastObject];
    }
    
}

- (void)selectPosion:(UIButton *)btn andIndex:(NSIndexPath *)index{
    
    if (self.dConfigData.count > 0) {
        PositionListViewController *flVC = [[PositionListViewController alloc] init];
        float version = [UIDevice currentDevice].systemVersion.floatValue;
        if (version < 8.0) {
            self.modalPresentationStyle = UIModalPresentationCurrentContext;
        } else {;
            flVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        flVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        flVC.dataSource = self.dConfigData;
        [self presentViewController:flVC animated:YES completion:nil];
        flVC.backDatas = ^(NSString *boxId,NSString *name) {
            [btn setTitle:name forState:UIControlStateNormal];
            RepairContentModel *cell = [self.otherContentArray objectAtIndex:index.row];
            cell.boxId = boxId;
            
        };
    }else{
        [MBProgressHUD showTextHUDWithText:@"请选择酒楼" inView:self.view];
    }
    
}

- (void)boxConfigRequest
{
    GetBoxListRequest * request = [[GetBoxListRequest alloc] initWithHotelId:self.currHotelId];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSArray *listArray = [response objectForKey:@"result"];
        
        for (int i = 0; i < listArray.count; i ++) {
            RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] initWithDictionary:listArray[i]];
            [self.dConfigData addObject:tmpModel];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
    }];
}

- (void)Segmented:(NSInteger)segTag{
    self.segTag = segTag;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArr.count;
    }else if (section == 1){
        return self.sectionNum;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"RepairHeaderCell";
        RepairHeaderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[RepairHeaderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        [cell configWithTitle:self.dataArr[indexPath.row] andContent:self.contentArray[indexPath.row] andPNum:[NSString stringWithFormat:@"%ld",self.sectionNum]  andIdexPath:indexPath];
        return cell;
    }else {
        RepairContentModel *tmpModel = self.otherContentArray[indexPath.row];
        static NSString *cellID = @"RestaurantRankCell";
        RepairContentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[RepairContentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID andIdexPath:indexPath];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        cell.inPutTextField.delegate = self;
        [cell configWithContent:tmpModel  andIdexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CGFloat scale = kMainBoundsWidth / 375.f;
        RepairContentModel *tmpModel = self.otherContentArray[indexPath.row];
        if (tmpModel.imgHType == 0) {
            return 50 *3 + 10;
        }else{
            return 50 *3 + 10 + 84.5 *scale;
        }
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    view.backgroundColor = [UIColor clearColor];
    return view ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)hotelPress:(NSIndexPath *)index{
    
    SearchHotelViewController *shVC = [[SearchHotelViewController alloc] initWithClassType:1];
    [self.navigationController pushViewController:shVC animated:YES];
    shVC.backHotel = ^(RestaurantRankModel *model){
        
        self.currHotelId = model.cid;
        self.contentArray = [NSArray arrayWithObjects:model.name != nil?model.name:@"",model.contractor != nil?model.contractor:@"",model.mobile != nil?model.mobile:@"",model.addr != nil?model.addr:@"",@"紧急程度",@"版位数量", nil];
        [_tableView beginUpdates];
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
        [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];
        
        // 请求该酒店版位
         [self boxConfigRequest];
    };
}

- (void)addImgPress:(NSIndexPath *)index{
    
    self.indexPath = index;
    
    [self creatMaskingView];
}

- (void)creatMaskingView{
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if ([keyWindow viewWithTag:1888] != nil ) {
        return;
    }
    
    self.maskingView = [[UIView alloc] init];
    self.maskingView.tag = 1888;
    self.maskingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.maskingView.userInteractionEnabled = YES;
    self.maskingView.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
    self.maskingView.top = keyWindow.bottom;
    [keyWindow addSubview:self.maskingView];
    
    [self showViewWithAnimationDuration:.3f];
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.maskingView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 80));
        make.bottom.mas_equalTo(self.maskingView.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cameraBtn setTitle:@"相机" forState:UIControlStateNormal];
    [cameraBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(selectImageFromCamera) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:cameraBtn];
    [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 50));
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.centerX.mas_equalTo(bgView.centerX).offset(- 80);
    }];
    
    UIButton *imgAlbumBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [imgAlbumBtn setTitle:@"相册" forState:UIControlStateNormal];
    [imgAlbumBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [imgAlbumBtn addTarget:self action:@selector(selectImageFromAlbum) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:imgAlbumBtn];
    [imgAlbumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 50));
        make.centerY.mas_equalTo(bgView.mas_centerY);
        make.centerX.mas_equalTo(bgView.mas_centerX).offset(80);
    }];
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
}

#pragma mark - show view
-(void)showViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.maskingView.top = keyWindow.top;
    } completion:^(BOOL finished) {
    }];
}

-(void)dismissViewWithAnimationDuration:(float)duration{
    
    [UIView animateWithDuration:duration animations:^{
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        self.maskingView.top = keyWindow.bottom;
        
    } completion:^(BOOL finished) {
        [self.maskingView removeFromSuperview];
    }];
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    [self dismissViewWithAnimationDuration:0.1];
    
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置摄像头模式拍照模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [_imagePickerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
    [self dismissViewWithAnimationDuration:0.1];
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [_imagePickerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//该代理方法仅适用于只选取图片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
    
    RepairContentModel *tmpModel = self.otherContentArray[self.indexPath.row];
    tmpModel.imgHType = 1;
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    RepairContentTableCell *cell = [_tableView cellForRowAtIndexPath:self.indexPath];
    cell.fImageView.image = image;
}

//适用获取所有媒体资源，只需判断资源类型
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSString *mediaType=[info objectForKey:UIImagePickerControllerMediaType];
    //判断资源类型
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        RepairContentModel *tmpModel = self.otherContentArray[self.indexPath.row];
        tmpModel.imgHType = 1;
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        RepairContentTableCell *cell = [_tableView cellForRowAtIndexPath:self.indexPath];
        cell.fImageView.image = info[UIImagePickerControllerEditedImage];
        
        //压缩图片
//        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);
        //上传图片
//        [self uploadImageWithData:fileData];

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [_tableView setContentOffset:CGPointMake(0,(271/2 + 271/2 *textField.tag)) animated:YES];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSLog(@"%@",textField.text);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
    return [textField resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
