//
//  VideoMainViewController.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/7/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "BaseViewController.h"
#import "VideoLeftViewController.h"

@interface VideoMainViewController : BaseViewController

@property (nonatomic,assign) BOOL isLeftBarButtonSelected;//控制左侧视图是否打开

@property(strong,nonatomic) VideoLeftViewController *leftMenuViewController;
@property(assign,nonatomic) CGFloat distance;
@property(strong,nonatomic) UIView *leftMenuView;
@property(strong,nonatomic) UIView *mainView;
@property(strong,nonatomic) UITapGestureRecognizer *tap;
@property(strong,nonatomic) UIPanGestureRecognizer *panGesture;


@property (nonatomic,copy) NSString *selectedChannelName;//已选频道名称  默认为左侧列表第一个
@property (nonatomic,copy) NSString *selectedChannelId;//已选频道id
@property (nonatomic,copy) NSString *selectedChannelImgUrl;//已选频道主播头像url 不包含域名

- (instancetype)initWithLeftMenuViewController:(VideoLeftViewController *) leftMenuVC;

- (void)showMainView;

- (void)showLeftMenuView;

@end
