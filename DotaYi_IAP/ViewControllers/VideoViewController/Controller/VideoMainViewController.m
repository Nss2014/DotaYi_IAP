//
//  VideoMainViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/7/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "VideoMainViewController.h"
#import "CycleScrollView.h"
#import "OfficialBannerObj.h"
#import "CommonWebViewViewController.h"
#import "VideoBannerDataObj.h"
#import "LeftAnchorDataObj.h"
#import "AnchorVideoListTableViewCell.h"

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds

//打开抽屉动画参数初始值
#define AnimateDuration             0.2
#define MainViewOriginXFromValue    0
#define MainViewOriginXEndValue     kScreenWidth*0.6
#define MainViewMoveXMaxValue       ABS(MainViewOriginXEndValue - MainViewOriginXFromValue)
#define MainViewScaleYFromValue     1
#define MainViewScaleYEndValue      1
#define MainViewScaleMaxValue       ABS(MainViewScaleYEndValue - MainViewScaleYFromValue)
#define LeftViewOriginXFromValue    -kScreenWidth*0.6
#define LeftViewOriginXEndValue     0
#define LeftViewMoveXMaxValue       ABS(LeftViewOriginXEndValue - LeftViewOriginXFromValue)
#define LeftViewScaleFromValue      1
#define LeftViewScaleEndValue       1
#define LeftViewScaleMaxValue       ABS(LeftViewScaleEndValue - LeftViewScaleFromValue)

//广告图片轮播间隔时间
#define ADTIMER_DURATION 5

//表头高度
#define TABLE_HEADERHEIGHT 200

//广告图片高度
#define ADPICTURE_HEIGHT 200


@interface VideoMainViewController ()<ArtileLeftChannelDelegate>

@property (nonatomic,strong) NSMutableArray *dataSourceArray;//列表数据源

@property (nonatomic,strong) CycleScrollView * adScrollView;//广告

@end

@implementation VideoMainViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.adScrollView startAnimationTimer:ADTIMER_DURATION];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.adScrollView stopAnimationTimer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"视频";
    
    self.dataSourceArray = [NSMutableArray array];
    
    self.selectedChannelName = @"2009";
    
    self.selectedChannelId = @"1";
    
    self.selectedChannelImgUrl = @"/WTVupFiles/201401/10/small_316051665_f61af5b1773b483aaaa36e03955bea85.jpg";
    
    _distance = MainViewOriginXFromValue;
    
    _leftMenuView = _leftMenuViewController.view;
    _leftMenuView.frame = kScreenBounds;
    _leftMenuView.transform =CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity, LeftViewScaleFromValue, LeftViewScaleFromValue), CGAffineTransformTranslate(CGAffineTransformIdentity, LeftViewOriginXFromValue, 0));
    [self.view addSubview:_leftMenuView];
    
    _mainView = [[UIView alloc] initWithFrame:kScreenBounds];
    [self.view addSubview:_mainView];
    //    [_mainView addSubview:_homeViewController.view];
    
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [_mainView addGestureRecognizer:_panGesture];
    
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    [self setLeftNavigationBarButton];
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.viwTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    [_mainView addSubview:self.viwTable];
    
//    [self setTableHeaderView];
    
    [self addKSHeaderAndFooterRefresh];
    
    //获取左侧栏列表数据 并存储本地
    [self getAnchorListDataRequest];
    
    //获取banner数据
    [self getBannerDataRequest];
    
    //获取列表数据
    [self requestAnchorListWithChannelID:@"1"];
}

-(void) setTableHeaderView
{
    UIView *headerBackBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TABLE_HEADERHEIGHT)];
    
    headerBackBGView.backgroundColor = COLOR_VIEW_BG;
    
    //循环滚动广告栏初始化
    self.adScrollView = [[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADPICTURE_HEIGHT) animationDuration:5];
    
    [headerBackBGView addSubview:self.adScrollView];
    
    [self.adScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackBGView.mas_left);
        make.right.equalTo(headerBackBGView.mas_right);
        make.top.equalTo(headerBackBGView.mas_top);
        make.bottom.equalTo(headerBackBGView.mas_bottom);
    }];
    
    self.viwTable.tableHeaderView = headerBackBGView;
}

-(void) setAdPictureBanner:(NSArray *)sendArray
{
    [self setTableHeaderView];
    
    //循环滚动广告的数据源在此设置
    NSMutableArray *viewsArray = [@[] mutableCopy];
    //广告栏图片
    for (int i=0; i<sendArray.count; i++)
    {
        VideoBannerDataObj *bannerObj = sendArray[i];
        
        UIImageView *adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ADPICTURE_HEIGHT)];
        
        NSString *ecodeStr = [[NSString stringWithFormat:@"%@%@",VIDEOCOVER_DOMAIN,bannerObj.ImageUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [adImageView sd_setImageWithURL:[NSURL URLWithString:ecodeStr] placeholderImage:[UIImage imageNamed:DEFAULT_BANNER_PIC]];
        
        //播放图标
        UIImageView *playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        playImageView.center = CGPointMake(adImageView.center.x, adImageView.center.y);
        
        playImageView.image = [UIImage imageNamed:@"play_video_icon"];
        
        playImageView.alpha = 0.8;
        
        [adImageView addSubview:playImageView];
        
        //底部信息栏
        UIView *bottomBackView = [[UIView alloc] init];
        
        bottomBackView.backgroundColor = BLACK_COLOR;
        
        bottomBackView.alpha = 0.5;
        
        [adImageView addSubview:bottomBackView];
        
        UILabel *bottomAnnounceLabel = [[UILabel alloc] init];
        
        bottomAnnounceLabel.font = TEXT12_BOLD_FONT;
        
        bottomAnnounceLabel.textColor = WHITE_COLOR;
        
        bottomAnnounceLabel.text = bannerObj.VideoName;
        
        bottomAnnounceLabel.numberOfLines = 2;
        
        [adImageView addSubview:bottomAnnounceLabel];
        
        //发布日期
        UILabel *publishDateLabel = [[UILabel alloc] init];
        
        publishDateLabel.font = TEXT12_FONT;
        
        publishDateLabel.textColor = WHITE_COLOR;
        
        publishDateLabel.textAlignment = NSTextAlignmentRight;
        
        publishDateLabel.text = [NSString stringWithFormat:@"发布时间：%@",bannerObj.DateStringCode];
        
        [adImageView addSubview:publishDateLabel];
        
        [bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(adImageView.mas_left);
            make.right.equalTo(adImageView.mas_right);
            make.bottom.equalTo(adImageView.mas_bottom);
            make.height.mas_equalTo(35 + 20);
        }];
        
        [bottomAnnounceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(adImageView.mas_left).offset(PADDING_WIDTH);
            make.right.equalTo(adImageView.mas_right).offset(-150);
            make.height.mas_equalTo(35);
            make.top.equalTo(bottomBackView.mas_top);
        }];
        
        [publishDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bottomAnnounceLabel.mas_right).offset(PADDING_WIDTH);
            make.right.equalTo(adImageView.mas_right).offset(-PADDING_WIDTH);
            make.top.equalTo(bottomAnnounceLabel.mas_top);
            make.bottom.equalTo(bottomAnnounceLabel.mas_bottom);
        }];
        
        [viewsArray addObject:adImageView];;
    }
    
    WS(ws);
    
    self.adScrollView.totalPagesCount = ^NSInteger(void){
        
        return viewsArray.count;
    };
    
    self.adScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex){
        
        return viewsArray[pageIndex];
    };
    
    self.adScrollView.TapActionBlock = ^(NSInteger pageIndex){
        
        VideoBannerDataObj *bannerObj = sendArray[pageIndex];
        
        CommonWebViewViewController *webDetailView = [[CommonWebViewViewController alloc] init];
        
        webDetailView.webURLString = [NSString stringWithFormat:@"http://video.5211game.com/main/play.aspx?id=%@",bannerObj.VideoId];
        
        [ws presentViewController:webDetailView animated:YES completion:nil];
    };
}

- (instancetype)initWithLeftMenuViewController:(VideoLeftViewController *)leftVC
{
    self = [super init];
    if (self)
    {
        self.leftMenuViewController = leftVC;
        
        self.leftMenuViewController.delegate = self;
    }
    return self;
}

-(void) setLeftNavigationBarButton
{
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"video_left_menus"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonCallBack)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void) leftBarButtonCallBack
{
    if (!self.isLeftBarButtonSelected)
    {
        [self showLeftMenuView];
    }
    else
    {
        [self showMainView];
    }
    
    self.isLeftBarButtonSelected = !self.isLeftBarButtonSelected;
}

- (void)tap:(UITapGestureRecognizer *)recongizer
{
    self.isLeftBarButtonSelected = NO;
    
    [self showMainView];
}

- (void)pan:(UIPanGestureRecognizer *)recongnizer
{
    
    CGFloat moveX = [recongnizer translationInView:self.view].x;
    CGFloat truedistance = _distance + moveX;
    CGFloat percent = truedistance/MainViewMoveXMaxValue;
    if (truedistance >= 0 && truedistance <= MainViewMoveXMaxValue) {
        _mainView.transform = CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity, 1, MainViewScaleYFromValue-MainViewScaleMaxValue*percent), CGAffineTransformTranslate(CGAffineTransformIdentity, MainViewOriginXFromValue+truedistance, 0));
        _leftMenuView.transform = CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity, LeftViewScaleFromValue+LeftViewScaleMaxValue*percent, LeftViewScaleFromValue+LeftViewScaleMaxValue*percent), CGAffineTransformTranslate(CGAffineTransformIdentity, LeftViewOriginXFromValue+LeftViewMoveXMaxValue*percent, 0));
    }
    if (recongnizer.state == UIGestureRecognizerStateEnded)
    {
        if (truedistance <= MainViewMoveXMaxValue/2)
        {
            self.isLeftBarButtonSelected = NO;
            
            [self showMainView];
        }
        else
        {
            self.isLeftBarButtonSelected = YES;
            
            [self showLeftMenuView];
        }
    }
    
}

-(void) reloadToShowMainView
{
    self.isLeftBarButtonSelected = NO;
    
    [self showMainView];
}

- (void)showMainView {
    
    WS(ws);
    
    [UIView animateWithDuration:AnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _mainView.transform = CGAffineTransformIdentity;
        _leftMenuView.transform = CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity, LeftViewScaleFromValue, LeftViewScaleFromValue), CGAffineTransformTranslate(CGAffineTransformIdentity, LeftViewOriginXFromValue, 0));
    } completion:^(BOOL finished) {
        _distance = MainViewOriginXFromValue;
        [_mainView removeGestureRecognizer:_tap];
        
        ws.viwTable.scrollEnabled = YES;
        
        ws.adScrollView.userInteractionEnabled = YES;
    }];
}

- (void)showLeftMenuView {
    
    WS(ws);
    
    [UIView animateWithDuration:AnimateDuration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _mainView.transform = CGAffineTransformConcat(CGAffineTransformScale(CGAffineTransformIdentity, 1, MainViewScaleYEndValue), CGAffineTransformTranslate(CGAffineTransformIdentity, MainViewOriginXEndValue, 0));
        _leftMenuView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        _distance = MainViewOriginXEndValue;
        [_mainView addGestureRecognizer:_tap];
        
        ws.viwTable.scrollEnabled = NO;
        
        ws.adScrollView.userInteractionEnabled = NO;
    }];
}

//获取banner数据
-(void) getBannerDataRequest
{
    NSString *urlString = @"http://video.5211game.com/request/handler.ashx";
    
    NSString *body = @"action=InitVideoInfosIsTop&game=10001";
    
    [Tools platform11PostRequest:urlString ParamsBody:body target:self action:@selector(getBannerDataCallBack:)];
}

-(void) getBannerDataCallBack:(NSDictionary *) responseDic
{
    [self.viwTable footerFinishedLoading];
    
    [self.viwTable headerFinishedLoading];
    
    if (responseDic && ![responseDic isKindOfClass:[NSNull class]])
    {
        NSNumber *responseRet = responseDic[@"Code"];
        
        if ([responseRet isEqualToNumber:[NSNumber numberWithInteger:8]])
        {
            //请求成功
            //将一个字典数组转成模型数组
            NSArray *getBannerDataArray = [VideoBannerDataObj mj_objectArrayWithKeyValuesArray:responseDic[@"DataModel"]];
            
            if (getBannerDataArray.count)
            {
                [self setAdPictureBanner:getBannerDataArray];
            }
        }
    }
    else
    {
        //CoreSVPError(@"请求失败，请重试", nil);
    }
}

#pragma mark - ArtileLeftChannelDelegate

-(void) didSelectChannelWithChannleID:(NSString *) theChannelID  AndChannelName:(NSString *) theChannelName AndChannelImageUrl:(NSString *) theChannelImgUrl
{
    //更新频道文章
    
    NSString *tempSendID = theChannelID;
    
    if (theChannelID == nil || [theChannelID isKindOfClass:[NSNull class]])
    {
        tempSendID = @"";
    }
    
    self.isFooterRefresh = NO;
    
    self.currentMainPage = 0;
    
    [self.viwTable setContentOffset:CGPointMake(0, TABLE_HEADERHEIGHT) animated:YES];
    
    //根据id请求列表
    [self requestAnchorListWithChannelID:tempSendID];
    
    //频道名赋值
    self.selectedChannelName = theChannelName;
    
    self.selectedChannelId = theChannelID;
    
    self.selectedChannelImgUrl = theChannelImgUrl;
    
    self.isLeftBarButtonSelected = NO;
    
    [self showMainView];
    
}

//获取左侧栏主播列表
-(void) getAnchorListDataRequest
{
    NSString *urlString = @"http://video.5211game.com/request/handler.ashx";
    
    NSString *body = @"action=InitTagInfos&game=10001";
    
    [Tools platform11PostRequest:urlString ParamsBody:body target:self action:@selector(getListDataCallBack:)];
}

-(void) getListDataCallBack:(NSDictionary *) responseDic
{
    if (responseDic && ![responseDic isKindOfClass:[NSNull class]])
    {
        NSNumber *responseRet = responseDic[@"Code"];
        
        if ([responseRet isEqualToNumber:[NSNumber numberWithInteger:2]])
        {
            if (responseDic[@"DataModel"] && ![responseDic[@"DataModel"] isKindOfClass:[NSNull class]])
            {
                //请求成功
                //将一个字典数组转成模型数组
                NSArray *getAnchorDataArray = [LeftAnchorDataObj mj_objectArrayWithKeyValuesArray:responseDic[@"DataModel"][@"Left"]];
                
                [self writeChannelListDataArrayToLocal:getAnchorDataArray];
                
                [self.leftMenuViewController reloadData];
            }
        }
    }
    else
    {
        //CoreSVPError(@"请求失败，请重试", nil);
    }
}


//获取某个主播的视频列表
-(void) requestAnchorListWithChannelID:(NSString *) sendId
{
    NSString *urlString = @"http://video.5211game.com/request/handler.ashx";
    
    NSString *body = [NSString stringWithFormat:@"action=InitVideoInfos_RelationId_Related&relation=%@&type=0&index=%ld&size=10",
                      sendId,
                      self.currentMainPage + 1
                      ];
    
//    NSString *body = @"action=InitVideoInfos_RelationId_Related&relation=1&type=0&index=1&size=10";
    
    NSLog(@"body %@",body);
    
    [Tools platform11PostRequest:urlString ParamsBody:body target:self action:@selector(getAnchorVideoListCallBack:)];
}

-(void) getAnchorVideoListCallBack:(NSDictionary *) responseDic
{
    [self.viwTable footerFinishedLoading];
    
    [self.viwTable headerFinishedLoading];
    
    if (responseDic && ![responseDic isKindOfClass:[NSNull class]])
    {
        NSNumber *responseRet = responseDic[@"Code"];
        
        NSLog(@"responseRet %@",responseRet);
        
        if ([responseRet isEqualToNumber:[NSNumber numberWithInteger:3]])
        {
            if (responseDic[@"DataModel"] && ![responseDic[@"DataModel"] isKindOfClass:[NSNull class]])
            {
                //请求成功
                //将一个字典数组转成模型数组
                NSArray *getAnchorDataArray = [AnchorVideoListData mj_objectArrayWithKeyValuesArray:responseDic[@"DataModel"][@"List"]];
                
                
                NSLog(@"getAnchorDataArray %@",getAnchorDataArray);
                
                if (!self.isFooterRefresh)
                {
                    [self.dataSourceArray removeAllObjects];
                }
                
                [self.dataSourceArray addObjectsFromArray:getAnchorDataArray];
                
                [self.viwTable reloadData];
            }
            
        }
    }
    else
    {
        //CoreSVPError(@"请求失败，请重试", nil);
    }
}

#pragma mark - 频道数据存储  写入&获取

-(void) writeChannelListDataArrayToLocal:(NSArray *)sendChannelArray
{
    //使用MJExtension 模型数组转换字典数组
    NSArray *channelDicArray = [LeftAnchorDataObj mj_keyValuesArrayWithObjectArray:sendChannelArray];
    
    [[HP_Application sharedApplication].store putObject:channelDicArray
                                                 withId:DB_CHANNELLIST_DATA
                                              intoTable:DB_CHANNELLIST_DATA];
}

#pragma mark 列表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    AnchorVideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[AnchorVideoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self setTableViewLeftAlignment:cell];
    
    AnchorVideoListData *videoObj = self.dataSourceArray[indexPath.row];
    
    NSLog(@"rankingObj %@  author %@",videoObj.VideoName,videoObj.RelationName);
    
    cell.AH_titleLabel.text = videoObj.VideoName;
    
    cell.AH_postTimeLabel.text = [NSString stringWithFormat:@"发布时间：%@",videoObj.DateStringCode];
    
    [cell.AH_leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",VIDEOCOVER_DOMAIN,videoObj.ImageUrl]] placeholderImage:[UIImage imageNamed:DEFAULT_HOTLIST_PIC]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    headerBackView.backgroundColor = HRBACKVIEW_COLOR;
    
    UIImageView *anchorHeadImageView = [[UIImageView alloc] init];
    
    [anchorHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",VIDEOCOVER_DOMAIN,self.selectedChannelImgUrl]] placeholderImage:[UIImage imageNamed:@"hot_anchor_icon"]];
    
    [headerBackView addSubview:anchorHeadImageView];
    
    UILabel *frontMsgLabel = [[UILabel alloc] init];
    
    frontMsgLabel.text = self.selectedChannelName;
    
    frontMsgLabel.font = TEXT12_BOLD_FONT;
    
    [headerBackView addSubview:frontMsgLabel];
    
    [anchorHeadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackView.mas_left).offset(PADDING_WIDTH);
        make.top.equalTo(headerBackView.mas_top).offset(PADDING_WIDTH/2);
        make.bottom.equalTo(headerBackView.mas_bottom).offset(-PADDING_WIDTH/2);
        make.width.equalTo(anchorHeadImageView.mas_height);
    }];
    
    [frontMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(anchorHeadImageView.mas_right).offset(PADDING_WIDTH);
        make.bottom.equalTo(anchorHeadImageView.mas_bottom);
        make.right.equalTo(headerBackView.mas_right).offset(-PADDING_WIDTH);
        make.height.mas_equalTo(20);
    }];
    
    return headerBackView;
}

#pragma mark -  点击行响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnchorVideoListData *videoObj = self.dataSourceArray[indexPath.row];
    
    CommonWebViewViewController *commonVC = [[CommonWebViewViewController alloc]init];
    
    commonVC.webURLString = [NSString stringWithFormat:@"http://video.5211game.com/main/play.aspx?relation=%@&id=%@",videoObj.RelationId,videoObj.VideoId];
    
    //使用 presentViewController 跳转
    [self presentViewController:commonVC animated:YES completion:nil];
}

#pragma mark - KSRefreshViewDelegate
- (void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:self.viwTable.header])
    {
        //下拉请求
        
        self.isFooterRefresh = NO;
        
        self.currentMainPage = 0;
        
        //获取左侧栏列表数据 并存储本地
        [self getAnchorListDataRequest];
        
        //获取banner数据
        [self getBannerDataRequest];
        
        //获取列表数据
        [self requestAnchorListWithChannelID:self.selectedChannelId];
        
        return;
    }
    
    if ([view isEqual:self.viwTable.footer])
    {
        
        self.isFooterRefresh = YES;
        
        self.currentMainPage++;
        
        //获取列表数据
        [self requestAnchorListWithChannelID:self.selectedChannelId];
    }
}

@end
