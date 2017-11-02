//
//  RepairContentTableCell.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RepairContentTableCell.h"

@interface RepairContentTableCell()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UITextField *inPutTextField;

@property (nonatomic, strong) UILabel *titlePosionLabel;
@property (nonatomic, strong) UILabel *titleFaultLabel;
@property (nonatomic, strong) UILabel *titlePhotoLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *fImageView;

@end

@implementation RepairContentTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
    _bgView.layer.borderColor = UIColorFromRGB(0xf6f2ed).CGColor;
    _bgView.layer.borderWidth = .5f;
    _bgView.layer.cornerRadius = 5.f;
    _bgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainBoundsWidth - 30);
        make.height.mas_equalTo(50 *3);
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
    }];
    
    self.titlePosionLabel = [[UILabel alloc]init];
    self.titlePosionLabel.font = [UIFont systemFontOfSize:14];
    self.titlePosionLabel.textColor = UIColorFromRGB(0x434343);
    self.titlePosionLabel.textAlignment = NSTextAlignmentLeft;
    self.titlePosionLabel.text = @"版位名称";
    [_bgView addSubview:self.titlePosionLabel];
    [self.titlePosionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 80), 20));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    rightImg.contentMode = UIViewContentModeScaleAspectFit;
    [rightImg setImage:[UIImage imageNamed:@"selected"]];
    [_bgView addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(- 20);
    }];
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [selectBtn addTarget:self action:@selector(selectPress:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(- 40);
    }];
    
    
    self.titleFaultLabel = [[UILabel alloc]init];
    self.titleFaultLabel.font = [UIFont systemFontOfSize:14];
    self.titleFaultLabel.textColor = UIColorFromRGB(0x434343);
    self.titleFaultLabel.textAlignment = NSTextAlignmentLeft;
    self.titleFaultLabel.text = @"故障现象";
    [_bgView addSubview:self.titleFaultLabel];
    [self.titleFaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 80), 20));
        make.top.mas_equalTo(self.titlePosionLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
    }];
    
    self.inPutTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.inPutTextField.text = @"俏江南";
    self.inPutTextField.textAlignment = NSTextAlignmentRight;
    [_bgView addSubview:self.inPutTextField];
    [self.inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(self.titlePosionLabel.mas_bottom).offset(30);
        make.right.mas_equalTo(- 20);
    }];
    
    self.titlePhotoLabel = [[UILabel alloc]init];
    self.titlePhotoLabel.font = [UIFont systemFontOfSize:14];
    self.titlePhotoLabel.textColor = UIColorFromRGB(0x434343);
    self.titlePhotoLabel.textAlignment = NSTextAlignmentLeft;
    self.titlePhotoLabel.text = @"故障照片";
    [_bgView addSubview:self.titlePhotoLabel];
    [self.titlePhotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 150), 20));
        make.top.mas_equalTo(self.titleFaultLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
    }];
    
    UIButton *addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addImgBtn.backgroundColor = [UIColor blueColor];
    [addImgBtn addTarget:self action:@selector(addImgPress) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:addImgBtn];
    [addImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(self.titleFaultLabel.mas_bottom).offset(30);
        make.right.mas_equalTo(- 20);
    }];
    
    self.fImageView  = [[UIImageView alloc] init];
    self.fImageView.backgroundColor = [UIColor cyanColor];
    [_bgView addSubview:self.fImageView];
    [addImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(self.titleFaultLabel.mas_bottom).offset(30);
        make.right.mas_equalTo(- 60);
    }];
}

- (void)configWithContent:(NSString *)contenStr andIdexPath:(NSIndexPath *)index;{
    self.indexPath = index;
    if (index.row == 1) {
        self.inPutTextField.text = contenStr;
    }
}

- (void)selectPress:(UIButton *)btn{
    
    [self.delegate selectPosion:btn];
}

- (void)addImgPress:(NSIndexPath *)index{
    
    [self.delegate addImgPress:self.indexPath];
    
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
