//
//  TLRootViewController.m
//  iOSAppTemplate
//
//  Created by h1r0 on 15/9/13.
//  Copyright (c) 2015年 lbk. All rights reserved.
//

#import "TLRootViewController.h"
#import "MeViewController.h"
#import "DataViewController.h"
#import "SettingsViewController.h"
#import "VideoMainViewController.h"
#import "VideoLeftViewController.h"

@interface TLRootViewController ()

@end

@implementation TLRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tabBar setBackgroundColor:WHITE_COLOR];
    [self.tabBar setTintColor:XLS_COLOR_MAIN_GRAY];
    
    [self initChildViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initChildViewControllers
{
    NSMutableArray *childVCArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    //首页
    MeViewController *meVC = [[MeViewController alloc] init];
    
    [meVC.tabBarItem setTitle:@"战绩"];
    
    meVC.tabBarItem.image = [[UIImage imageNamed:@"tab_normal_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    meVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_selected_1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *meNavC = [[UINavigationController alloc] initWithRootViewController:meVC];
    
    [childVCArray addObject:meNavC];
    
    //视频
    VideoLeftViewController *leftMenuVC = [[VideoLeftViewController alloc] init];
    
    VideoMainViewController *mineVC = [[VideoMainViewController alloc] initWithLeftMenuViewController:leftMenuVC];
    [mineVC.tabBarItem setTitle:@"视频"];
    mineVC.tabBarItem.image = [[UIImage imageNamed:@"tab_normal_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_selected_2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *mineNavC = [[UINavigationController alloc] initWithRootViewController:mineVC];
    [childVCArray addObject:mineNavC];
    
    //数据
    DataViewController *dataVC = [[DataViewController alloc] init];
    
    [dataVC.tabBarItem setTitle:@"数据"];
    
    dataVC.tabBarItem.image = [[UIImage imageNamed:@"tab_normal_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    dataVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_selected_3"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *dataNavC = [[UINavigationController alloc] initWithRootViewController:dataVC];
    
    [childVCArray addObject:dataNavC];
    
    //设置
    SettingsViewController *settingsVC = [[SettingsViewController alloc] init];
    
    [settingsVC.tabBarItem setTitle:@"设置"];
    
    settingsVC.tabBarItem.image = [[UIImage imageNamed:@"tab_normal_4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    settingsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_selected_4"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UINavigationController *settingsNavC = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    
    [childVCArray addObject:settingsNavC];
    
    [self setViewControllers:childVCArray];
}

//设置badgeValue
-(void) setRedViewCount:(NSInteger) badgeValue
{
    UITabBarItem * item=[self.tabBar.items objectAtIndex:0];
    
    if (badgeValue == 0)
    {
        item.badgeValue = nil;
    }
    else
    {
        item.badgeValue=[NSString stringWithFormat:@"%ld",(long)badgeValue];
    }

}
@end
