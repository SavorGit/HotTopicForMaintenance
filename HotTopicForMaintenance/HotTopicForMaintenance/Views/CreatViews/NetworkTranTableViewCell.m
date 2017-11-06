//
//  NetworkTranTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "NetworkTranTableViewCell.h"

@interface NetworkTranTableViewCell()

@property (nonatomic, strong) UILabel *reasonLabel;
@property (nonatomic, strong) UIButton *hotelBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIImageView *rightImg;

@end

@implementation NetworkTranTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.reasonLabel = [[UILabel alloc]init];
    self.reasonLabel.font = [UIFont systemFontOfSize:14];
    self.reasonLabel.textColor = UIColorFromRGB(0x434343);
    self.reasonLabel.textAlignment = NSTextAlignmentLeft;
    self.reasonLabel.text = @"安装与验收";
    [self addSubview:self.reasonLabel];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((kMainBoundsWidth - 80), 20));
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(15);
    }];
    
    self.inPutTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.inPutTextField.text = @"俏江南";
    self.inPutTextField.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.inPutTextField];
    [self.inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 100, 20));
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(- 20);
    }];
}

- (void)configWithTitle:(NSString *)title andContent:(NSString *)contenStr andIdexPath:(NSIndexPath *)index{
    
    self.indexPath = index;
    self.reasonLabel.text = title;
    if (index.section == 0) {
        if (index.row == 0) {
            
            self.inPutTextField.hidden = YES;
            self.segment.hidden = YES;
            
            self.rightImg = [[UIImageView alloc] initWithFrame:CGRectZero];
            self.rightImg.contentMode = UIViewContentModeScaleAspectFit;
            [self.rightImg setImage:[UIImage imageNamed:@"selected"]];
            [self addSubview:self.rightImg];
            [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(16, 16));
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(- 20);
            }];
            
            self.hotelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            if (isEmptyString(contenStr)) {
                [self.hotelBtn setTitle:@"请选择酒楼" forState:UIControlStateNormal];
            }else{
                [self.hotelBtn setTitle:contenStr forState:UIControlStateNormal];
            }
            [self.hotelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.hotelBtn addTarget:self action:@selector(hotelPress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.hotelBtn];
            [self.hotelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(- 40);
                make.width.mas_lessThanOrEqualTo(kMainBoundsWidth - 36 - 15 - 100);
            }];
            
        }else if (index.row == 4){
            self.inPutTextField.hidden = YES;
            self.rightImg.hidden = YES;
            self.hotelBtn.hidden = YES;
            
            NSArray *array = [NSArray arrayWithObjects:@"紧急",@"正常", nil];
            self.segment = [[UISegmentedControl alloc]initWithItems:array];
            [self.segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
            self.segment.selectedSegmentIndex = 1;
            [self addSubview:self.segment];
            [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(140, 30));
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(- 20);
            }];
            
        }else{
            
            self.rightImg.hidden = YES;
            self.hotelBtn.hidden = YES;
            self.segment.hidden = YES;
            
            [self.inPutTextField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 100, 20));
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(- 20);
            }];
            self.inPutTextField.text = contenStr;
        }
        
    }
}

- (void)hotelPress:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(hotelPress:)]) {
        [self.delegate hotelPress:self.indexPath];
    }
}

-(void)change:(UISegmentedControl *)sender{
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(Segmented:)]) {
            [self.delegate Segmented:2];
        }
        NSLog(@"紧急");
    }else if (sender.selectedSegmentIndex == 1){
        if ([self.delegate respondsToSelector:@selector(Segmented:)]) {
            [self.delegate Segmented:3];
        }
        NSLog(@"正常");
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
