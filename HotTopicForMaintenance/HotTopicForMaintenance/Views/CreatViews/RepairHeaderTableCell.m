//
//  RepairHeaderTableCell.m
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RepairHeaderTableCell.h"

@interface RepairHeaderTableCell()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *insTitleLab;
@property (nonatomic, strong) UILabel *contactTitleLab;
@property (nonatomic, strong) UILabel *phoneTitleLab;
@property (nonatomic, strong) UILabel *addressTitleLab;
@property (nonatomic, strong) UILabel *taskStateTitleLab;
@property (nonatomic, strong) UILabel *countTitleLab;

@property (nonatomic, strong) UITextField *contactField;
@property (nonatomic, strong) UITextField *phoneField;
@property (nonatomic, strong) UITextField *addressField;

@property (nonatomic, strong) UILabel *reasonLabel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *rightImg;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UIButton *reduceBtn;

@end

@implementation RepairHeaderTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        
        [self initWithSubView];
    }
    return self;
}

- (void)initWithSubView
{
    self.backgroundColor = UIColorFromRGB(0xffffff);
    
    UILabel *insTitleLab = [[UILabel alloc]init];
    insTitleLab.font = [UIFont systemFontOfSize:14];
    insTitleLab.textColor = UIColorFromRGB(0x434343);
    insTitleLab.textAlignment = NSTextAlignmentLeft;
    insTitleLab.text = @"选择酒楼";
    [self addSubview:insTitleLab];
    [insTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15);
    }];
    
    self.rightImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.rightImg.contentMode = UIViewContentModeScaleAspectFit;
    [self.rightImg setImage:[UIImage imageNamed:@"selected"]];
    [self addSubview:self.rightImg];
    [self.rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.mas_equalTo(17);
        make.right.mas_equalTo(- 20);
    }];
    
    self.hotelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.hotelBtn setTitle:@"请选择酒楼" forState:UIControlStateNormal];
    [self.hotelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.hotelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.hotelBtn addTarget:self action:@selector(hotelPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.hotelBtn];
    [self.hotelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(- 40);
        make.height.mas_equalTo(20);
        make.width.mas_lessThanOrEqualTo(kMainBoundsWidth - 36 - 15 - 100);
    }];
    
    UILabel *contactTitleLab = [[UILabel alloc]init];
    contactTitleLab.font = [UIFont systemFontOfSize:14];
    contactTitleLab.textColor = UIColorFromRGB(0x434343);
    contactTitleLab.textAlignment = NSTextAlignmentLeft;
    contactTitleLab.text = @"联系人";
    [self addSubview:contactTitleLab];
    [contactTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(insTitleLab.mas_bottom).offset(15 + 15);
        make.left.mas_equalTo(15);
    }];
    
    self.contactField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.contactField.text = @"俏江南";
    self.contactField.delegate = self;
    self.contactField.font = [UIFont systemFontOfSize:14];
    self.contactField.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.contactField];
    [self.contactField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 100, 20));
        make.top.mas_equalTo(insTitleLab.mas_bottom).offset(15 + 15);
        make.right.mas_equalTo(- 20);
    }];
    
    UILabel *phoneTitleLab = [[UILabel alloc]init];
    phoneTitleLab.font = [UIFont systemFontOfSize:14];
    phoneTitleLab.textColor = UIColorFromRGB(0x434343);
    phoneTitleLab.textAlignment = NSTextAlignmentLeft;
    phoneTitleLab.text = @"联系电话";
    [self addSubview:phoneTitleLab];
    [phoneTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(contactTitleLab.mas_bottom).offset(15 + 15);
        make.left.mas_equalTo(15);
    }];
    
    self.phoneField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.phoneField.text = @"俏江南";
    self.phoneField.delegate = self;
    self.phoneField.font = [UIFont systemFontOfSize:14];
    self.phoneField.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.phoneField];
    [self.phoneField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 100, 20));
        make.top.mas_equalTo(contactTitleLab.mas_bottom).offset(15 + 15);
        make.right.mas_equalTo(- 20);
    }];
    
    UILabel *addressTitleLab = [[UILabel alloc]init];
    addressTitleLab.font = [UIFont systemFontOfSize:14];
    addressTitleLab.textColor = UIColorFromRGB(0x434343);
    addressTitleLab.textAlignment = NSTextAlignmentLeft;
    addressTitleLab.text = @"地址";
    [self addSubview:addressTitleLab];
    [addressTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(phoneTitleLab.mas_bottom).offset(15 + 15);
        make.left.mas_equalTo(15);
    }];
    
    self.addressField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.addressField.text = @"俏江南";
    self.addressField.delegate = self;
    self.addressField.font = [UIFont systemFontOfSize:14];
    self.addressField.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.addressField];
    [self.addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth - 100, 20));
        make.top.mas_equalTo(phoneTitleLab.mas_bottom).offset(15 + 15);
        make.right.mas_equalTo(- 20);
    }];
    
    UILabel *taskStateTitleLab = [[UILabel alloc]init];
    taskStateTitleLab.font = [UIFont systemFontOfSize:14];
    taskStateTitleLab.textColor = UIColorFromRGB(0x434343);
    taskStateTitleLab.textAlignment = NSTextAlignmentLeft;
    taskStateTitleLab.text = @"任务紧急程度";
    [self addSubview:taskStateTitleLab];
    [taskStateTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(addressTitleLab.mas_bottom).offset(15 + 15);
        make.left.mas_equalTo(15);
    }];
    
    NSArray *array = [NSArray arrayWithObjects:@"紧急",@"正常", nil];
    self.segment = [[UISegmentedControl alloc]initWithItems:array];
    [self.segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
    self.segment.selectedSegmentIndex = 1;
    [self addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 25));
        make.top.mas_equalTo(addressTitleLab.mas_bottom).offset(12.5 + 15);
        make.right.mas_equalTo(- 20);
    }];
    
    UILabel *countTitleLab = [[UILabel alloc]init];
    countTitleLab.font = [UIFont systemFontOfSize:14];
    countTitleLab.textColor = UIColorFromRGB(0x434343);
    countTitleLab.textAlignment = NSTextAlignmentLeft;
    countTitleLab.text = @"版位数量";
    [self addSubview:countTitleLab];
    [countTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.top.mas_equalTo(taskStateTitleLab.mas_bottom).offset(15 + 15);
        make.left.mas_equalTo(15);
    }];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(taskStateTitleLab.mas_bottom).offset(10 + 15);
        make.right.mas_equalTo(- 35);
    }];
    
    self.numLabel = [[UILabel alloc]init];
    self.numLabel.font = [UIFont systemFontOfSize:15];
    self.numLabel.textColor = [UIColor blackColor];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.text = @"1";
    [self addSubview:self.numLabel];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.top.mas_equalTo(taskStateTitleLab.mas_bottom).offset(15 + 15);
        make.right.mas_equalTo(self.addBtn.mas_left);
    }];
    
    self.reduceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reduceBtn setImage:[UIImage imageNamed:@"reduce"] forState:UIControlStateNormal];
    [self.reduceBtn addTarget:self action:@selector(reducePress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.reduceBtn];
    [self.reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(taskStateTitleLab.mas_bottom).offset(10 + 15);
        make.right.mas_equalTo(self.numLabel.mas_left);
    }];
    
    for (int i = 0; i < 6; i ++) {
        
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(kMainBoundsWidth, 1));
            make.top.mas_equalTo(49 + 50 *i);
            make.left.mas_equalTo(0);
        }];
        
    }
}

- (void)configWithContent:(RepairContentModel *)model andPNum:(NSString *)numStr andIdexPath:(NSIndexPath *)index{
  
    self.indexPath = index;
     [self.hotelBtn setTitle:model.name forState:UIControlStateNormal];
    if (isEmptyString(model.name)) {
        [self.hotelBtn setTitle:@"请选择酒楼" forState:UIControlStateNormal];
    }
    self.contactField.text = model.contractor;
    self.phoneField.text = model.mobile;
    self.addressField.text = model.addr;
    self.numLabel.text = numStr;

}

- (void)hotelPress:(UIButton *)btn{
    [self.delegate hotelPress:self.indexPath];
}

- (void)addPress{
    [self.delegate addNPress];
}

- (void)reducePress{
    [self.delegate reduceNPress];
}

-(void)change:(UISegmentedControl *)sender{
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"%@",textField.text);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
    
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
