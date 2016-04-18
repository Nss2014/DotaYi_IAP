//
//  JJCViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "JJCViewController.h"

@interface JJCViewController ()<ARSegmentControllerDelegate>

@end

@implementation JJCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_COLOR;
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"竞技场";
}

@end
