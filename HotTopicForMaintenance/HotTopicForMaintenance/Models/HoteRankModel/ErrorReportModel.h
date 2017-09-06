//
//  ErrorReportModel.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/6.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "Jastor.h"

@interface ErrorReportModel : Jastor

@property (nonatomic, copy) NSString * cid;
@property (nonatomic, copy) NSString * info;
@property (nonatomic, copy) NSString * date;

@end
