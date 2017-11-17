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

@interface InstallAndAcceptViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITableViewDelegate,UITableViewDataSource,RepairHeaderTableDelegate,RepairContentDelegate,UITextFieldDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *_imagePickerController;
}

@property (nonatomic, strong) UITableView * tableView; //表格展示视图
@property (nonatomic, strong) NSArray * contentArray; //表项标题
@property (nonatomic, strong) NSMutableArray * otherContentArray; //表项标题
@property (nonatomic, strong) NSMutableArray * dConfigData; //数据源
@property (nonatomic, strong) NSMutableArray * sePosionData; //已经选择版位数据源
@property (nonatomic, strong) NSMutableArray *subMitPosionArray; //上传版位信息数据源
@property (nonatomic, copy)   NSString *currHotelId;
@property (nonatomic, strong) RepairContentModel *headDataModel;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *maskingView;

@property (nonatomic, assign) TaskType taskType;
@property (nonatomic, assign) NSInteger segTag;
@property (nonatomic, copy) NSString *cuSTextFieldTagStr;

@end

@implementation InstallAndAcceptViewController

-(instancetype)initWithTaskType:(TaskType )taskType{
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

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initInfor{
    
    self.segTag = 3;
    self.subMitPosionArray = [[NSMutableArray alloc] init];
    self.otherContentArray = [[NSMutableArray alloc] init];
    self.sePosionData = [[NSMutableArray alloc] init];
    _dConfigData = [[NSMutableArray alloc] init];
    self.currHotelId = [[NSString alloc] init];
    self.cuSTextFieldTagStr = [[NSString alloc] init];
    self.headDataModel = [[RepairContentModel alloc] init];
    
    RepairContentModel * tmpModel = [[RepairContentModel alloc] init];
    tmpModel.imgHType = 0;
    [self.otherContentArray addObject:tmpModel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}

- (void)subMitDataRequest
{
    NSDictionary *dic;
    NSString *hotelId = self.currHotelId;
    if (isEmptyString(hotelId)) {
        hotelId = @"";
    }
    NSString *segTagStr = [NSString stringWithFormat:@"%ld",self.segTag];
    if (isEmptyString(segTagStr)) {
        segTagStr = @"";
    }
    NSString *taskTypeStr = [NSString stringWithFormat:@"%ld",self.taskType];
    if (isEmptyString(taskTypeStr)) {
        taskTypeStr = @"";
    }
    NSString *userIdStr = [UserManager manager].user.userid;
    if (isEmptyString(userIdStr)) {
        userIdStr = @"";
    }
    NSString *addrStr = self.headDataModel.addr;
    if (isEmptyString(addrStr)) {
        addrStr = @"";
    }
    NSString *contractStr = self.headDataModel.contractor;
    if (isEmptyString(contractStr)) {
        contractStr = @"";
    }
    NSString *mobileStr = self.headDataModel.mobile;
    if (isEmptyString(mobileStr)) {
        mobileStr = @"";
    }
    NSString *posionNumStr = self.headDataModel.posionNum;
    if (isEmptyString(posionNumStr)) {
        posionNumStr = @"";
    }
    
    if (self.taskType == TaskType_Install){
        dic = [NSDictionary dictionaryWithObjectsAndKeys:hotelId,@"hotel_id",segTagStr,@"task_emerge",taskTypeStr,@"task_type",userIdStr,@"publish_user_id",addrStr,@"addr",contractStr,@"contractor",mobileStr,@"mobile",posionNumStr,@"tv_nums",nil];
    }else{
       dic = [NSDictionary dictionaryWithObjectsAndKeys:hotelId,@"hotel_id",segTagStr,@"task_emerge",taskTypeStr,@"task_type",userIdStr,@"publish_user_id",[self.subMitPosionArray toReadableJSONString],@"repair_info",addrStr,@"addr",contractStr,@"contractor",mobileStr,@"mobile",posionNumStr,@"tv_nums",nil];
    }
    
    PubTaskRequest * request = [[PubTaskRequest alloc] initWithPubData:dic];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary *dadaDic = [NSDictionary dictionaryWithDictionary:response];
        if ([[dadaDic objectForKey:@"code"] integerValue] == 10000) {
            [MBProgressHUD showTextHUDWithText:[dadaDic objectForKey:@"msg"] inView:self.view];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [MBProgressHUD showTextHUDWithText:@"发布成功" inView:self.navigationController.view];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"发布失败" inView:self.navigationController.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [MBProgressHUD showTextHUDWithText:@"发布失败" inView:self.navigationController.view];
        
    }];
}

- (void)upLoadImageData{

    [self.subMitPosionArray removeAllObjects];
    NSMutableArray *upImageArr = [[NSMutableArray alloc] init];
    NSMutableArray *pathArr = [[NSMutableArray alloc] init];
    
    __block int upCount = 0;
    for (int i = 0; i < self.otherContentArray.count; i ++) {
        RepairContentModel *tmpModel = [self.otherContentArray objectAtIndex:i];
        if (!isEmptyString(tmpModel.boxId)) {
            tmpModel.upImgUrl = @"";
            if (tmpModel.pubImg != nil) {
                
                [upImageArr addObject:tmpModel.pubImg];
                [pathArr addObject:tmpModel.boxId];
                NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:tmpModel.boxId,@"box_id",tmpModel.title != nil ?tmpModel.title:@"",@"fault_desc",tmpModel.upImgUrl,@"fault_img_url", nil];
                [self.subMitPosionArray addObject:tmpDic];
            }else{
                [upImageArr addObject:@""];
                [pathArr addObject:@""];
                
                NSString *title;
                if (isEmptyString(tmpModel.title)) {
                    title = @"";
                }else{
                    title = tmpModel.title;
                }
                NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:tmpModel.boxId,@"box_id",tmpModel.title != nil ?tmpModel.title:@"",@"fault_desc",tmpModel.upImgUrl,@"fault_img_url", nil];
                [self.subMitPosionArray addObject:tmpDic];
            }
        }else{
            [MBProgressHUD showTextHUDWithText:@"数据不完整，请填写信息" inView:self.navigationController.view];
            return;
        }
    }
    
    [MBProgressHUD showLoadingHUDWithText:@"正在发布任务" inView:self.navigationController.view];
    if (upImageArr.count > 0) {
        [HotTopicTools uploadImageArray:upImageArr withBoxIDArray:pathArr progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        } success:^(NSString *path, NSInteger index) {
            NSMutableDictionary *tmpDic = self.subMitPosionArray[index];
            [tmpDic setObject:path forKey:@"fault_img_url"];
            NSLog(@"---上传成功！");
            
            upCount ++;
            if (upImageArr.count == upCount) {
                [self subMitDataRequest];
            }
        } failure:^(NSError *error, NSInteger index) {
            NSMutableDictionary *tmpDic = self.subMitPosionArray[index];
            [tmpDic setObject:@"" forKey:@"fault_img_url"];
            
            upCount ++;
            if (upImageArr.count == upCount) {
                [self subMitDataRequest];
            }
            
        }];
    }else{
        [self subMitDataRequest];
    }
    
}

- (void)creatSubViews{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    [button setTitle:@"发布" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [button addTarget:self action:@selector(pubBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = backItem;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)pubBtnClicked
{
    if (!isEmptyString(self.currHotelId)) {
        if (self.taskType == TaskType_Install) {
            [self subMitDataRequest];
        }else{
            [self upLoadImageData];
        }
    }else{
        if (isEmptyString(self.currHotelId)) {
            [MBProgressHUD showTextHUDWithText:@"请选择酒楼" inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取版位信息失败" inView:self.view];
        }
    }
}

- (void)addNPress{

    //先确保已经选择了酒楼
    if (isEmptyString(self.currHotelId)) {
        [MBProgressHUD showTextHUDWithText:@"请选择酒楼" inView:self.view];
        return;
    }
        
    NSIndexPath *numIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    RepairHeaderTableCell *cell = [self.tableView cellForRowAtIndexPath:numIndex];

    if (self.taskType == TaskType_Install) {
        
        RepairContentModel * tmpModel = [[RepairContentModel alloc] init];
        tmpModel.imgHType = 0;
        [self.otherContentArray addObject:tmpModel];
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",self.otherContentArray.count];
        
    }else if (self.taskType == TaskType_Repair){
        
        //确保数量不会大于酒楼版位总数
        if (self.otherContentArray.count + 1 > [self.headDataModel.tv_nums intValue]) {
            [MBProgressHUD showTextHUDWithText:@"不能大于该酒楼总版位数量" inView:self.view];
            return;
        }
        
        RepairContentModel * tmpModel = [[RepairContentModel alloc] init];
        tmpModel.imgHType = 0;
        [self.otherContentArray addObject:tmpModel];
        cell.numLabel.text = [NSString stringWithFormat:@"%ld",self.otherContentArray.count];
        
        [self.tableView beginUpdates];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.otherContentArray.count - 1 inSection:1];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    self.headDataModel.posionNum = cell.numLabel.text;
}

- (void)reduceNPress{
    
    if (self.taskType == TaskType_Install) {
        if (self.otherContentArray.count > 1) {
            [self.otherContentArray removeLastObject];
            NSIndexPath *numIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            RepairHeaderTableCell *cell = [self.tableView cellForRowAtIndexPath:numIndex];
            cell.numLabel.text = [NSString stringWithFormat:@"%ld",self.otherContentArray.count];
            self.headDataModel.posionNum = cell.numLabel.text;
        }
    }else if (self.taskType == TaskType_Repair){
        if (self.otherContentArray.count > 1) {
            [self.tableView beginUpdates];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.otherContentArray.count - 1  inSection:1];
            [self.tableView  deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.otherContentArray removeLastObject];
            [self.tableView endUpdates];
            
            NSIndexPath *numIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            RepairHeaderTableCell *cell = [self.tableView cellForRowAtIndexPath:numIndex];
            cell.numLabel.text = [NSString stringWithFormat:@"%ld",self.otherContentArray.count];
            self.headDataModel.posionNum = cell.numLabel.text;
            
            [self.sePosionData  removeAllObjects];
            for (int i = 0; i < self.otherContentArray.count; i ++ ) {
                RepairContentModel *tmpModel = [self.otherContentArray objectAtIndex:i];
                if (!isEmptyString(tmpModel.boxId)) {
                    [self.sePosionData addObject:tmpModel.boxId];
                }
            }
        }
    }
}

#pragma mark ---选择酒楼版位
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
        flVC.seDataArray = self.sePosionData;
        [self presentViewController:flVC animated:YES completion:nil];
        flVC.backDatas = ^(NSString *boxId,NSString *name) {
            
            [btn setTitle:name forState:UIControlStateNormal];
            
            RepairContentModel *tmpModel = [self.otherContentArray objectAtIndex:index.row];
            tmpModel.boxName = name;
            tmpModel.boxId = boxId;
            
            [self.sePosionData removeAllObjects];
            for (int i = 0; i < self.otherContentArray.count; i ++ ) {
                RepairContentModel *tmpModel = [self.otherContentArray objectAtIndex:i];
                if (!isEmptyString(tmpModel.boxId)) {
                    [self.sePosionData addObject:tmpModel.boxId];
                }
            }
        };
    }else{
        [MBProgressHUD showTextHUDWithText:@"请选择酒楼" inView:self.view];
    }
    
}

- (void)boxConfigRequest
{
    GetBoxListRequest * request = [[GetBoxListRequest alloc] initWithHotelId:self.currHotelId];
    [self.dConfigData removeAllObjects];
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
    if (self.taskType == TaskType_Install) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return self.otherContentArray.count;
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
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;  
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        [cell configWithContent:self.headDataModel andPNum:[NSString stringWithFormat:@"%ld",self.otherContentArray.count]  andIdexPath:indexPath];
        return cell;
    }else {
        
        static NSString *cellID = @"RestaurantRankCell";
        RepairContentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[RepairContentTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID andIdexPath:indexPath];
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.delegate = self;
        cell.inPutTextField.delegate = self;
        
        RepairContentModel *tmpModel = self.otherContentArray[indexPath.row];
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
            return 50 *3 + 10 + 84.5 *scale - 20;
        }
    }
    return 50 *6;
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

#pragma mark ---选择酒楼
- (void)hotelPress:(NSIndexPath *)index{
    
    SearchHotelViewController *shVC = [[SearchHotelViewController alloc] initWithClassType:1];
    [self.navigationController pushViewController:shVC animated:YES];
    shVC.backHotel = ^(RestaurantRankModel *model){
        
        self.currHotelId = model.cid;
        self.headDataModel.name = model.name != nil?model.name:@"";
        self.headDataModel.contractor = model.contractor != nil?model.contractor:@"";
        self.headDataModel.mobile = model.mobile != nil?model.mobile:@"";
        self.headDataModel.addr = model.addr != nil?model.addr:@"";
        self.headDataModel.tv_nums = model.tv_nums != nil?model.tv_nums:@"";
        self.headDataModel.posionNum = @"1";
        
        //选择酒楼后重新初始化版位信息
        [self.otherContentArray removeAllObjects];
        RepairContentModel * tmpModel = [[RepairContentModel alloc] init];
        tmpModel.imgHType = 0;
        [self.otherContentArray addObject:tmpModel];
        
        [_tableView reloadData];
        // 请求该酒店版位
         [self boxConfigRequest];
    };
}

- (void)addImgPress:(NSIndexPath *)index{
    
    self.indexPath = index;
    RepairContentModel *tmpModel = self.otherContentArray[index.row];
    if (!isEmptyString(tmpModel.boxName)) {
        [self creatPhotoSheet];
    }else{
        [MBProgressHUD showTextHUDWithText:@"请选择版位" inView:self.view];
    }
}

#pragma mark 弹出相册或是相机选择页面
- (void)creatPhotoSheet{
    
    UIActionSheet *photoSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册", @"拍照", nil];
    [photoSheet showInView:self.view];
}

// UIActionSheetDelegate实现代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) {
        return;
    }
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        _imagePickerController.allowsEditing = YES;
    }
    if (0 == buttonIndex)
    {
        [self selectImageFromAlbum];
    }
    else if (1 == buttonIndex)
    {
        [self selectImageFromCamera];
    }
}

#pragma mark 从摄像头获取图片或视频
- (void)selectImageFromCamera
{
    _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置摄像头模式拍照模式
    _imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    [_imagePickerController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
}

#pragma mark 从相册获取图片或视频
- (void)selectImageFromAlbum
{
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
        tmpModel.pubImg = info[UIImagePickerControllerEditedImage];
        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        //压缩图片
//        NSData *fileData = UIImageJPEGRepresentation(self.imageView.image, 1.0);

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    self.cuSTextFieldTagStr = [NSString stringWithFormat:@"%ld",textField.tag] ;
    RepairContentModel *tmpModel = self.otherContentArray[textField.tag];
    if (!isEmptyString(tmpModel.boxName)) {
        return YES;
    }else{
        [MBProgressHUD showTextHUDWithText:@"请选择版位" inView:self.view];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    RepairContentModel *tmpModel = self.otherContentArray[textField.tag];
    tmpModel.title = textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    RepairContentModel *tmpModel = self.otherContentArray[textField.tag];
    tmpModel.title = textField.text;
    
     return [textField resignFirstResponder];

}

//点击空白处的手势要实现的方法
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification{
    
    if (!isEmptyString(self.cuSTextFieldTagStr)) {
        
        CGFloat scale = kMainBoundsWidth / 375.f;
        // 底部Cell的总高度
        CGFloat cellTotalHeight = 0;
        for (int i = 0; i < [self.cuSTextFieldTagStr integerValue] + 1; i ++) {
            RepairContentModel *tmpModel = self.otherContentArray[i];
            CGFloat tmpHeight;
            if (tmpModel.imgHType == 0) {
                tmpHeight = 50 *3 + 10;
            }else{
                tmpHeight = 50 *3 + 10 + 84.5 *scale - 20;
            }
            cellTotalHeight = tmpHeight + cellTotalHeight;
        }
        
        CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat height = keyboardFrame.origin.y;
        CGFloat textField_maxY = cellTotalHeight + 50 *6;
        CGFloat space = - self.tableView.contentOffset.y + textField_maxY;
        CGFloat transformY = height - space;
        if (transformY < 0) {
            CGRect frame = self.view.frame;
            frame.origin.y = transformY ;
            self.view.frame = frame;
        }
    }else{
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    //恢复到默认y为0的状态，有时候要考虑导航栏要+64
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    self.view.frame = frame;
    self.cuSTextFieldTagStr = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
