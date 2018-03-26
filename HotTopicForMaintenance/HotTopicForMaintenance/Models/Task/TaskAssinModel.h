//
//  TaskAssinModel.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2018/3/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface TaskAssinModel : Jastor

@property(nonatomic, copy) NSString *user_id;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, assign) BOOL isSelect; //自定义新增，非服务器返回
//@property(nonatomic, strong) NSMutableArray *task_info;

@end
