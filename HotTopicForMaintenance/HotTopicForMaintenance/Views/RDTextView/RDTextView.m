//
//  RDTextView.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "RDTextView.h"
#import "MBProgressHUD+Custom.h"
#import "HotTopicTools.h"

@interface RDTextView ()

@end

@implementation RDTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.maxSize = 18;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)clearInputText
{
    self.text = @"";
    self.placeholderLabel.hidden = NO;
}

- (void)textDidChange
{
    NSString *toBeString = self.text;
    if (toBeString.length == 0) {
        self.placeholderLabel.hidden = NO;
        return;
    }else{
        self.placeholderLabel.hidden = YES;
    }
    
    NSString *lang = [self.textInputMode primaryLanguage]; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [self markedTextRange];
        //获取高亮部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            
            NSString *lastCharter;
            if(toBeString.length > 0){
               lastCharter = [toBeString substringFromIndex:toBeString.length - 1];
                if([lastCharter isEqualToString:@"\n"]){
                    toBeString = [toBeString substringToIndex:toBeString.length - 1];
                    self.text = toBeString;
                    [self resignFirstResponder];
                }
            }
            if (toBeString.length > self.maxSize ) {
                self.text = [toBeString substringToIndex:self.maxSize];
                [MBProgressHUD showTextHUDWithText:[NSString stringWithFormat:@"最多输入%ld个字符", self.maxSize] inView:[UIApplication sharedApplication].keyWindow];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > self.maxSize) {
            self.text = [toBeString substringToIndex:self.maxSize];
            [MBProgressHUD showTextHUDWithText:[NSString stringWithFormat:@"最多输入%ld个字符", self.maxSize] inView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel) {
        
        CGFloat height = [HotTopicTools getHeightByWidth:self.width - 10 title:_placeholder font:[UIFont systemFontOfSize:16]];
        
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [UIColor lightGrayColor];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
        _placeholderLabel.numberOfLines = 0;
        [self addSubview:_placeholderLabel];
        [_placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(7);
            make.left.mas_equalTo(5);
            make.height.mas_equalTo(height);
            make.width.mas_equalTo(self.width - 10);

        }];
    }
    
    return _placeholderLabel;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self textDidChange];
}

@end
