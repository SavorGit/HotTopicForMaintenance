//
//  BindPositionTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BindPositionTableViewCell.h"
#import "HotTopicTools.h"
#import "BindBoxRequest.h"
#import "DeviceManager.h"
#import "MBProgressHUD+Custom.h"

@interface BindPositionTableViewCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *tvNameLabel;
@property (nonatomic, strong) UILabel *roomNameLabel;
@property (nonatomic, strong) UILabel *boxNameLabel;
@property (nonatomic, strong) UILabel *macAddressLabel;

@property (nonatomic, strong) UIButton *bindBtn;

@property (nonatomic, strong) BindDeviceModel * model;

@property (nonatomic, copy) NSString * macAddress;

@end

@implementation BindPositionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.contentView.backgroundColor = VCBackgroundColor;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = UIColorFromRGB(0xffffff);
    _bgView.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    _bgView.layer.borderWidth = .5f;
    _bgView.layer.cornerRadius = 5.f;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 20 * scale);
        make.top.mas_equalTo(5 * scale);
        make.left.mas_equalTo(10 * scale);
        make.bottom.mas_equalTo(0);
    }];
    
    self.tvNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(14.f * scale) alignment:NSTextAlignmentLeft];
    self.tvNameLabel.text = @"电视名称：";
    [_bgView addSubview:self.tvNameLabel];
    [self.tvNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-85 * scale);
        make.top.mas_equalTo(5 * scale);
        make.left.mas_equalTo(20 * scale);
    }];
    
    self.roomNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(14.f * scale) alignment:NSTextAlignmentLeft];
    self.roomNameLabel.text = @"包间名称：";
    [_bgView addSubview:self.roomNameLabel];
    [self.roomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-85 * scale);
        make.top.mas_equalTo(self.tvNameLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(20 * scale);
    }];
    
    self.boxNameLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(14.f * scale) alignment:NSTextAlignmentLeft];
    self.boxNameLabel.text = @"机顶盒名称：";
    [_bgView addSubview:self.boxNameLabel];
    [self.boxNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-85 * scale);
        make.top.mas_equalTo(self.roomNameLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(20 * scale);
    }];
    
    self.macAddressLabel = [HotTopicTools labelWithFrame:CGRectZero TextColor:UIColorFromRGB(0x434343) font:kPingFangMedium(14.f * scale) alignment:NSTextAlignmentLeft];
    self.macAddressLabel.text = @"MAC地址：";
    [_bgView addSubview:self.macAddressLabel];
    [self.macAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(-85 * scale);
        make.top.mas_equalTo(self.boxNameLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(20 * scale);
    }];
    
    self.bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bindBtn setBackgroundColor:[UIColor blueColor]];
    self.bindBtn.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    self.bindBtn.layer.borderWidth = .5f;
    self.bindBtn.layer.cornerRadius = 5.f;
    self.bindBtn.layer.masksToBounds = YES;
    self.bindBtn.titleLabel.font = kPingFangRegular(15 * scale);
    [self.bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [self.bindBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.bindBtn addTarget:self action:@selector(bindButtonDidBeClicked) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:self.bindBtn];
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60 * scale, 30 * scale));
        make.centerY.mas_equalTo(_bgView.mas_centerY);
        make.right.mas_equalTo(_bgView.mas_right).offset(- 15 * scale);
    }];
}

- (void)bindButtonDidBeClicked
{
    [BindBoxRequest cancelRequest];
    BindBoxRequest * request = [[BindBoxRequest alloc] initWithHotelID:[DeviceManager manager].hotelID roomID:[DeviceManager manager].roomID boxID:self.model.box_id mac:self.macAddress];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSDictionary * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSDictionary class]]) {
            if ([[result objectForKey:@"type"] integerValue] == 1) {
                [MBProgressHUD showTextHUDWithText:@"绑定成功" inView:[UIApplication sharedApplication].keyWindow];
            }else if ([[result objectForKey:@"type"] integerValue] == 1){
                [MBProgressHUD showTextHUDWithText:[result objectForKey:@"err_msg"] inView:[UIApplication sharedApplication].keyWindow];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:[UIApplication sharedApplication].keyWindow];
        }else{
            [MBProgressHUD showTextHUDWithText:@"绑定失败" inView:[UIApplication sharedApplication].keyWindow];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"绑定失败" inView:[UIApplication sharedApplication].keyWindow];
        
    }];
}

- (void)configWithModel:(BindDeviceModel *)model andMacAddress:(NSString *)macAddress
{
    self.model = model;
    self.macAddress = macAddress;
    
    self.tvNameLabel.text = [NSString stringWithFormat:@"电视名称：%@", model.tv_brand];
    self.roomNameLabel.text = [NSString stringWithFormat:@"包间名称：%@", model.room_name];
    self.boxNameLabel.text = [NSString stringWithFormat:@"机顶盒名称：%@", model.box_name];
    self.macAddressLabel.text = [NSString stringWithFormat:@"MAC地址：%@", model.box_mac];
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
