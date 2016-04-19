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

@interface MeViewController ()

@end

@implementation MeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

-(void) initData
{
    
}

-(void) initUI
{
    self.navigationItem.title = @"我";
    
    [self addEmptyTipsViewWithTitle:@"请使用11平台账号登录" IsShowButton:YES ButtonTitle:@"请登录"];
    
    [self showEmptyTipView];
    
//    [self _setUp];
//    
//    [self setChildVC];
//    
//    [self _baseConfigs];
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
    JJCViewController *jjcVC = [[JJCViewController alloc] init];
    
    MJViewController *mjVC = [[MJViewController alloc] init];
    
    TTViewController *ttVC = [[TTViewController alloc] init];
    
    [self setViewControllers:@[jjcVC,mjVC,ttVC]];
}

-(void)_baseConfigs
{
    self.automaticallyAdjustsScrollViewInsets = YES;
    if ([self.view respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        self.view.preservesSuperviewLayoutMargins = YES;
    }
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.segmentView = [[ARSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
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
    
    [self presentViewController:loginNavController animated:YES completion:nil];
}

@end
