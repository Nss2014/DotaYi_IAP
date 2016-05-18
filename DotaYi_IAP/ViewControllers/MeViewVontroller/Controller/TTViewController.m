//
//  TTViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "TTViewController.h"

@interface TTViewController ()<ARSegmentControllerDelegate>

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_COLOR;
    
    [self addListDataRequest];
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"天梯";
}

-(void) addListDataRequest
{
    //获取名将、天梯、竞技场数据
    NSString *urlString = @"http://score.5211game.com/RecordCenter/request/record";
    
    NSString *getUserId = [Tools strForKey:LOGIN_RESPONSE_USERID];
    
    NSString *body = [NSString stringWithFormat:@"method=getrecord&u=%@&t=10001",getUserId];
    
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
    }
    else
    {
        [Tools setBool:NO key:LOCAL_LOGINSTATUS];
        
        //失效后跳转登录页面
    }
}

@end
