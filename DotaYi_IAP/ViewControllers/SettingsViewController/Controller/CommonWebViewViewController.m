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

@property (nonatomic,strong) UITouch *touch;

@end

@implementation CommonWebViewViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self addNJKWebViewProgress:myWebView];
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
    
    [self loadWebData:self.webURLString];
    
    [self appDelegate].isRotation = YES;
}

-(void) initData
{
    
}

-(void) initUI
{
    
    myWebView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)];
    
    [myWebView setBackgroundColor:[UIColor whiteColor]];
    
//    [myWebView setOpaque:NO];
    
    myWebView.delegate = self;
    
    [self.view addSubview:myWebView];
    
    //添加返回按钮
    UIButton *leftReturnButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftReturnButton setImage:[UIImage imageNamed:@"web_return_icon"] forState:UIControlStateNormal];
    
    [leftReturnButton addTarget:self action:@selector(leftReturnBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftReturnButton];
    
    WS(ws);
    
    [leftReturnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left).offset(PADDING_WIDTH);
        make.top.equalTo(ws.view.mas_top).offset(PADDING_WIDTH);
        make.width.mas_equalTo(30);
        make.height.equalTo(leftReturnButton.mas_width);
    }];
}

-(void) leftReturnBtnPressed
{
    [self appDelegate].isRotation = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) loadWebData:(NSString*) webURL
{
    NSLog(@"self.webURLString=%@",webURL);
    
    //加载网页
    if (webURL)
    {
        NSURL *url=[NSURL URLWithString:webURL];
        
        NSURLRequest *request=[[NSURLRequest alloc] initWithURL:url];
        
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
//    [myWebView stringByEvaluatingJavaScriptFromString:
//     @"var script = document.createElement('script');"
//     "<meta"
//     "script.name = 'viewport'"
//     "script.content = \"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=no;\""
//     "/>"
//     ];

    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    CoreSVPLoading(nil, nil);}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
    
    CoreSVPDismiss;
    //添加meta标签  设置网页横屏后宽高和屏幕一致
    //    NSString *js_fit_code = [NSString stringWithFormat:@"var meta = document.createElement('meta');"
    //                             "meta.name = 'viewport';"
    //                             "meta.content = 'width=device-width, initial-scale=1.0,minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes';"
    //                             "document.getElementsByTagName('head')[0].appendChild(meta);"
    //                             ];
    //    [webView stringByEvaluatingJavaScriptFromString:js_fit_code];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    CoreSVPDismiss;
    
    NSLog(@"didFailLoadWithError");
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    self.progressView.progressBarView.hidden = NO;
    
    [self.progressView setProgress:progress animated:YES];
}


@end
