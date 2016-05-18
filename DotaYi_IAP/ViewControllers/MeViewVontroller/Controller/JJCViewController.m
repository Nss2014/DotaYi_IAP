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
    
    [self addListDataRequest];
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"竞技场";
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

//5.17号下午18:00 获取的Cookie
//uToken=CF003EBCE506CB81FF46583AABD756C775A948C8B2A4E4D0FCB1877E9F0C3427B4A5913A2011655870C89362B5EFCC0891E367BD7A9335847443F7F0898923A9276DBA5CFF2CFCDCE7FA3AAE61DA7AFD7CE4C5A977AB0B0E7D9FB554BEC9B1AAABD6C9A0BE1D6FD24887CF6AD2995AA876D052D6713826863A127774A877266BC4ABB1B12E0B259BDE049F4EFF4EA6A505D7E4456EE285E6071F9EF1A1C08099ED1319C01F0AA5EEDC5B84FC0B4CA58164592BDD00CE484B092AB19C56A8825068CC7373F8EF831F49C6E7FFD749FA7BA7F1DC3CFB261629180C069AB34147849E7AA28FB1237939C4011F2E1BE5E11C;

@end
