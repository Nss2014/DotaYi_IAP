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

@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
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
        
        self.searchBar.placeholder          = @"搜索公众号";
        
        
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:COLOR_TITLE_BLACK];
        
        [self.searchBar becomeFirstResponder];
    }
}

-(void) requestWithPublicName:(NSString *)sendPublicName
{
//    NSString *encodeSearchString = [Tools encodeToPercentEscapeString:sendPublicName];
//    
//    NSString *bodyURLStr = [NSString stringWithFormat:@"userToken=%@&pageidx=%ld&count=20&timestamp=%lld&random=%@&version=%@&dev=%@&platform=%@&param=%@",
//                            [HP_Application sharedApplication].loginDataObj.login_userToken,
//                            self.currentMainPage,
//                            [Tools getCurrentTimeStamp],
//                            [Tools getRandomSixthString],
//                            APPLICATION_VERSIN,
//                            APP_HK_DEV,
//                            APP_HK_PLATFORM,
//                            encodeSearchString
//                            ];
//    
//    NSString *urlString = [NSString stringWithFormat:@"%@&%@",HK_SEARCHOFFICIAL_URL,bodyURLStr];
//    
//    NSLog(@"urlString %@",urlString);
//    
//    [CustomRequest asyncGetWithUrlString:urlString target:self action:@selector(searchPublicNameCallBack:)];
}


@end
