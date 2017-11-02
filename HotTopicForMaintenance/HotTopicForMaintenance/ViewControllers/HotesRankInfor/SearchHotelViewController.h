//
//  SearchHotelViewController.h
//  SavorX
//
//  Created by 王海朋 on 2017/9/5.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^backHotelValue)(NSString *hotelName , NSString *hotelId);
@interface SearchHotelViewController : BaseViewController

@property(nonatomic, copy) backHotelValue backHotel;
- (instancetype)initWithClassType:(NSInteger)classType;

@end
