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
#import "RestaurantRankModel.h"
#import "RepairContentModel.h"
#import "SearchHotelViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InstallAndAcceptViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,RepairHeaderTableDelegate,RepairContentDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSMutableArray * titleArray; //表项标题
@property (nonatomic, strong) NSArray * otherTitleArray; //表项标题
@property (nonatomic, assign) NSInteger sectionNum; //组数
@property (nonatomic, strong) NSMutableArray * dConfigData; //数据源

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *maskingView;

@end

@implementation InstallAndAcceptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sectionNum = 1;
    [self demageConfigRequest];
    [self creatSubViews];
    
    [self initInfor];
    // Do any additional setup after loading the view.
}

- (void)initInfor{
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePickerController.allowsEditing = YES;
    
}
- (void)creatSubViews{
    
    _dConfigData = [[NSMutableArray alloc] init];
    self.titleArray = [[NSMutableArray alloc] init];
    self.title = @"安装与验收";
    
     NSArray *dataArr = [NSArray arrayWithObjects:@"选择酒楼",@"联系人",@"联系电话",@"地址",@"任务紧急程度",@"版位数量",  nil];
   
    for (int i = 0; i < 6; i ++) {
        RepairContentModel * tmpModel = [[RepairContentModel alloc] init];
        tmpModel.title = dataArr[i];
        tmpModel.imgHType = 0;
        
        [self.titleArray addObject:tmpModel];
    }
   
    self.otherTitleArray = [NSArray arrayWithObjects:@"版位名称",@"故障现象",@"故障照片", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.backgroundView = nil;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth,kMainBoundsHeight - 64));
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
    }];
    
    //    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 50 *8)];
    //    headerView.backgroundColor = UIColorFromRGB(0xf8f6f1);
    //    _tableView.tableHeaderView = headerView;
    
}

- (void)addNPress{
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
    }
    
}

- (void)selectPosion:(UIButton *)btn{
    
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
    flVC.backDatas = ^(NSString *damageIdString) {
        [btn setTitle:damageIdString forState:UIControlStateNormal];
    };
}

- (void)demageConfigRequest
{
    DamageConfigRequest * request = [[DamageConfigRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * dataDict = [response objectForKey:@"result"];
        NSArray *listArray = [dataDict objectForKey:@"list"];
        
        for (int i = 0; i < listArray.count; i ++) {
            RestaurantRankModel *tmpModel = [[RestaurantRankModel alloc] initWithDictionary:listArray[i]];
            [self.dConfigData addObject:tmpModel];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.titleArray.count;
    }else if (section == 1){
        return self.sectionNum;
    }else{
        return self.otherTitleArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RepairContentModel *tmpModel = self.titleArray[indexPath.row];
    if (indexPath.section == 0) {
        static NSString *cellID = @"RepairHeaderCell";
        //        RepairTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        RepairHeaderTableCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[RepairHeaderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        [cell configWithTitle:tmpModel.title andContent:@"俏江南" andIdexPath:indexPath];
        return cell;
    }else {
        
        static NSString *cellID = @"RestaurantRankCell";
        RepairContentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[RepairContentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        [cell configWithContent:tmpModel  andIdexPath:indexPath];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CGFloat scale = kMainBoundsWidth / 375.f;
        RepairContentModel *tmpModel = self.titleArray[indexPath.row];
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
    
    return 5;
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
    shVC.backHotel = ^(NSString *hotelName, NSString *hotelId){
        
        RepairHeaderTableCell *cell = [_tableView cellForRowAtIndexPath:index];
        if (!isEmptyString(hotelName)) {
            [cell.hotelBtn setTitle:hotelName forState:UIControlStateNormal];
        }
    };
}

- (void)addImgPress:(NSIndexPath *)index{
    
    self.indexPath = index;
    
    NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
    if(authStatus == AVAuthorizationStatusRestricted){
        NSLog(@"设置-常用-访问限制里面不让使用相机");
    }else if (authStatus == AVAuthorizationStatusDenied){
        NSLog(@"设置-隐私里面不让使用相机");
    }else if (authStatus == AVAuthorizationStatusAuthorized){
        NSLog(@"正常使用相机");
        [self creatMaskingView];
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        NSLog(@"在模拟器上会出现这种情况，应该是不支持的问题");
    }
}

- (void)creatMaskingView{
    
    self.maskingView = [[UIView alloc] init];
    self.maskingView.tag = 1888;
    self.maskingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.maskingView.userInteractionEnabled = YES;
    self.maskingView.frame = CGRectMake(0, 0, kMainBoundsWidth, kMainBoundsHeight);
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
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
    
    RepairContentModel *tmpModel = self.titleArray[self.indexPath.row];
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
        RepairContentModel *tmpModel = self.titleArray[self.indexPath.row];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
