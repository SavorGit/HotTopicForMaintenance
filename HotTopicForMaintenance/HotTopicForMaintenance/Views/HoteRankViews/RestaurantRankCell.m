//
//  RestaurantRankCell.m
//  SavorX
//
//  Created by 王海朋 on 2017/9/4.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RestaurantRankCell.h"

@interface RestaurantRankCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *macLabel;
@property (nonatomic, strong) UILabel *stbLabel;

@property (nonatomic, strong) UILabel *lastTimeLabel;
@property (nonatomic, strong) UILabel *lastUploadTimeLabel;
@property (nonatomic, strong) UILabel *mRecordLabel;
@property (nonatomic, strong) UILabel *mReContentLabel;
@property (nonatomic, strong) UIImageView *dotImageView;
@property (nonatomic, strong) UIImageView *bListImgView;

@property (nonatomic, strong) RestaurantRankModel *restRankModel;

@end

@implementation RestaurantRankCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = UIColorFromRGB(0xffffff);
    _bgView.layer.borderColor = UIColorFromRGB(0xeeeeee).CGColor;
    _bgView.layer.borderWidth = .5f;
    _bgView.layer.cornerRadius = 5.f;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 20);
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];

    self.versionLabel = [[UILabel alloc]init];
    self.versionLabel.font = [UIFont systemFontOfSize:14];
    self.versionLabel.textColor = UIColorFromRGB(0x434343);
    self.versionLabel.textAlignment = NSTextAlignmentLeft;
    self.versionLabel.text = @"版本";
    [_bgView addSubview:self.versionLabel];
    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30- 30)/3 - 30, 20));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    self.macLabel = [[UILabel alloc]init];
    self.macLabel.font = [UIFont systemFontOfSize:14];
    self.macLabel.textColor = UIColorFromRGB(0x434343);
    self.macLabel.textAlignment = NSTextAlignmentLeft;
    self.macLabel.text = @"Mac";
    [_bgView addSubview:self.macLabel];
    [self.macLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30- 30)/3 + 30, 20));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(self.versionLabel.mas_right);
    }];
    
    self.stbLabel = [[UILabel alloc]init];
    self.stbLabel.font = [UIFont systemFontOfSize:14];
    self.stbLabel.textColor = UIColorFromRGB(0x434343);
    self.stbLabel.textAlignment = NSTextAlignmentLeft;
    self.stbLabel.backgroundColor = [UIColor clearColor];
    self.stbLabel.text = @"机顶盒信息";
    [_bgView addSubview:self.stbLabel];
    [self.stbLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 30 - 30)/3 - 5, 20));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(self.macLabel.mas_right);
    }];
    
    self.bListImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.bListImgView.backgroundColor = [UIColor grayColor];
    self.bListImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.bListImgView.layer.cornerRadius = 20/2.0;
    self.bListImgView.layer.masksToBounds = YES;
    [_bgView addSubview:self.bListImgView];
    [self.bListImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(self.bgView.mas_right).offset(- 28);
    }];
    
    self.dotImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.dotImageView.backgroundColor = [UIColor grayColor];
    self.dotImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.dotImageView.layer.cornerRadius = 20/2.0;
    self.dotImageView.layer.masksToBounds = YES;
    [_bgView addSubview:self.dotImageView];
    [self.dotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(self.bgView.mas_right).offset(- 5);
    }];

    
    self.lastTimeLabel = [[UILabel alloc]init];
    self.lastTimeLabel.font = [UIFont systemFontOfSize:14];
    self.lastTimeLabel.textColor = UIColorFromRGB(0x434343);
    self.lastTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.lastTimeLabel.text = @"最后心跳时间";
    [_bgView addSubview:self.lastTimeLabel];
    [self.lastTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30, 20));
        make.top.mas_equalTo(self.versionLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
    }];
    
    self.lastUploadTimeLabel = [[UILabel alloc]init];
    self.lastUploadTimeLabel.font = [UIFont systemFontOfSize:14];
    self.lastUploadTimeLabel.textColor = UIColorFromRGB(0x434343);
    self.lastUploadTimeLabel.textAlignment = NSTextAlignmentLeft;
    self.lastUploadTimeLabel.text = @"最后上传时间";
    [_bgView addSubview:self.lastUploadTimeLabel];
    [self.lastUploadTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30 - 40, 20));//40为按钮虚拟触发范围
        make.top.mas_equalTo(self.lastTimeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
    }];
    
    self.mRecordLabel = [[UILabel alloc]init];
    self.mRecordLabel.font = [UIFont systemFontOfSize:14];
    self.mRecordLabel.textColor = UIColorFromRGB(0x434343);
    self.mRecordLabel.textAlignment = NSTextAlignmentLeft;
    self.mRecordLabel.text = @"维修记录:";
    [_bgView addSubview:self.mRecordLabel];
    [self.mRecordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 17));
        make.top.mas_equalTo(self.lastUploadTimeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(15);
    }];
    
    self.mReContentLabel = [[UILabel alloc]init];
    self.mReContentLabel.font = [UIFont systemFontOfSize:14];
    self.mReContentLabel.textColor = UIColorFromRGB(0x434343);
    self.mReContentLabel.textAlignment = NSTextAlignmentLeft;
    self.mReContentLabel.numberOfLines = 0;
    self.mReContentLabel.text = @"维修记录内容";
    [_bgView addSubview:self.mReContentLabel];
    [self.mReContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 30 - 65 - 60, 17));
        make.top.mas_equalTo(self.lastUploadTimeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.mRecordLabel.mas_right).offset(5);
    }];
    
    UIImageView * moreImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [moreImageView setImage:[UIImage imageNamed:@"more"]];
    [self.contentView addSubview:moreImageView];
    [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(10);
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(13);
    }];
}

- (void)configWithModel:(RestaurantRankModel *)model{
    self.restRankModel = model;
    
    self.versionLabel.text = model.rname;
    self.macLabel.text = model.mac;
    self.stbLabel.text = model.boxname;
    self.lastTimeLabel.text = [NSString stringWithFormat:@"最后心跳时间:%@",model.last_heart_time];
    self.lastUploadTimeLabel.text = [NSString stringWithFormat:@"最后上传日志时间:%@",model.last_nginx];
    //0 是红灯 1 是绿灯
    if (model.ustate == 0) {
        self.dotImageView.backgroundColor = [UIColor redColor];
    }else{
        self.dotImageView.backgroundColor = [UIColor greenColor];
    }
    
    if (model.recordList.count > 0) {
        
        NSMutableString *mReConString = [[NSMutableString alloc] init];
        for (int i = 0; i < model.recordList.count; i ++) {
            RepairRecordRankModel *tmpModel = [model.recordList objectAtIndex:i];
            [mReConString appendString:[NSString stringWithFormat:@"\n%@  (%@)",tmpModel.ctime,tmpModel.nickname]];
        }
        [mReConString replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        
        float reConHeight;//维修记录的高度
        reConHeight = model.recordList.count *17;
        [self.mReContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(reConHeight);
        }];
        self.mReContentLabel.text = mReConString;
        
    }else{
        [self.mReContentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(17);
        }];
        self.mReContentLabel.text = @"无";
    }
    
}

- (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
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
