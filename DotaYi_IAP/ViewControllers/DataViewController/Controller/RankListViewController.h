//
//  RankListViewController.h
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "BaseViewController.h"

@interface RankListViewController : BaseViewController

#pragma mark - ARSegmentView
@property (nonatomic, assign, readonly) CGFloat segmentToInset;

@property (nonatomic, weak) UIViewController<ARSegmentControllerDelegate> *currentDisplayController;

-(void)setViewControllers:(NSArray *)viewControllers;

@property (nonatomic, strong) ARSegmentView *segmentView;

@property (nonatomic, strong) NSMutableArray *controllers;

@property (nonatomic, strong) NSLayoutConstraint *headerHeightConstraint;

#pragma mark - ARSegmentView --- end ---

@end
