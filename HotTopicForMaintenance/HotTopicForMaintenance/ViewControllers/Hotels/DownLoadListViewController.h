//
//  DownLoadListViewController.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/18.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    DownLoadListType_Media = 1,
    DownLoadListType_ADs,
    DownLoadListType_PubProgram,
} DownLoadListType;

@interface DownLoadListViewController : BaseViewController

- (instancetype)initWithDataSource:(NSArray *)dataSource;

- (void)configType:(DownLoadListType)type mediaDate:(NSString *)mediaDate adDate:(NSString *)adDate;

@end
