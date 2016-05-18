//
//  TotalRankViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/18.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "TotalRankViewController.h"

@interface TotalRankViewController ()<ARSegmentControllerDelegate>

@end

@implementation TotalRankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_COLOR;
    
    [self getTotalRankRequest];
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"总排行榜";
}

-(void) getTotalRankRequest
{
    //DT_GETJJCTOTALRANK_URL
    
    NSString *body = @"action=UserRankDatas";
    
    CoreSVPLoading(nil, nil);
    
    [Tools platform11PostRequest:DT_GETJJCRANK_URL ParamsBody:body target:self action:@selector(getTotalRankListDataCallBack:)];
}

-(void) getTotalRankListDataCallBack:(NSDictionary *) responseDic
{
    CoreSVPDismiss;
    
    NSLog(@"responseDic %@",responseDic);
}

@end
