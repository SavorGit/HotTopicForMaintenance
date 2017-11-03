//
//  PositionListViewController.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^backData)(NSString *damIdString,NSString *name);

@interface PositionListViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic, copy) backData backDatas;

@end
