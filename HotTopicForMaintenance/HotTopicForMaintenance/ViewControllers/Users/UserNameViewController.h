//
//  UserNameViewController.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/2/5.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "BaseViewController.h"
#import "PublisherModel.h"

@interface UserNameViewController : BaseViewController
//    点击按钮block回调
@property (nonatomic,copy) void(^btnClick)(PublisherModel *);

- (instancetype)initWithPubArray:(NSArray *)pArray;

@end
