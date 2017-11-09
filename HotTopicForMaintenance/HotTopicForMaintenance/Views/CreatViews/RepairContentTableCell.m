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

@property (nonatomic, strong) UILabel *titlePosionLabel;
@property (nonatomic, strong) UILabel *titleFaultLabel;
@property (nonatomic, strong) UILabel *titlePhotoLabel;
@property (nonatomic, strong) UIButton *addImgBtn;
@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation RepairContentTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andIdexPath:(NSIndexPath *)index{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.indexPath = index;
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = UIColorFromRGB(0xffffff);
    _bgView.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
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
        make.size.mas_equalTo(CGSizeMake(60, 20));
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
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [self.selectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.selectBtn addTarget:self action:@selector(selectPress:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:self.selectBtn];
    [self.selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.top.mas_equalTo(self.titlePosionLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
    }];
    
    self.inPutTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.inPutTextField.text = @"描述";
    self.inPutTextField.tag = self.indexPath.row;
    self.inPutTextField.font = [UIFont systemFontOfSize:14];
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
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.top.mas_equalTo(self.titleFaultLabel.mas_bottom).offset(30);
        make.left.mas_equalTo(15);
    }];
    
    self.addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addImgBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.addImgBtn addTarget:self action:@selector(addImgPress:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:self.addImgBtn];
    [self.addImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.mas_equalTo(self.titleFaultLabel.mas_bottom).offset(30);
        make.right.mas_equalTo(- 20);
    }];

    self.fImageView  = [[UIImageView alloc] init];
    self.fImageView.backgroundColor = [UIColor cyanColor];
    self.fImageView.userInteractionEnabled = YES;
    [_bgView addSubview:self.fImageView];
    
    
}

- (void)configWithContent:(RepairContentModel *)model andIdexPath:(NSIndexPath *)index{
    if (model.imgHType == 1) {
        self.addImgBtn.hidden = YES;
        
        [self.selectBtn setTitle:model.boxName forState:UIControlStateNormal];
        if (isEmptyString(model.boxName)) {
            [self.selectBtn setTitle:@"请选择" forState:UIControlStateNormal];
        }
        self.inPutTextField.text = model.title;
        
        CGFloat scale = kMainBoundsWidth / 375.f;
        [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kMainBoundsWidth - 30);
            make.height.mas_equalTo(50 *3 + 84.5 *scale - 20);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
        }];
        
        [self.fImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(150 *scale, 84.5 *scale));
            make.top.mas_equalTo(self.titlePhotoLabel.mas_top);
            make.left.mas_equalTo(self.titlePhotoLabel.mas_right).offset(10);
        }];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addImgPress:)];
        tap.numberOfTapsRequired = 1;
        [self.fImageView addGestureRecognizer:tap];
        
    }else{
        self.addImgBtn.hidden = NO;
        
        [self.selectBtn setTitle:model.boxName forState:UIControlStateNormal];
        if (isEmptyString(model.boxName)) {
            [self.selectBtn setTitle:@"请选择" forState:UIControlStateNormal];
        }
        self.inPutTextField.text = model.title;
        
        [_bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(kMainBoundsWidth - 30);
            make.height.mas_equalTo(50 *3);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(15);
        }];
    }
}

- (void)selectPress:(UIButton *)btn{
    
    [self.delegate selectPosion:btn andIndex:self.indexPath];
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
