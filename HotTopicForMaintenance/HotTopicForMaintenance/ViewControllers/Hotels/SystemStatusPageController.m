//
//  SystemStatusPageController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2018/1/15.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "SystemStatusPageController.h"
#import "SystemStatusController.h"
#import "GetCityListRequest.h"

@interface SystemStatusPageController ()<WMPageControllerDataSource>

@property (nonatomic, strong) NSArray * titleArray;
@property (nonatomic, strong) NSArray * cityIDArray;

@end

@implementation SystemStatusPageController

- (instancetype)init
{
    if (self = [super init]) {
        
        [self configPageController];
        [self getCityList];

    }
    return self;
}

- (void)getCityList
{
    MBProgressHUD * hud = [MBProgressHUD showTextHUDWithText:@"获取城市列表" inView:self.view];
    
    GetCityListRequest * request = [[GetCityListRequest alloc] init];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        NSArray * result = [response objectForKey:@"result"];
        if ([result isKindOfClass:[NSArray class]]) {
            
            NSMutableArray * vcControllers = [NSMutableArray new];
            NSMutableArray * titleArray = [NSMutableArray new];
            NSMutableArray * IDArray = [NSMutableArray new];
            for (NSInteger i = 0; i < result.count; i++) {
                NSDictionary * dict = [result objectAtIndex:i];
                [titleArray addObject:[dict objectForKey:@"region_name"]];
                [IDArray addObject:[dict objectForKey:@"id"]];
                [vcControllers addObject:[SystemStatusController class]];
            }
            
            self.titles = [[NSArray alloc] initWithArray:titleArray];
            self.viewControllerClasses = [[NSArray alloc] initWithArray:vcControllers];
            self.cityIDArray = [[NSArray alloc] initWithArray:IDArray];
            
            [self reloadData];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        if ([response objectForKey:@"msg"]) {
            [MBProgressHUD showTextHUDWithText:[response objectForKey:@"msg"] inView:self.view];
        }else{
            [MBProgressHUD showTextHUDWithText:@"获取城市列表失败" inView:self.view];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"获取城市列表失败" inView:self.view];
        
    }];
}

- (void)configPageController
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.titleSizeNormal = 15.f * scale;
    self.titleSizeSelected = 16.f * scale;
    
    self.titleColorNormal = UIColorFromRGB(0x444444);
    self.titleColorSelected = kNavBackGround;
    
    self.progressColor = kNavBackGround;
    self.progressHeight = 1.5f;
    self.progressWidth = 40 * scale;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.progressViewBottomSpace = 0;
    
    self.preloadPolicy = WMPageControllerPreloadPolicyNeighbour;
    self.pageAnimatable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"系统状态";
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
    [self setNavBackArrowWithWidth:40];
}

- (void)setNavBackArrowWithWidth:(CGFloat)width {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    [button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, width, 44);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    [button addTarget:self action:@selector(navBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    return CGRectMake(0, 0, kMainBoundsWidth, 40 * scale);
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    NSString * cityID = [self.cityIDArray objectAtIndex:index];
    return [[SystemStatusController alloc] initWithCityID:cityID];
}

- (void)navBackButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
