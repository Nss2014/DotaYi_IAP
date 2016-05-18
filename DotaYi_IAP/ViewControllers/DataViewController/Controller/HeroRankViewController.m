//
//  HeroRankViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/18.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroRankViewController.h"

@interface HeroRankViewController ()<ARSegmentControllerDelegate>

@end

@implementation HeroRankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_COLOR;
    
    [self getHeroRankRequest];
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"英雄排行榜";
}

-(void) getHeroRankRequest
{
    //DT_GETJJCRANK_URL
    NSString *body = @"action=HerosUserDatas";
    
    CoreSVPLoading(nil, nil);
    
    [Tools platform11PostRequest:DT_GETJJCRANK_URL ParamsBody:body target:self action:@selector(getHeroRankDataCallBack:)];
}

-(void) getHeroRankDataCallBack:(NSDictionary *) responseDic
{
    CoreSVPDismiss;
    
    NSLog(@"responseDic %@",responseDic);
}

@end
