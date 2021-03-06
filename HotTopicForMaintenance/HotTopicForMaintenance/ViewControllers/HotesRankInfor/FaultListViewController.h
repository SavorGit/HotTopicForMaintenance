//
//  FaultListViewController.h
//  SavorX
//
//  Created by 王海朋 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^backData)(NSArray *array , NSString *damIdString);

@interface FaultListViewController : BaseViewController

@property (nonatomic, strong) NSMutableArray *dataSource;

@property(nonatomic, copy) backData backDatas;

- (instancetype)initWithIsFaultList:(BOOL)isFaultList;

@end
