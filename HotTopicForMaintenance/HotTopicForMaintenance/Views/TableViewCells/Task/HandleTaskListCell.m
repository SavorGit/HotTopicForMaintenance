//
//  HandleTaskListCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "HandleTaskListCell.h"
#import "HotTopicTools.h"
#import "AssignRequest.h"
#import "UserManager.h"
#import "RDAlertView.h"
#import "MBProgressHUD+Custom.h"

@interface HandleTaskListCell ()

@property (nonatomic, strong) UIView * baseView;

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * dateLabel;

@property (nonatomic, strong) UIView * listView;

@property (nonatomic, copy) NSString * taskID;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, strong) NSDictionary * info;
@property (nonatomic, assign) NSInteger installTeam;

@end

@implementation HandleTaskListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self createHandleTaskListCell];
    }
    return self;
}

- (void)createHandleTaskListCell
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = VCBackgroundColor;
    self.contentView.backgroundColor = VCBackgroundColor;
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectZero];
    self.baseView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.contentView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(15.f * scale);
        make.bottom.mas_equalTo(-10.f);
        make.right.mas_equalTo(-15.f);
    }];
    self.baseView.layer.cornerRadius = 10.f;
    self.baseView.layer.masksToBounds = YES;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.baseView addSubview:imageView];
    [imageView setImage:[UIImage imageNamed:@"userIcon"]];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(10.f * scale);
        make.width.height.mas_equalTo(20.f * scale);
    }];
    
    self.nameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15.f * scale) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"";
    [self.baseView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10.f * scale);
        make.left.mas_equalTo(imageView.mas_right).offset(5);
        make.height.mas_equalTo(20.f * scale);
    }];
    
    self.dateLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangMedium(15.f * scale) alignment:NSTextAlignmentLeft];
    self.dateLabel.text = @"";
    [self.baseView addSubview:self.dateLabel];
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(5.f * scale);
        make.left.mas_equalTo(10.f * scale);
        make.height.mas_equalTo(15.f * scale);
    }];
    
    UIButton * assignButton = [HotTopicTools buttonWithTitleColor:UIColorFromRGB(0xffffff) font:kPingFangRegular(16.f * scale) backgroundColor:kNavBackGround title:@"指派" cornerRadius:5.f];
    [self.baseView addSubview:assignButton];
    [assignButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5.f * scale);
        make.right.mas_equalTo(-15.f * scale);
        make.width.mas_equalTo(60.f * scale);
        make.height.mas_equalTo(30.f * scale);
    }];
    [assignButton addTarget:self action:@selector(assginButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.listView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.baseView addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateLabel.mas_bottom).offset(10.f * scale);
        make.left.mas_equalTo(15.f * scale);
        make.right.mas_equalTo(-15.f * scale);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)assginButtonDidClicked
{
    NSString * handleID = [self.info objectForKey:@"user_id"];
    NSString * handleName = [self.info objectForKey:@"username"];
    NSString * alertStr = [NSString stringWithFormat:@"是否指派该任务给 %@", handleName];
    RDAlertAction * action1 = [[RDAlertAction alloc] initWithTitle:@"取消" handler:^{
        
    } bold:NO];
    RDAlertAction * action2 = [[RDAlertAction alloc] initWithTitle:@"确定" handler:^{
        
        AssignRequest * request = [[AssignRequest alloc] initWithDate:self.date assginID:[UserManager manager].user.userid handleID:handleID taskID:self.taskID isInstallTeam:self.installTeam];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RDTaskStatusDidChangeNotification object:nil];
            [MBProgressHUD showTextHUDWithText:@"指派成功" inView:[UIApplication sharedApplication].keyWindow];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            if ([response objectForKey:@"msg"]) {
                [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow];
            }else{
                [MBProgressHUD showTextHUDWithText:@"指派失败" inView:[UIApplication sharedApplication].keyWindow];
            }
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
            [MBProgressHUD showTextHUDWithText:@"指派失败" inView:[UIApplication sharedApplication].keyWindow];
            
        }];
        
    } bold:YES];
    
    RDAlertView * alert = [[RDAlertView alloc] initWithTitle:@"提示" message:alertStr];
    [alert addActions:@[action1, action2]];
    [alert show];
}

- (void)configWithInfo:(NSDictionary *)info date:(NSString *)date taskID:(NSString *)taskID isInstallTeam:(NSInteger)installTeam
{
    self.installTeam = installTeam;
    self.info = info;
    [self.listView removeAllSubviews];
    
    self.taskID = taskID;
    self.date = date;
    self.nameLabel.text = GetNoNullString([info objectForKey:@"username"]);
    self.dateLabel.text = [NSString stringWithFormat:@"%@的任务:", date];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    NSArray * list = [info objectForKey:@"task_info"];
    CGFloat lineHeight = 25.f * scale;
    if ([list isKindOfClass:[NSArray class]] && list.count > 0) {
        for (NSInteger i = 0; i < list.count; i++) {
            NSDictionary * dict = [list objectAtIndex:i];
            NSString * taskName = [dict objectForKey:@"task_type_desc"];
            NSString * hotelName = [dict objectForKey:@"hotel_name"];
            
            UILabel * label = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x333333) font:kPingFangRegular(14.f * scale) alignment:NSTextAlignmentLeft];
            label.text = [NSString stringWithFormat:@"%@  %@", taskName, hotelName];
            [self.listView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.mas_equalTo(lineHeight * i);
                make.height.mas_equalTo(lineHeight);
            }];
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
