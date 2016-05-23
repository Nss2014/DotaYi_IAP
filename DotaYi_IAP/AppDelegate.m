//
//  AppDelegate.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/4/15.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "AppDelegate.h"
#import "TLRootViewController.h"
#import "MobClick.h"
#import "UMessage.h"
#import "LoginViewController.h"

#define IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic,strong) TLRootViewController *mainTabbarCtl;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self creatFMDBTable];
    
    [self initRootViewController];
    
    [self handleNavigationBar];
    
    [self handleUM:launchOptions];
    
    return YES;
}

-(void) creatFMDBTable
{
    [[HP_Application sharedApplication].store createTableWithName:DB_ODDS];
    
    [[HP_Application sharedApplication].store createTableWithName:DB_HEROS];
}

-(void)handleUM:(NSDictionary *) launchOptions
{
    //Umessage-----------
    [MobClick setLogEnabled:NO];
    
    [MobClick setAppVersion:XcodeAppVersion];//参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:nil];//channelId是渠道名  为nil或@""时默认会被被当作@"App Store"渠道
    
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
}

-(void) initRootViewController
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    //自动登录
    if (1)
    {
        [self enterMainVC];
    }
    else
    {
        [self enterLoginVC];
    }
}

-(void) handleNavigationBar
{
    [[UINavigationBar appearance] setBarTintColor:XLS_COLOR_MAIN_GRAY];
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           WHITE_COLOR, NSForegroundColorAttributeName,
                                                           nil, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"Helvetica-light" size:18.0], NSFontAttributeName, nil]];
    
    [[UINavigationBar appearance] setTintColor:WHITE_COLOR];
    
    [[UINavigationBar appearance] setOpaque:YES];
    
    [[UINavigationBar appearance] setTranslucent:NO];
}

#pragma mark - 进入主界面

- (void)enterMainVC
{
    self.mainTabbarCtl = [[TLRootViewController alloc] init];
    
    self.mainTabbarCtl.delegate = self;
    
    [self.window setRootViewController:self.mainTabbarCtl];
    
    [self.window addSubview:self.mainTabbarCtl.view];
}

#pragma mark - 进入登录界面

-(void) enterLoginVC
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    UINavigationController *loginNavC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    [self.window setRootViewController:loginNavC];
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

-(APJSONParser *)APJSONParser
{
    if (!_APJSONParser)
    {
        _APJSONParser = [[APJSONParser alloc] init];
    }
    
    return _APJSONParser;
}

@end
