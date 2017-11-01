//
//  InstallAcceptTableViewCell.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/10/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "InstallAcceptTableViewCell.h"

@interface InstallAcceptTableViewCell()
//@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *reasonLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UITextField *inPutTextField;

@end

@implementation InstallAcceptTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
//    _bgView = [[UIView alloc] init];
//    _bgView.backgroundColor = UIColorFromRGB(0xf6f2ed);
//    _bgView.layer.borderColor = UIColorFromRGB(0xf6f2ed).CGColor;
//    _bgView.layer.borderWidth = .5f;
//    _bgView.layer.cornerRadius = 5.f;
//    _bgView.layer.masksToBounds = YES;
//    [self.contentView addSubview:_bgView];
//    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(kMainBoundsWidth);
//        make.height.mas_equalTo(60);
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//    }];
    
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
        make.size.mas_equalTo(CGSizeMake(100, 20));
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
    
    self.reasonLabel.text = title;
    if (index.section == 0) {
        if (index.row == 0) {
            UIImageView *rightImg = [[UIImageView alloc] initWithFrame:CGRectZero];
            rightImg.contentMode = UIViewContentModeScaleAspectFit;
            [rightImg setImage:[UIImage imageNamed:@"selected"]];
            [self addSubview:rightImg];
            [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(16, 16));
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(- 20);
            }];
            [self.inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100, 20));
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(- 40);
            }];
            self.inPutTextField.text = @"东方广场店";
        }else if (index.row == 4){
            self.inPutTextField.hidden = YES;
            
            NSArray *array = [NSArray arrayWithObjects:@"紧急",@"正常", nil];
            UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:array];
            [segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
            [self addSubview:segment];
            [segment mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(140, 30));
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(- 20);
            }];
            
        }else{
            [self.inPutTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(100, 20));
                make.centerY.mas_equalTo(self);
                make.right.mas_equalTo(- 20);
            }];
            self.inPutTextField.text = contenStr;
        }
        
    }else if (index.section == 1){
        self.inPutTextField.hidden = YES;
        
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBtn.backgroundColor = [UIColor blueColor];
        [addBtn addTarget:self action:@selector(addPress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addBtn];
        [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(- 145);
        }];
        
        self.numLabel = [[UILabel alloc]init];
        self.numLabel.font = [UIFont systemFontOfSize:15];
        self.numLabel.textColor = [UIColor blackColor];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.text = @"100";
        [self addSubview:self.numLabel];
        [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(60, 20));
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(- 75);
        }];
        
        UIButton *reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        reduceBtn.backgroundColor = [UIColor cyanColor];
        [reduceBtn addTarget:self action:@selector(reducePress) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:reduceBtn];
        [reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.centerY.mas_equalTo(self);
            make.right.mas_equalTo(- 35);
        }];
    }
   
    
}

- (void)addPress{
    
}

- (void)reducePress{
    
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
