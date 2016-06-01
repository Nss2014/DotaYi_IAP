//
//  SearchViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/23.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<UISearchBarDelegate>

@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@property (nonatomic) float searchBarBoundsY;

@property (nonatomic,strong) UISearchBar *searchBar;

@property (nonatomic,copy) NSString *searchText;//搜索关键词

@property (nonatomic,strong) UIWebView *myWebView;

@end

@implementation SearchViewController

-(void)viewDidAppear:(BOOL)animated
{
    [self.searchBar becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WS(ws);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [ws initData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [ws initUI];
            
        });
    });
}

-(void) initData
{
    self.dataSourceArray = [NSMutableArray array];
}

-(void) initUI
{
    self.navigationItem.title = @"搜索";
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.viwTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT);
    
    [self addSearchBar];
    
    [self.viwTable setTableHeaderView:self.searchBar];
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT)];
    
    [self.myWebView setBackgroundColor:[UIColor whiteColor]];
    
    self.myWebView.delegate = self;
}

#pragma mark - search

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearching];
    
    [self.dataSourceArray removeAllObjects];
    
    [self.viwTable reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //点击搜索
    
    if (searchBar.text && ![searchBar.text isEqualToString:@""])
    {
        self.searchText = searchBar.text;
        
        //搜索请求
        [self requestWithPublicName:self.searchText];
    }
    
    [self.view endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    
    NSLog(@"edit Text %@",searchBar.text);
}

-(void)cancelSearching
{
    [self.searchBar resignFirstResponder];
    
    self.searchBar.text  = @"";
}

-(void)addSearchBar
{
    if (!self.searchBar)
    {
        self.searchBarBoundsY = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        
        self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,self.searchBarBoundsY, [UIScreen mainScreen].bounds.size.width, 44)];
        
        self.searchBar.searchBarStyle       = UISearchBarStyleMinimal;
        
        self.searchBar.tintColor            = COLOR_TITLE_LIGHTGRAY;
        
        self.searchBar.barTintColor         = [UIColor whiteColor];
        
        self.searchBar.delegate             = self;
        
        self.searchBar.placeholder          = @"请输入11平台昵称";
        
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:COLOR_TITLE_BLACK];
    }
}

-(void) requestWithPublicName:(NSString *)sendPublicName
{
    NSString *encodeSearchString = [Tools encodeToPercentEscapeString:sendPublicName];
    
    NSString *urlString = [NSString stringWithFormat:@"http://score.5211game.com/RecordCenter/?u=%@&t=10001",encodeSearchString];
    
//    NSString *body = [NSString stringWithFormat:@"u=%@&t=10001",encodeSearchString];
    
    NSLog(@"urlString %@",urlString);
    
    [self setCookie];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    NSString *getResultStr = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//link[@rel='stylesheet']" DetailXPathQuery:nil DetailKey:@"href"];
    
    NSLog(@"getResultStr %@",getResultStr);
    
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
    
    [self.myWebView loadRequest:request];
    
    
    
//    NSMutableURLRequest * backRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
//
//    [backRequest setTimeoutInterval:5.f];
//    
//    //将字符串转换成二进制数据
//    NSData * postData = [body dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //设置http请求模式
//    [backRequest setHTTPMethod:@"GET"];
//    //设置POST正文的内容
//    [backRequest setHTTPBody:postData];
//    
//    [backRequest setValue:[Tools strForKey:LOGIN_COOKIE] forHTTPHeaderField:@"Cookie"];
//    
//    [NSURLConnection sendAsynchronousRequest:backRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"resultresultresult%@", result);
//        
//        NSLog(@"response %@",response);
//        
//        if (result && ![result isEqualToString:@""])
//        {
//            
//        }
//        else
//        {
//            
//        }
//        
//    }];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return  YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //获取所有html:
    NSString *lJs = @"document.documentElement.innerHTML";
    
    NSString *lHtml1 = [self.myWebView stringByEvaluatingJavaScriptFromString:lJs];
    
    NSLog(@"lHtml1 %@",lHtml1);
    
}

//设置cookie
- (void)setCookie
{
    NSMutableDictionary *cookiePropertiesUser = [NSMutableDictionary dictionary];
    [cookiePropertiesUser setObject:@"Cookie" forKey:NSHTTPCookieName];
    [cookiePropertiesUser setObject:[Tools strForKey:LOGIN_COOKIE] forKey:NSHTTPCookieValue];
    [cookiePropertiesUser setObject:@"http://score.5211game.com/" forKey:NSHTTPCookieDomain];
    [cookiePropertiesUser setObject:@"/" forKey:NSHTTPCookiePath];
    [cookiePropertiesUser setObject:@"0" forKey:NSHTTPCookieVersion];
    
    NSHTTPCookie *cookieuser = [NSHTTPCookie cookieWithProperties:cookiePropertiesUser];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookieuser];
}


@end
