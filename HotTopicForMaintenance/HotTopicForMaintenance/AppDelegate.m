//
//  AppDelegate.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/9/1.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "BaseNavigationController.h"
#import "HotTopicTools.h"
#import "UMessage.h"
#import <UserNotifications/UserNotifications.h>
#import "UserManager.h"

#import "UserLoginViewController.h"
#import "ErrorDetailViewController.h"
#import "TaskDetailViewController.h"
#import "RegDeviceToken.h"

#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()<UNUserNotificationCenterDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [HotTopicTools configApplication];
    
    HomeViewController * home = [[HomeViewController alloc] init];
    BaseNavigationController * homeRoot = [[BaseNavigationController alloc] initWithRootViewController:home];
    self.window.rootViewController = homeRoot;
    
    //处理启动时候的相关事务
    [self handleLaunchWorkWithOptions:launchOptions];
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configLocation) name:RDUserLoginStatusDidChange object:nil];
    
    return YES;
}

- (void)configLocation
{
    [self regDeviceTokenRequest];
    if ([UserManager manager].isUserLoginStatusEnable) {
        if ([UserManager manager].user.roletype == UserRoleType_SingleVersion) {
            if ([CLLocationManager locationServicesEnabled]) {
                self.locationManager = [[CLLocationManager alloc] init];
                self.locationManager.delegate = self;
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                self.locationManager.distanceFilter = 100;
                CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
                if (status == kCLAuthorizationStatusNotDetermined) {
                    [self.locationManager requestWhenInUseAuthorization];
                }else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted){
                    NSLog(@"未打开定位权限");
                }else{
                    [self getLocationInfo];
                }
            }else{
                NSLog(@"系统定位被关闭");
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [self getLocationInfo];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation * location = [locations lastObject];
    [UserManager manager].latitude = location.coordinate.latitude;
    [UserManager manager].longitude = location.coordinate.longitude;
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark * place = [placemarks objectAtIndex:0];
        
        NSString * placeName = [[NSString alloc] init];
        
        if (place.country) {
            placeName = [placeName stringByAppendingString:place.country];
        }
        if (place.administrativeArea) {
            placeName = [placeName stringByAppendingString:place.administrativeArea];
        }
        if (place.subAdministrativeArea) {
            placeName = [placeName stringByAppendingString:place.subAdministrativeArea];
        }
        if (place.locality && ![place.locality isEqualToString:place.administrativeArea]) {
            placeName = [placeName stringByAppendingString:place.locality];
        }
        if (place.subLocality) {
            placeName = [placeName stringByAppendingString:place.subLocality];
        }
        if (place.thoroughfare) {
            placeName = [placeName stringByAppendingString:place.thoroughfare];
        }
        if (place.subThoroughfare) {
            placeName = [placeName stringByAppendingString:place.subThoroughfare];
        }
        if (place.inlandWater) {
            placeName = [placeName stringByAppendingString:place.inlandWater];
        }
        if (place.ocean) {
            placeName = [placeName stringByAppendingString:place.ocean];
        }
        [UserManager manager].locationName = placeName;
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
//    [manager stopUpdatingLocation];
}

- (void)getLocationInfo
{
    [self.locationManager startUpdatingLocation];
}

//处理启动时候的相关事务
- (void)handleLaunchWorkWithOptions:(NSDictionary *)launchOptions
{
    //友盟推送
    [UMessage startWithAppkey:UmengAppkey launchOptions:launchOptions];
    [UMessage setAutoAlert:NO];
    [UMessage registerForRemoteNotifications];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate=self;
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge|	UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
                //这里可以添加一些自己的逻辑
            } else {
                //点击不允许
                //这里可以添加一些自己的逻辑
            }
        }];
    }
}

//app注册推送deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                         stringByReplacingOccurrencesOfString: @">" withString: @""]
                        stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [UserManager manager].deviceToken = token;
    [self regDeviceTokenRequest];
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
    [self didReceiveNotificationWithInfo:userInfo];
}

//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭U-Push自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [self didReceiveNotificationWithInfo:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
}

- (void)didReceiveNotificationWithInfo:(NSDictionary *)userInfo
{
    NSInteger type = [[userInfo objectForKey:@"type"] integerValue];
    NSString * jsonStr = [userInfo objectForKey:@"params"];
    
    if (isEmptyString(jsonStr)) {
        return;
    }
    
    NSDictionary * data = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    if ([data isKindOfClass:[NSDictionary class]]) {
        
    }
    
    UserNotificationModel * model = [[UserNotificationModel alloc] init];
    
    BaseNavigationController * na = (BaseNavigationController *)self.window.rootViewController;
    
    if (type == 1) {
        
        model.type = RDRemoteNotificationType_Error;
        NSString * error_id = [data objectForKey:@"error_id"];
        if (!isEmptyString(error_id)) {
            model.error_id = error_id;
        }
        
        if ([UserManager manager].isUserLoginStatusEnable) {
            NSString * errorID = model.error_id;
            ErrorDetailViewController * detail = [[ErrorDetailViewController alloc] initWithErrorID:errorID];
            [na pushViewController:detail animated:YES];
        }else{
            [UserManager manager].notificationModel = model;
        }
        
    }else if (type == 2) {
        
        model.type = RDRemoteNotificationType_Task;
        NSString * task_id = [data objectForKey:@"task_id"];
        if (!isEmptyString(task_id)) {
            model.task_id = task_id;
        }
        if ([UserManager manager].isUserLoginStatusEnable) {
            NSString * taskID = model.task_id;
            
            TaskModel * taskModel = [[TaskModel alloc] init];
            taskModel.cid = taskID;
            
            TaskDetailViewController * detail = [[TaskDetailViewController alloc] initWithTaskModel:taskModel];
            [na pushViewController:detail animated:YES];
        }else{
            [UserManager manager].notificationModel = model;
        }
        
    }
}

- (void)regDeviceTokenRequest
{
    if ([UserManager manager].isUserLoginStatusEnable && !isEmptyString([UserManager manager].deviceToken)) {
        RegDeviceToken * deviceToken = [[RegDeviceToken alloc] init];
        [deviceToken sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
