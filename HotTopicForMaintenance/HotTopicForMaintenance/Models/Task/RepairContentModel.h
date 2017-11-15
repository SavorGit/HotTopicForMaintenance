//
//  RepairContentModel.h
//  HotTopicForMaintenance
//
//  Created by 王海朋 on 2017/11/2.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface RepairContentModel : Jastor

@property (nonatomic, copy)   NSString *name;
@property (nonatomic, copy)   NSString *contractor;
@property (nonatomic, copy)   NSString *mobile;
@property (nonatomic, copy)   NSString *addr;
@property (nonatomic, copy)   NSString *posionNum;
@property (nonatomic, copy)   NSString *tv_nums;

@property (nonatomic, copy)   NSString *title;
@property (nonatomic, assign) NSInteger imgHType;
@property (nonatomic, copy)   NSString *upImgUrl;
@property (nonatomic, copy)   NSString *boxName;
@property (nonatomic, copy)   NSString *boxId;
@property (nonatomic, strong)   UIImage *pubImg;

@end
