//
//  InstallAcceptTableViewCell.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/10/27.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InstallAcceptDelegate<NSObject>
- (void)addNPress;
- (void)reduceNPress;

@end

@interface InstallAcceptTableViewCell : UITableViewCell

@property (nonatomic, weak) id <InstallAcceptDelegate> delegate;

- (void)configWithTitle:(NSString *)title andContent:(NSString *)contenStr andIdexPath:(NSIndexPath *)index;

@end
