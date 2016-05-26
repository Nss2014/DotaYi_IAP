//
//  MeViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/4/15.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "MeViewController.h"
#import "JJCViewController.h"
#import "MJViewController.h"
#import "TTViewController.h"
#import "LoginViewController.h"
#import "SearchViewController.h"

@interface MeViewController ()

@property (nonatomic,strong) JJCViewController *jjcVC;

@property (nonatomic,strong) MJViewController *mjVC;

@property (nonatomic,strong) TTViewController *ttVC;

@property (nonatomic,assign) NSInteger selectIndex;//记录选择的下标

@end

@implementation MeViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    //添加导航搜索按钮
    [self addNavSearchButton];
}

-(void) initData
{
    NSLog(@"me initData");
}

-(void) initUI
{
    if (!self.sendNavigationTitle)
    {
        self.sendNavigationTitle = @"战绩";
    }
    
    self.navigationItem.title = self.sendNavigationTitle;
    
//    [self addEmptyTipsViewWithTitle:@"请使用11平台账号登录" IsShowButton:YES ButtonTitle:@"请登录"];
    
    [self _setUp];
    
    [self setChildVC];
    
    [self _baseConfigs];
    
    [self hideEmptyTipView];
}

-(void) addNavSearchButton
{
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarItemPressed)];
    
    self.navigationItem.rightBarButtonItem = searchBarItem;
}

-(void) searchBarItemPressed
{
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)setViewControllers:(NSArray *)viewControllers
{
    [self.controllers removeAllObjects];
    
    [self.controllers addObjectsFromArray:viewControllers];
}

#pragma mark - private methdos

-(void)_setUp
{
    self.controllers = [NSMutableArray array];
}

-(void) setChildVC
{
    self.jjcVC = [[JJCViewController alloc] init];
    
    self.mjVC = [[MJViewController alloc] init];
    
    self.ttVC = [[TTViewController alloc] init];
    
    [self setViewControllers:@[self.jjcVC,self.mjVC,self.ttVC]];
}

-(void)_baseConfigs
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    if ([self.view respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.view.preservesSuperviewLayoutMargins = YES;
    }
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.segmentView = [[ARSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SEGMENT_HEIGHT)];
    
    [self.segmentView.segmentControl addTarget:self action:@selector(segmentControlDidChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentView];
    
    [self.controllers enumerateObjectsUsingBlock:^(UIViewController<ARSegmentControllerDelegate> *controller, NSUInteger idx, BOOL *stop) {
        NSString *title = [controller segmentTitle];
        
        [self.segmentView.segmentControl insertSegmentWithTitle:title
                                                        atIndex:idx
                                                       animated:NO];
    }];
    
    //defaut at index 0
    self.segmentView.segmentControl.selectedSegmentIndex = 0;
    UIViewController<ARSegmentControllerDelegate> *controller = self.controllers[0];
    [controller willMoveToParentViewController:self];
    [self.view insertSubview:controller.view atIndex:0];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    
    [self _layoutControllerWithController:controller];
    
    self.currentDisplayController = self.controllers[0];
    
}

-(void)_layoutControllerWithController:(UIViewController<ARSegmentControllerDelegate> *)pageController
{
    UIView *pageView = pageController.view;
    if ([pageView respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        pageView.preservesSuperviewLayoutMargins = YES;
    }
    pageView.translatesAutoresizingMaskIntoConstraints = YES;
    [pageView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    [pageView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [pageView addConstraint:[NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    
}

#pragma mark - event methods

-(void)segmentControlDidChangedValue:(UISegmentedControl *)sender
{
    //remove obsever
    [self removeObseverForPageController:self.currentDisplayController];
    
    //add new controller
    NSUInteger index = [sender selectedSegmentIndex];
    
    NSLog(@"index %ld",index);
    
    UIViewController<ARSegmentControllerDelegate> *controller = self.controllers[index];
    
    [self.currentDisplayController willMoveToParentViewController:nil];
    [self.currentDisplayController.view removeFromSuperview];
    [self.currentDisplayController removeFromParentViewController];
    [self.currentDisplayController didMoveToParentViewController:nil];
    
    [controller willMoveToParentViewController:self];
    [self.view insertSubview:controller.view atIndex:0];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    
    // reset current controller
    self.currentDisplayController = controller;
    
    //layout new controller
    [self _layoutControllerWithController:controller];
    
    //    [self.view addSubview:controller.view];
    
    [self.view setNeedsLayout];
    
    [self.view layoutIfNeeded];
    
    self.selectIndex = index;
    
    if (index == 0)
    {
        //竞技场
    }
    else if (index == 1)
    {
        //名将
    }
    else if (index == 2)
    {
        //天梯
    }
}

-(UIScrollView *)scrollViewInPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    if ([controller respondsToSelector:@selector(streachScrollView)]) {
        return [controller streachScrollView];
    }else if ([controller.view isKindOfClass:[UIScrollView class]]){
        return (UIScrollView *)controller.view;
    }else{
        return nil;
    }
}

-(void)removeObseverForPageController:(UIViewController <ARSegmentControllerDelegate> *)controller
{
    UIScrollView *scrollView = [self scrollViewInPageController:controller];
    if (scrollView != nil) {
        @try {
            [scrollView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
        }
        @catch (NSException *exception) {
            NSLog(@"exception is %@",exception);
        }
        @finally {
            
        }
    }
}

#pragma mark - manage memory methods

-(void)dealloc
{
    [self removeObseverForPageController:self.currentDisplayController];
}

-(void) reCallBtnPressed
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    
    UINavigationController *loginNavController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
//    WS(ws);
//    
//    [loginVC refreshBlock:^{
//       
//        [ws hideEmptyTipView];
//        
//        [ws _setUp];
//        
//        [ws setChildVC];
//        
//        [ws _baseConfigs];
//        
//        //获取当前登录的用户ID
//        self.sendUserId = [Tools strForKey:LOGIN_RESPONSE_USERID];
//        
//        [ws addListDataRequestWithUserId];
//        
//    }];
    
    [self presentViewController:loginNavController animated:YES completion:nil];
}

//根据用户ID请求一个用户的所有数据  包括竞技场、名将、天梯
-(void) addListDataRequestWithUserId
{
    //获取名将、天梯、竞技场数据
    NSString *urlString = @"http://score.5211game.com/RecordCenter/request/record";
    
    NSString *body = [NSString stringWithFormat:@"method=getrecord&u=%@&t=10001",self.sendUserId];
    
    NSLog(@"body %@",body);
    
    [Tools platform11PostRequest:urlString ParamsBody:body target:self action:@selector(getJjcTtMjListDataCallBack:)];
}

-(void) getJjcTtMjListDataCallBack:(NSDictionary *) responseDic
{
    NSLog(@"responseDic %@",responseDic);
    
    NSNumber *getErrorCode = responseDic[@"error"];
    
    if ([getErrorCode isEqualToNumber:[NSNumber numberWithInteger:0]])
    {
        [Tools setBool:YES key:LOCAL_LOGINSTATUS];
        
        if (self.selectIndex == 0)
        {
            //竞技场 刷新数据
            [self.jjcVC reloadCurrentTableView];
        }
        else if (self.selectIndex == 1)
        {
            //名将
            [self.mjVC reloadCurrentTableView];
        }
        else if (self.selectIndex == 2)
        {
            //天梯
            [self.ttVC reloadCurrentTableView];
        }
    }
    else
    {
        [Tools setBool:NO key:LOCAL_LOGINSTATUS];
        
        //失效后跳转登录页面
    }
}


@end
