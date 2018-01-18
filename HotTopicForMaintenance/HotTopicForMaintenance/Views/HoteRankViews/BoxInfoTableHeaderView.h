//
//  BoxInfoTableHeaderView.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BoxInfoTableHeaderViewDelegate<NSObject>

- (void)testButtonDidClicked;
- (void)mediaDownLoadButtonDidClicked;
- (void)adDownLoadButtonDidClicked;
- (void)pushListButtonDidClicked;

@end

@interface BoxInfoTableHeaderView : UIView

@property (nonatomic, assign) id<BoxInfoTableHeaderViewDelegate> delegate;

@end
