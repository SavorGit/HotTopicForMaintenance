//
//  InstallProAlertView.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InstallProAlertDelegate<NSObject>

- (void)subMitData;
- (void)cancel;

@end

@interface InstallProAlertView : UIView

@property (nonatomic, weak) id <InstallProAlertDelegate> delegate;

- (instancetype)initWithTotalCount:(NSInteger )totalCount;

@end
