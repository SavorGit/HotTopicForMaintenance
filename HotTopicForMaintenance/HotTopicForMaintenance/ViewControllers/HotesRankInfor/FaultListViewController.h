//
//  FaultListViewController.h
//  SavorX
//
//  Created by 王海朋 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^backData)(NSString *str1);

@interface FaultListViewController : BaseViewController

@property (nonatomic, strong) NSArray *sourceData;

@property(nonatomic, copy) backData backDatas;

@end
