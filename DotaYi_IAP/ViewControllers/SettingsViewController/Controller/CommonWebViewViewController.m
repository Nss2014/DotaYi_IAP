//
//  CommonWebViewViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/7/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "CommonWebViewViewController.h"

@interface CommonWebViewViewController ()
{
    UIWebView *myWebView;
}
@end

@implementation CommonWebViewViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addNJKWebViewProgress:myWebView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.titleString && ![self.titleString isKindOfClass:[NSNull class]])
    {
        self.navigationItem.title = self.titleString;
    }
    
    [self initData];
    
    [self initUI];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSLog(@"self.webURLString=%@",self.webURLString);
            [self loadWebData:self.webURLString];
            
        });
    });
    
}

-(void) initData
{
    
}

-(void) initUI
{
    
    myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    
    [myWebView setBackgroundColor:[UIColor whiteColor]];
    
    [myWebView setOpaque:NO];
    myWebView.delegate = self;
    
    [self.view addSubview:myWebView];
}

-(void) loadWebData:(NSString*) webURL
{
    NSLog(@"self.webURLString=%@",webURL);
    
    //加载网页
    if (webURL)
    {
        NSURL *url=[NSURL URLWithString:webURL];
        
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        myWebView.delegate = self;
        [myWebView loadRequest:request];
    }
    
    //是否与用户交互（即用户能不能控制webview）
    [myWebView setUserInteractionEnabled:YES];
    //显示 UIWebView
    
    myWebView.autoresizesSubviews = YES;//自动调整大小
    myWebView.scalesPageToFit =YES;//自动对页面进行缩放以适应屏幕
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"didFailLoadWithError");
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    self.progressView.progressBarView.hidden = NO;
    
    [self.progressView setProgress:progress animated:YES];
}

@end
