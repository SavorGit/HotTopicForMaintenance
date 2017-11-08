//
//  InstallAlerTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InstallCellDelegate<NSObject>

- (void)addImgPress:(NSIndexPath *)index;

@end

@interface InstallAlerTableViewCell : UITableViewCell

@property (nonatomic, weak) id <InstallCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *instaImg;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)configWithContent:(NSString *)titleString andIdexPath:(NSIndexPath *)index;

@end
