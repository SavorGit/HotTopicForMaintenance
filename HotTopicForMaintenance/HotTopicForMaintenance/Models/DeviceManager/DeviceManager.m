//
//  DeviceManager.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/11/3.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "DeviceManager.h"
#import "GCDAsyncUdpSocket.h"
#import "HotelGetIPRequest.h"
#import "Helper.h"

NSString * const RDSearchDeviceSuccessNotification = @"RDSearchDeviceSuccessNotification";
NSString * const RDSearchDeviceDidEndNotification = @"RDSearchDeviceDidEndNotification";

static NSString *ssdpForPlatform = @"238.255.255.250"; //监听小平台ssdp地址
static UInt16 platformPort = 11900; //监听小平台ssdp端口

@interface DeviceManager ()<GCDAsyncUdpSocketDelegate>

@property (nonatomic, strong) GCDAsyncUdpSocket * socket;
@property (nonatomic, assign) BOOL isSearch;

@property (nonatomic, copy, readwrite) NSString * hotelID;
@property (nonatomic, copy, readwrite) NSString * roomID;
@property (nonatomic, copy, readwrite) NSString * macAddress;
@property (nonatomic, assign, readwrite) BOOL isHotel;
@property (nonatomic, assign, readwrite) BOOL isRoom;

@property (nonatomic, copy) NSString * wifiName;

@end

@implementation DeviceManager

+ (instancetype)manager
{
    static dispatch_once_t once;
    static DeviceManager *manager;
    dispatch_once(&once, ^ {
        manager = [[DeviceManager alloc] init];
    });
    return manager;
}

- (void)startSearchDecice
{
    if (self.isSearch) {
        [self stopSearchDevice];
    }
    
    self.isSearch = YES;
    
    self.hotelID = @"";
    self.roomID = @"";
    self.isHotel = NO;
    self.isRoom = NO;
    
    [self joinMulticastGroup];
    [self searchDeciceWithGetIP];
    [self performSelector:@selector(SearchDeviceDidEnd) withObject:nil afterDelay:10.f];
}

- (void)SearchDeviceDidEnd
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RDSearchDeviceDidEndNotification object:nil];
    [self stopSearchDevice];
}

- (void)startMonitoring
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == AFNetworkReachabilityStatusUnknown) {
            [self stopSearchDevice];
        }else if (status == AFNetworkReachabilityStatusNotReachable) {
            [self stopSearchDevice];
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi) {
            [self startSearchDecice];
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){
            [[NSNotificationCenter defaultCenter] postNotificationName:RDSearchDeviceDidEndNotification object:nil];
            [self stopSearchDevice];
        }else{
            [self stopSearchDevice];
        }
    }];
    [mgr startMonitoring];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AppDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)AppWillResignActive
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        self.wifiName = [Helper getWifiName];
    }else{
        self.wifiName = @"";
    }
}

- (void)AppDidBecomeActive
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        NSString * wifiName = [Helper getWifiName];
        if (![self.wifiName isEqualToString:wifiName]) {
            [self startSearchDecice];
        }
    }
}

- (void)stopMonitoring
{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)searchDeciceWithGetIP
{
    HotelGetIPRequest * request = [[HotelGetIPRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString *hotelId = response[@"result"][@"hotelId"];
        if (!isEmptyString(hotelId)) {
            self.hotelID = hotelId;
            self.isHotel = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:RDSearchDeviceSuccessNotification object:nil];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

//获取到设备反馈信息
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(nullable id)filterContext{
    [self getInfoWithMulticastData:data];
}

//解析从小平台获取的SSDP的discover信息
- (NSString *)getInfoWithMulticastData:(NSData *)data
{
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSArray * array = [str componentsSeparatedByString:@"\n"];
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    
    for (NSString * infoStr in array) {
        NSArray * dictArray = [infoStr componentsSeparatedByString:@":"];
        if (dictArray.count == 2) {
            [dict setObject:[dictArray objectAtIndex:1] forKey:[dictArray objectAtIndex:0]];
        }
    }
    
    NSString * host = [dict objectForKey:@"Savor-HOST"];
    NSString * boxHost = [dict objectForKey:@"Savor-Box-HOST"];
    if (host.length || boxHost.length) {
        
        if ([[dict objectForKey:@"Savor-Type"] isEqualToString:@"box"]) {
            NSString * hotelID = [dict objectForKey:@"Savor-Hotel-ID"];
            if (!isEmptyString(hotelID)) {
                self.hotelID = hotelID;
                self.isHotel = YES;
            }
            
            NSString * roomID = [dict objectForKey:@"Savor-Room-ID"];
            if (!isEmptyString(roomID)) {
                self.roomID = roomID;
                self.isRoom = YES;
            }
            
            NSString * mac = [dict objectForKey:@"Savor-Box-MAC"];
            if (!isEmptyString(mac)) {
                self.macAddress = mac;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RDSearchDeviceSuccessNotification object:nil];
        }else{
            NSString * hotelID = [dict objectForKey:@"Savor-Hotel-ID"];
            if (!isEmptyString(hotelID)) {
                self.hotelID = hotelID;
                self.isHotel = YES;
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:RDSearchDeviceSuccessNotification object:nil];
        }
    }
    
    return nil;
}

- (void)joinMulticastGroup
{
    NSError *error = nil;
    if (![self.socket bindToPort:platformPort error:&error])
    {
        NSLog(@"Error binding: %@", error);
    }
    if (![self.socket joinMulticastGroup:ssdpForPlatform error:&error])
    {
        NSLog(@"Error join: %@", error);
    }
    if (![self.socket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
    }
}

- (void)stopSearchDevice
{
    [HotelGetIPRequest cancelRequest];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(SearchDeviceDidEnd) object:nil];
    if (!self.socket.isClosed) {
        [self.socket pauseReceiving];
        [self.socket close];
    }
    self.isSearch = NO;
}

- (GCDAsyncUdpSocket *)socket
{
    if (!_socket) {
        _socket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return _socket;
}

@end
