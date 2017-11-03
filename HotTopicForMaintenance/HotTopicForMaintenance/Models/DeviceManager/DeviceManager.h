//
//  DeviceManager.h
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const RDSearchDeviceSuccessNotification; //搜索到酒楼ID或者房间ID
extern NSString * const RDSearchDeviceDidEndNotification; //搜索到酒楼ID或者房间ID

@interface DeviceManager : NSObject

//单例
+ (instancetype)manager;

@property (nonatomic, copy, readonly) NSString * hotelID;
@property (nonatomic, copy, readonly) NSString * roomID;
@property (nonatomic, assign, readonly) BOOL isHotel;
@property (nonatomic, assign, readonly) BOOL isRoom;

- (void)startSearchDecice;

- (void)stopSearchDevice;

- (void)startMonitoring;

- (void)stopMonitoring;

@end
