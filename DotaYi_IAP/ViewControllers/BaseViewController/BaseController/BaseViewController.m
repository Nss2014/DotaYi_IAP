//
// BaseViewController.m
//
//
//  Created by yangyp on 15－7-28.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"
#import <objc/runtime.h>
#import "MobClick.h"
#import "LoginViewController.h"
#import "MeViewController.h"
#import "DataViewController.h"
#import "SettingsViewController.h"

@interface BaseViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UITextFieldDelegate,KSRefreshViewDelegate>

@property (nonatomic,copy) NSString *DZN_emptyTitle;//无数据提示

@property (nonatomic,copy) NSString *DZN_emptyDetailTitle;//详细提示

@property (nonatomic,strong) UIColor *DZN_emptyTitleColor;//无数据字体颜色 默认传nil

@property (nonatomic,strong) UIColor *DZN_emptyDetailTitleColor;//详细颜色 默认传nil

@property (nonatomic,strong) UIFont *DZN_emptyFont;//无数据字体大小 默认传22

@property (nonatomic,strong) UIFont *DZN_emptyDetaiFont;//详细字体大小 默认传14

@end

@implementation BaseViewController
@synthesize viwTable;
@synthesize viwScrollView;
@synthesize titleBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *arrayChildClass = [self findAllOf: [self class]] ;//获取UIView的所以子类
    
    NSString *subClassStr = @"123";
    
    if (arrayChildClass.count)
    {
        subClassStr = NSStringFromClass([arrayChildClass firstObject]);
    }
    
    [MobClick beginLogPageView:subClassStr];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSArray *arrayChildClass = [self findAllOf: [self class]] ;//获取UIView的所以子类
    
    NSLog(@"arrayChildClass %@",arrayChildClass);
    
    NSString *subClassStr = @"123";
    
    if (arrayChildClass.count)
    {
        subClassStr = NSStringFromClass([arrayChildClass firstObject]);
    }

    [MobClick endLogPageView:subClassStr];
    
    [self.view endEditing:YES];
    
    if (![self isKindOfClass:[MeViewController class]]
        &&
        ![self isKindOfClass:[DataViewController class]]
        &&
        ![self isKindOfClass:[SettingsViewController class]]
        )
    {
        
    }
    else
    {
        [self setHidesBottomBarWhenPushed:NO];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    CoreSVPDismiss;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:WHITE_COLOR];
    
    [self initData];
    
    [self addBackItemWithAction];
}

-(void) initData
{
    self.currentMainPage = 0;
    
    self.isFooterRefresh = NO;
    
    height = 20;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
        // Release any retained subviews of the main view.
        // e.g. self.myOutlet = nil;
}

#pragma mark - 添加返回按钮
- (void)addBackItemWithAction
{
    if (IS_IOS7)
    {
        UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] init];
        
        returnButtonItem.title = @"返回";
        
        self.navigationItem.backBarButtonItem = returnButtonItem;
        
    } else
    {
        // 设置返回按钮的文本
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"返回"
                                       style:UIBarButtonItemStylePlain target:nil action:nil];
        
        [self.navigationItem setBackBarButtonItem:backButton];
    }
}

#pragma mark - 添加下拉刷新 上拉加载控件
-(void) addKSHeaderAndFooterRefresh
{
    //默认提供三种刷新方式
    //KSDefaultHeadRefreshView 下拉刷新
    //KSDefaultFootRefreshView 上拉刷新
    //KSAutoFootRefreshView 底部自动刷新
    //如果觉得这三种刷新视图不够用可以继承KSHeadRefreshView或KSFootRefreshView自行实现刷新试图
    
    self.viwTable.header         = [[KSDefaultHeadRefreshView alloc] initWithDelegate:self];

    self.viwTable.footer         = [[KSAutoFootRefreshView alloc] initWithDelegate:self];
}

- (void)refreshViewDidLoading:(id)view
{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

-(void) clickLeftButton
{
    
}

-(void) clickRightButton
{
    
}

-(void) setWechatRightMoreBarButton
{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"barbuttonicon_more"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonDown)];
    
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
}

-(void) rightBarButtonDown
{
    
}

#pragma mark - 重新加载
-(void) setDZNEmptyDataWithTableView:(UITableView *)sendTableView  andEmptyTitle:(NSString *) aTitle titleColor:(UIColor *) aTitleColor titleFont:(UIFont *) aTitleFont andEmptyDetailTitle:(NSString *) aDetailTitle detailTitleColor:(UIColor *) aDetailTitleColor detailTitleFont:(UIFont *) aDetailTitleFont
{
    sendTableView.tableHeaderView = [UIView new];
    
    sendTableView.tableFooterView = [UIView new];
    
    sendTableView.emptyDataSetSource = self;
    
    sendTableView.emptyDataSetDelegate = self;
    
    self.DZN_emptyTitle = aTitle;
    
    self.DZN_emptyTitleColor = aTitleColor;
    
    self.DZN_emptyDetailTitle = aDetailTitle;
    
    self.DZN_emptyDetailTitleColor = aDetailTitleColor;
    
    self.DZN_emptyFont = aTitleFont;
    
    self.DZN_emptyDetaiFont = aDetailTitleFont;
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = self.DZN_emptyTitle;
    UIFont *font = self.DZN_emptyFont;
    UIColor *textColor = self.DZN_emptyTitleColor;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
//    text = @"请求失败";
//    font = [UIFont systemFontOfSize:22.0];
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = self.DZN_emptyDetailTitle;
    UIFont *font = self.DZN_emptyDetaiFont;
    UIColor *textColor = self.DZN_emptyDetailTitleColor;
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
//    text = @"\n\n点击页面重新加载";
//    font = [UIFont systemFontOfSize:16.0];
    
    if (!text) {
        return nil;
    }
    
    if (font) [attributes setObject:font forKey:NSFontAttributeName];
    if (textColor) [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    if (paragraph) [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    
    return attributedString;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    
    return [UIImage imageNamed:@"empty.png"];
}


- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView
{
    return 9.0;
}


#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSetDidTapView:(UIScrollView *)scrollView
{
    //重新加载
    
    NSLog(@"%s",__FUNCTION__);
}

#pragma mark - userDefaults

#pragma mark - Add SubViews

    //添加表
-(void)addTableView:(UITableViewStyle)style separatorStyle:(UITableViewCellSeparatorStyle)sepStyle
{
    viwTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT) style:style];
    [viwTable setDelegate:self];
    [viwTable setDataSource:self];
    [viwTable setBackgroundColor:WHITE_COLOR];
    [viwTable setSeparatorStyle:sepStyle];
    [self.view addSubview:viwTable];
}

-(void) addScrollView
{
    viwScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-49 - 64)];
    viwScrollView.delegate = self;
    [self.view addSubview:viwScrollView];
   
}

//分割线左对齐
-(void) setTableViewLeftAlignment:(UITableViewCell *)sendTableViewCell
{
    if ([sendTableViewCell respondsToSelector:@selector(setSeparatorInset:)]) {
        [sendTableViewCell setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([sendTableViewCell respondsToSelector:@selector(setLayoutMargins:)]) {
        [sendTableViewCell setLayoutMargins: UIEdgeInsetsZero];
    }
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    return cell;
}

- (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(NSInteger)width
{
    CGSize sizeToFit = [Tools getAdaptionSizeWithText:value andFont:[UIFont systemFontOfSize:fontSize] andLabelWidth:width];
    return sizeToFit.height;
}
- (CGFloat)lengthForString:(NSString *)value fontSize:(CGFloat)fontSize andHeight:(NSInteger)navHeight
{
    CGSize sizeToFit = [Tools getAdaptionSizeWithText:value AndFont:[UIFont systemFontOfSize:fontSize] andLabelHeight:navHeight];

    return sizeToFit.width;
}

- (AppDelegate *)appDelegate
{
    UIApplication *app = [UIApplication sharedApplication];
    AppDelegate *delegate = (AppDelegate *)app.delegate;
    
    return delegate;
}


-(void) reRequestButtonPressed
{
    NSLog(@"reRequestButtonPressed");
}

-(void) addTapGestureRecognizer
{
    UITapGestureRecognizer *viewTapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapedDismissKeyboard:)];
    
    [self.view addGestureRecognizer:viewTapGes];
}

-(void) viewTapedDismissKeyboard:(UITapGestureRecognizer *)sender
{

}

//左侧文字返回按钮
- (void)setLeftNavTitleButton:(NSString *)Title
{
    UIButton *leftbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.tag = 10011;
    NSString *deviceStr = [Tools deviceString];
    if([deviceStr rangeOfString:@"iPad"].location != NSNotFound)
    {
        leftbutton.frame=CGRectMake(10,  0, 90,40);
        
        leftbutton.titleLabel.font = TEXT14_FONT;
    }
    else if (IS_IPHONE4S || IS_IPHONE5)
    {
        leftbutton.frame=CGRectMake(10,  20 + (height -20 - (height-20))/2 , 90, 40);
        
        leftbutton.titleLabel.font = TEXT14_FONT;
    }
    else
    {
        leftbutton.frame=CGRectMake(10,  20 + (height -20 - (height-20))/2 , 90, 40);
        
        leftbutton.titleLabel.font = TEXT16_FONT;
    }
    
    //uibutton 图片大小修改为任意大小  添加UIImage类别
    
    [leftbutton setContentMode:UIViewContentModeScaleAspectFit];

    [leftbutton setTitle:Title forState:UIControlStateNormal];
    
    leftbutton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    leftbutton.backgroundColor = CLEAR_COLOR;
    //设置内容垂直或水平显示位置
    
    [leftbutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    
    [leftbutton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    
    [leftbutton addTarget:self action:@selector(leftNavTitleCallBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftbutton];
    
}

- (void) setLeftSystemButton:(NSString *) leftTitle
{
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"return_dafaut1_pressed_up@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(leftNavBtnCallBack)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void) setLeftOnlyTextItem:(NSString *) leftTitle
{
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithTitle:leftTitle style:UIBarButtonItemStylePlain target:self action:@selector(leftNavBtnCallBack)];
    [leftItem setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = leftItem;
}
//返回回调
- (void)leftNavBtnCallBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) leftNavTitleCallBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) rightNavBtnCallBack
{
    
}

-(void) setRightNavBarButton:(NSString *) rightItemStr
{
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightItemStr style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemPressed)];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary
                                      dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], NSFontAttributeName,nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

-(void) rightBarButtonItemPressed
{
    
}

-(void) setRightNavigationTextBtn:(NSString *)titleName
{
    UIButton *rightbutton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.tag = 10000;
    [rightbutton setTitle:titleName forState:UIControlStateNormal];
    rightbutton.titleLabel.font = TEXT16_FONT;
    NSString *deviceStr = [Tools deviceString];
    if([deviceStr rangeOfString:@"iPad"].location != NSNotFound)
    {
        rightbutton.frame=CGRectMake(self.view.frame.size.width-80 - 10,  (height -height *2/3)/2.0,80,height *2/3);
        
        rightbutton.titleLabel.font = TEXT14_FONT;
    }
    else if (IS_IPHONE4S || IS_IPHONE5)
    {
        rightbutton.frame=CGRectMake(self.view.frame.size.width-(height-20) - 20, 20 + (height -20 - (height-20))/2,(height-5),(height-20));
        
        rightbutton.titleLabel.font = TEXT14_FONT;
    }
    else
    {
        rightbutton.frame=CGRectMake(self.view.frame.size.width-(height-10) - 25, 20 + (height -20 - (height-20) *2/3)/2,(height),(height-20) *2/3);
        
        rightbutton.titleLabel.font = TEXT16_FONT;
    }

    [rightbutton setTitleColor:COLOR_TITLE_LIGHTGRAY forState:UIControlStateHighlighted];
    [rightbutton addTarget:self action:@selector(RightNavigationBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    //设置button文字居左
    rightbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:rightbutton];
}

-(void) RightNavigationBtnPressed
{
    
}

-(void) setLeftNavBarImageButton:(NSString *) leftImageName
{
    UIBarButtonItem * _navRightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:leftImageName] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarImageBtnItemPressed)];
    
    self.navigationItem.leftBarButtonItem = _navRightButton;
}

-(void) leftBarImageBtnItemPressed
{
    
}

-(void) setRightNavBarImageButton:(NSString *) rightImageName
{
    UIBarButtonItem * _navRightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:rightImageName] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarImageBtnItemPressed)];
    
    self.navigationItem.rightBarButtonItem = _navRightButton;
}

-(void) rightBarImageBtnItemPressed
{
    
}


#pragma mark - 跳转登录界面 
-(void) turnToLoginVCWithLeftNavButton
{

    
}

//获取所有子类
- (NSArray *)findAllOf:(Class)defaultClass

{
    
    int count = objc_getClassList(NULL, 0);
    
    if (count <= 0)
        
    {
        @throw@"Couldn't retrieve Obj-C class-list";
        
        return [NSArray arrayWithObject:defaultClass];
    }
    
    NSMutableArray *output = [NSMutableArray arrayWithObject:defaultClass];
    
    Class *classes = (Class *) malloc(sizeof(Class) * count);
    
    objc_getClassList(classes, count);
    
    for (int i = 0; i < count; ++i) {
        
        if (defaultClass == class_getSuperclass(classes[i]))//子类
            
        {
            
            [output addObject:classes[i]];
            
        }
        
    }
    
    free(classes);
    
    return [NSArray arrayWithArray:output];
}

#pragma mark - 暂无数据提示  仅label和button

-(void) addEmptyTipsViewWithTitle:(NSString *)aTitle IsShowButton:(BOOL) showBtn ButtonTitle:(NSString *)theBtnTitle
{
    UIView *backTipView = [self.view viewWithTag:6918];
    
    if (!backTipView)
    {
        backTipView = [[UIView alloc] init];
        
        backTipView.tag = 6918;
        
        UILabel *tipLabel = [[UILabel alloc] init];
        
        tipLabel.tag = 1988;
        
        UIButton *reCallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        reCallBtn.tag = 1999;
        
        [self.view addSubview:backTipView];
        
        [backTipView addSubview:tipLabel];
        
        if (showBtn)
        {
            [backTipView addSubview:reCallBtn];
        }
        
        WS(ws);
        
        [backTipView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.view.mas_left);
            make.right.equalTo(ws.view.mas_right);
            make.top.equalTo(ws.view.mas_top);
            make.bottom.equalTo(ws.view.mas_bottom);
        }];
        
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backTipView.mas_left);
            make.right.equalTo(backTipView.mas_right);
            make.centerY.equalTo(backTipView.mas_centerY).offset(-SCREEN_HEIGHT/12);
            make.height.equalTo(backTipView.mas_height).multipliedBy(0.3);
        }];
        
        if (showBtn)
        {
            [reCallBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backTipView.mas_centerX);
                make.top.equalTo(tipLabel.mas_bottom).offset(10);
                make.width.equalTo(backTipView.mas_width).multipliedBy(0.5);
                make.height.mas_equalTo(50);
            }];
            
            [reCallBtn setTitle:theBtnTitle forState:UIControlStateNormal];
            
            reCallBtn.backgroundColor = XLS_COLOR_MAIN_RED;
            
            reCallBtn.layer.cornerRadius = CORNERRADIUS_BUTTON;
            
            reCallBtn.clipsToBounds = YES;
        }
        
        tipLabel.text=aTitle;
        
        tipLabel.backgroundColor = [UIColor clearColor];
        
        tipLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        tipLabel.font = TEXT18_FONT;
        
        tipLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    backTipView.hidden = YES;
}

-(void) showEmptyTipView
{
    UIView *backTipView = [self.view viewWithTag:6918];
    
    backTipView.hidden = NO;
}

-(void) hideEmptyTipView
{
    UIView *backTipView = [self.view viewWithTag:6918];
    
    backTipView.hidden = YES;
}

@end
