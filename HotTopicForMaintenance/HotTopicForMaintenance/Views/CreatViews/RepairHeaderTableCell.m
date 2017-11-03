//
//  RepairHeaderTableCell.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RepairHeaderTableCell.h"

@interface RepairHeaderTableCell()

@property (nonatomic, strong) UILabel *reasonLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, assign) int  posionNum;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *reduceBtn;

@end

@implementation RepairHeaderTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        self.posionNum = 1;
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.reasonLabel = [[UILabel alloc]init];
    self.reasonLabel.font = [UIFont systemFontOfSize:14];
    self.reasonLabel.textColor = UIColorFromRGB(0x434343);
    self.reasonLabel.textAlignment = NSTextAlignmentLeft;
    self.reasonLabel.text = @"安装与验收";
    [self addSubview:self.reasonLabel];
    [self.reasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake((100), 20));
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
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 1));
        make.top.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(0);
    }];
    
}

- (void)configWithTitle:(NSString *)title andContent:(NSString *)contenStr andIdexPath:(NSIndexPath *)index{
  
    self.indexPath = index;
    self.reasonLabel.text = title;
    if (index.row == 0) {
        self.inPutTextField.hidden = YES;
        self.addBtn.hidden = YES;
        self.numLabel.hidden = YES;
        self.reduceBtn.hidden = YES;
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
        self.addBtn.hidden = YES;
        self.numLabel.hidden = YES;
        self.reduceBtn.hidden = YES;
        
        NSArray *array = [NSArray arrayWithObjects:@"紧急",@"正常", nil];
        self.segment = [[UISegmentedControl alloc]initWithItems:array];
        [self.segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.segment];
        [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(140, 30));
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(- 20);
        }];
        
    }else if (index.row == 5){
        self.inPutTextField.hidden = YES;
        self.rightImg.hidden = YES;
        self.hotelBtn.hidden = YES;
        self.segment.hidden = YES;
        
        self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addBtn.backgroundColor = [UIColor blueColor];
        [self.addBtn addTarget:self action:@selector(addPress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.addBtn];
        [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(- 145);
        }];
        
        self.numLabel = [[UILabel alloc]init];
        self.numLabel.font = [UIFont systemFontOfSize:15];
        self.numLabel.textColor = [UIColor blackColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.text = @"1";
        [self addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 20));
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(- 75);
        }];
        
        self.reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reduceBtn.backgroundColor = [UIColor cyanColor];
        [self.reduceBtn addTarget:self action:@selector(reducePress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.reduceBtn];
        [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(- 35);
        }];
    }else{
        self.rightImg.hidden = YES;
        self.hotelBtn.hidden = YES;
        self.addBtn.hidden = YES;
        self.numLabel.hidden = YES;
        self.reduceBtn.hidden = YES;
        self.segment.hidden = YES;
        
        [self.inPutTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 100, 20));
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(- 20);
        }];
        self.inPutTextField.text = contenStr;
    }

}

- (void)hotelPress:(UIButton *)btn{
    [self.delegate hotelPress:self.indexPath];
}

- (void)addPress{
    self.posionNum ++;
    self.numLabel.text =  [NSString stringWithFormat:@"%d", self.posionNum];
    [self.delegate addNPress];
}

- (void)reducePress{
    if (self.posionNum != 1) {
        self.posionNum --;
    }
    self.numLabel.text =  [NSString stringWithFormat:@"%d", self.posionNum];
    [self.delegate reduceNPress];
}

-(void)change:(UISegmentedControl *)sender{
    NSLog(@"测试");
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"紧急");
    }else if (sender.selectedSegmentIndex == 1){
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
