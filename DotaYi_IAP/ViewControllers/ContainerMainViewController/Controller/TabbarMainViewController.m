//
//  TabbarMainViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/7/13.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "TabbarMainViewController.h"
#import "MainPageViewController.h"
#import "LiveTelecastViewController.h"

@interface TabbarMainViewController ()

@end

@implementation TabbarMainViewController

-(NSString *)name
{
    if (!_name) {
        _name=@"消息";
    }
    return _name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildViewControllers];
}

-(void)addChildViewControllers{
    
    [self addChildViewController:[[MainPageViewController alloc] init] andTitle:@"首页" andImageName:@"tab_1_"];
    
    [self addChildViewController:[[LiveTelecastViewController alloc] init] andTitle:@"直播" andImageName:@"tab_2_"];
}

-(void)addChildViewController:(UIViewController *)VC andTitle:(NSString *)title andImageName:(NSString *)imageName{
    
    VC.title=title;
    VC.tabBarItem.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@nor",imageName]];
    
    VC.tabBarItem.selectedImage=[UIImage imageNamed:[NSString stringWithFormat:@"%@press",imageName]];
    
    self.tabBar.tintColor = XLS_COLOR_MAIN_GREEN;
    
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:VC];
    
    [self addChildViewController:nav];
    
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}

@end
