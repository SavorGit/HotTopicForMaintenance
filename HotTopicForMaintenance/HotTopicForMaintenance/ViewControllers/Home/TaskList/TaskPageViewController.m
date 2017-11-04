//
//  TaskPageViewController.m
//  HotTopicForMaintenance
//
//  Created by 郭春城 on 2017/10/31.
//  Copyright © 2017年 郭春城. All rights reserved.
//

#import "TaskPageViewController.h"
#import "TaskListViewController.h"
#import "UserManager.h"

@interface TaskPageViewController ()<WMPageControllerDataSource>

@property (nonatomic, strong) NSArray * taskListTypeArray;

@end

@implementation TaskPageViewController

- (instancetype)init
{
    NSArray * vcArray = @[[TaskListViewController class],[TaskListViewController class],[TaskListViewController class], [TaskListViewController class]];
    NSArray * titleArray = @[@"全部", @"待指派", @"待处理", @"已完成"];
    self.taskListTypeArray = @[@(TaskListType_All), @(TaskListType_WaitAssign), @(TaskListType_WaitHandle), @(TaskListType_Completed)];
    
    if ([UserManager manager].user.roletype == UserRoleType_HandleTask) {
        vcArray = @[[TaskListViewController class],[TaskListViewController class],[TaskListViewController class]];
        titleArray = @[@"全部", @"待处理", @"已完成"];
        self.taskListTypeArray = @[@(TaskListType_All), @(TaskListType_WaitHandle), @(TaskListType_Completed)];
    }
    
    if (self = [super initWithViewControllerClasses:vcArray andTheirTitles:titleArray]) {
        [self configPageController];
    }
    return self;
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
    self.menuViewStyle = WMMenuViewStyleLine;
    self.progressViewBottomSpace = 0;
    
    self.preloadPolicy = WMPageControllerPreloadPolicyNeighbour;
    self.pageAnimatable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务列表";
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    
//    if (@available(iOS 11.0, *)) {
//        
//    }else{
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    [self setNavBackArrowWithWidth:40];
    
    self.menuView.frame = CGRectMake(0, 0, kMainBoundsWidth, 40);
    // Do any additional setup after loading the view.
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
    return CGRectMake(0, 0, kMainBoundsWidth, 40);
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    TaskListType type = [[self.taskListTypeArray objectAtIndex:index] integerValue];
    return [[TaskListViewController alloc] initWithTaskListType:type];
}

- (void)navBackButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
