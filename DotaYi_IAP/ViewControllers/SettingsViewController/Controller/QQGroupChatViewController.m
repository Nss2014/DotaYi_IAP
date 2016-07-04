//
//  QQGroupChatViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/6/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "QQGroupChatViewController.h"
#import "UMSocial.h"
#import "SGActionView.h"


@interface QQGroupChatViewController ()

@property (nonatomic,strong) UIImageView *groupQRCodeImageView;//

@end

@implementation QQGroupChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"加入QQ交流群";
    
//    [self setWechatRightMoreBarButton];
    
    [self initUI];
}

-(void) initUI
{
    
    self.view.backgroundColor = WHITE_COLOR;
    
    //图片尺寸
    //qq 540X740
    //weixin 610X960
    
    self.groupQRCodeImageView = [[UIImageView alloc] init];
    
    CGFloat qq_width = (SCREEN_HEIGHT - NAV_HEIGHT)*(2 * 54)/(3 * 74);
    
    self.groupQRCodeImageView.frame = CGRectMake((SCREEN_WIDTH - qq_width)/2, height + (SCREEN_HEIGHT - NAV_HEIGHT)/6, qq_width, (SCREEN_HEIGHT - NAV_HEIGHT)*2/3);
    
    self.groupQRCodeImageView.image = [UIImage imageNamed:@"qq_group_qrcode.JPG"];
    
    [self.view addSubview:self.groupQRCodeImageView];
}

-(void) rightBarButtonDown
{
    
#pragma mark - 分享我的二维码   自定义界面
    
    [UMSocialData defaultData].extConfig.qzoneData.title = @"妖刀";
    
    [UMSocialData defaultData].extConfig.qqData.title = @"妖刀";
    
    //QQ分享类型改为纯图片
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    
    //微信分享类型改为纯图片
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    
    [SGActionView showGridMenuWithTitle:@"分享我的二维码"
                             itemTitles:@[ @"微信好友", @"朋友圈", @"QQ", @"QQ空间"]
                                 images:@[ [UIImage imageNamed:@"umshare_wechat_friend.png"],
                                           [UIImage imageNamed:@"umshare_wechat_session.png"],
                                           [UIImage imageNamed:@"umshare_qq.png"],
                                           [UIImage imageNamed:@"umshare_qzone.png"]]
                         selectedHandle:^(NSInteger index){
                             
                             switch (index)
                             {
                                 case 0:
                                 {
                                     
                                     //取消
                                 }
                                     break;
                                     
                                 case 1:
                                 {
                                     
                                     [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"妖刀" image:self.groupQRCodeImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                             NSLog(@"分享成功！");
                                         }
                                     }];
                                 }
                                     break;
                                 case 2:
                                 {
                                     
                                     [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:@"妖刀" image:self.groupQRCodeImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                             NSLog(@"分享成功！");
                                         }
                                     }];
                                 }
                                     break;
                                 case 3:
                                 {
                                     
                                     [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"妖刀" image:self.groupQRCodeImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                             NSLog(@"分享成功！");
                                         }
                                     }];
                                     
                                 }
                                     break;
                                 case 4:
                                 {
                                     
                                     [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"妖刀" image:self.groupQRCodeImageView.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                             NSLog(@"分享成功！");
                                         }
                                     }];
                                 }
                                     break;
                                     
                                 default:
                                     break;
                             }
                             
                         }];
    
}


@end
