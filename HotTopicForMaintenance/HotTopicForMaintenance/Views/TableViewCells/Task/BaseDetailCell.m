//
//  BaseDetailCell.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/10.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseDetailCell.h"
#import "LookImageViewController.h"

@interface BaseDetailCell ()

@end

@implementation BaseDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        [self createBaseDetailCell];
    }
    return self;
}

- (void)createBaseDetailCell
{
    
}

- (void)showWindowImage:(NSString *)url
{
    UINavigationController * na = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([na respondsToSelector:@selector(presentViewController:animated:completion:)]) {
        LookImageViewController * imageVC = [[LookImageViewController alloc] initWithImageURL:url];
        [na presentViewController:imageVC animated:NO completion:nil];
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
