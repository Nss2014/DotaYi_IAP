//
//  MJViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "MJViewController.h"

@interface MJViewController ()<ARSegmentControllerDelegate>

@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_COLOR;
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"名将";
}
@end
