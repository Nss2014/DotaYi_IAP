//
//  MeViewController.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/4/15.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "BaseViewController.h"

@interface MeViewController : BaseViewController

#pragma mark - ARSegmentView
@property (nonatomic, assign, readonly) CGFloat segmentToInset;

@property (nonatomic, weak) UIViewController<ARSegmentControllerDelegate> *currentDisplayController;

-(void)setViewControllers:(NSArray *)viewControllers;

@property (nonatomic, strong) ARSegmentView *segmentView;

@property (nonatomic, strong) NSMutableArray *controllers;

@property (nonatomic, strong) NSLayoutConstraint *headerHeightConstraint;

#pragma mark - ARSegmentView --- end ---

@end
