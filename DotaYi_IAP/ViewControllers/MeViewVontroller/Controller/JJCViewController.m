//
//  JJCViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "JJCViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "CustomGridPointView.h"
#import "JJCTopDataModel.h"
#import "MJGoodAtHeroModel.h"
#import "GoodAtHeroTableViewCell.h"
#import "Platform11HeroDetailViewController.h"

@interface JJCViewController ()<ARSegmentControllerDelegate,BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate,KSRefreshViewDelegate>

@property (nonatomic,strong) ThreeGridView *threeGridView1;

@property (nonatomic,strong) ThreeGridView *threeGridView2;

@property (nonatomic,strong) UIView *gridSepLineView;

@property (nonatomic,strong) BEMSimpleLineGraphView *myGraph;//走势图

@property (strong, nonatomic) NSMutableArray *arrayOfValues;//走势图数据源

@property (nonatomic,strong) JJCTopDataModel *topDataModel;//顶部数据

@property (nonatomic,strong) NSMutableArray *goodHeroDataArray;//擅长英雄数据源

@end

@implementation JJCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    //获取积分数据
    [self getListDataRequest];
    
    //获取走势图数据及擅长英雄数据
    [self getTrendAndHeroData];
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"竞技场";
}

-(void) reloadCurrentTableView
{
    
}

-(void) initData
{
    self.arrayOfValues = [NSMutableArray array];
    
    self.goodHeroDataArray = [NSMutableArray array];
}

-(void) initUI
{
    self.view.backgroundColor = WHITE_COLOR;
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.viwTable.frame = CGRectMake(0, SEGMENT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - SEGMENT_HEIGHT - TABBAR_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    [self addTableViewHeader];
    
    self.viwTable.header = [[KSDefaultHeadRefreshView alloc] initWithDelegate:self];
}

-(void) addTableViewHeader
{
    //竞技场积分和走势图
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130 + SCREEN_WIDTH * 0.62 + 30 + 40)];
    
    UIImageView *topHeadImgView = [[UIImageView alloc] init];
    
    [topHeadImgView sd_setImageWithURL:[NSURL URLWithString:@"http://static.7fgame.com/11General/UserIcon/0.jpg"] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    topHeadImgView.layer.cornerRadius = 10.0;
    
    topHeadImgView.clipsToBounds = YES;
    
    [headerBgView addSubview:topHeadImgView];
    
    UILabel *topUserNameLabel = [[UILabel alloc] init];
    
    topUserNameLabel.text = [Tools strForKey:LOGIN_RESPONSE_USERNAME];
    
    topUserNameLabel.font = TEXT14_BOLD_FONT;
    
    topUserNameLabel.textColor = XLS_COLOR_MAIN_GREEN;
    
    [headerBgView addSubview:topUserNameLabel];
    
    self.threeGridView1 = [[ThreeGridView alloc] init];
    
    self.threeGridView1.customGridView1.gridTopValueLabel.text = @"0";
    
    self.threeGridView1.customGridView1.gridBottomNameLabel.text = @"竞技场积分";
    
    self.threeGridView1.customGridView2.gridTopValueLabel.text = @"0";
    
    self.threeGridView1.customGridView2.gridBottomNameLabel.text = @"排名";
    
    self.threeGridView1.customGridView3.gridTopValueLabel.text = @"0";
    
    self.threeGridView1.customGridView3.gridBottomNameLabel.text = @"胜率";
    
    [headerBgView addSubview:self.threeGridView1];
    
    self.threeGridView2 = [[ThreeGridView alloc] init];
    
    self.threeGridView2.customGridView1.gridTopValueLabel.text = @"0";
    
    self.threeGridView2.customGridView1.gridBottomNameLabel.text = @"总场次";
    
    self.threeGridView2.customGridView2.gridTopValueLabel.text = @"0";
    
    self.threeGridView2.customGridView2.gridBottomNameLabel.text = @"胜利场次";
    
    self.threeGridView2.customGridView3.gridTopValueLabel.text = @"0";
    
    self.threeGridView2.customGridView3.gridBottomNameLabel.text = @"失败场次";
    
    [headerBgView addSubview:self.threeGridView2];
    
    self.gridSepLineView = [[UIView alloc] init];
    
    self.gridSepLineView.backgroundColor = CLEAR_COLOR;
    
    [headerBgView addSubview:self.gridSepLineView];
    
    UILabel *jjcTrendLabel = [[UILabel alloc] init];
    
    jjcTrendLabel.text = @"竞技场积分曲线";
    
    jjcTrendLabel.font = TEXT14_BOLD_FONT;
    
    jjcTrendLabel.textColor = COLOR_TITLE_BLACK;
    
    CGSize trendSize = [Tools getAdaptionSizeWithText:@"竞技场积分曲线" AndFont:TEXT14_BOLD_FONT andLabelHeight:30];
    
    [headerBgView addSubview:jjcTrendLabel];
    
    UILabel *detailJJCTrendLabel = [[UILabel alloc] init];
    
    detailJJCTrendLabel.text = @"（显示近3个月竞技场游戏记录）";
    
    detailJJCTrendLabel.font = TEXT12_FONT;
    
    detailJJCTrendLabel.textColor = COLOR_TITLE_LIGHTGRAY;
    
    [headerBgView addSubview:detailJJCTrendLabel];
    
    UIView *signColorTrendView = [[UIView alloc] init];
    
    signColorTrendView.backgroundColor = XLS_COLOR_MAIN_GREEN;
    
    signColorTrendView.layer.cornerRadius = SECTION_ROUNDHEIGHT/2;
    
    signColorTrendView.clipsToBounds = YES;
    
    [headerBgView addSubview:signColorTrendView];
    
    
    self.myGraph = [[BEMSimpleLineGraphView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.62)];
    
    self.myGraph.dataSource = self;
    
    self.myGraph.delegate = self;
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = {
        1.0, 1.0, 1.0, 1.0,
        1.0, 1.0, 1.0, 0.0
    };
    
    // Apply the gradient to the bottom portion of the graph
    self.myGraph.gradientBottom = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    // Enable and disable various graph properties and axis displays
    self.myGraph.enableTouchReport = YES;
    self.myGraph.enablePopUpReport = YES;
    self.myGraph.enableYAxisLabel = YES;
    self.myGraph.autoScaleYAxis = YES;
    self.myGraph.alwaysDisplayDots = NO;
    self.myGraph.enableReferenceXAxisLines = YES;
    self.myGraph.enableReferenceYAxisLines = YES;
    self.myGraph.enableReferenceAxisFrame = YES;

    // Draw an average line
    self.myGraph.averageLine.enableAverageLine = YES;
    self.myGraph.averageLine.alpha = 0.6;
    self.myGraph.averageLine.color = [UIColor darkGrayColor];
    self.myGraph.averageLine.width = 2.5;
    self.myGraph.averageLine.dashPattern = @[@(2),@(2)];
    
    // Set the graph's animation style to draw, fade, or none
    self.myGraph.animationGraphStyle = BEMLineAnimationDraw;
    
    // Dash the y reference lines
    self.myGraph.lineDashPatternForReferenceYAxisLines = @[@(2),@(2)];
    
    // Show the y axis values with this format string
    self.myGraph.formatStringForValues = @"%.1f";
    
    UIColor *color = [UIColor colorWithRed:31.0/255.0 green:187.0/255.0 blue:166.0/255.0 alpha:1.0];
    self.myGraph.colorTop = color;
    self.myGraph.colorBottom = color;
    self.myGraph.backgroundColor = color;
    
    self.myGraph.animationGraphStyle = BEMLineAnimationFade;
    
    [headerBgView addSubview:self.myGraph];
    
    WS(ws);
    
    [topHeadImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left).offset(PADDING_WIDTH);
        make.top.equalTo(headerBgView.mas_top).offset(PADDING_WIDTH + PADDING_WIDTH/2);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [topUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topHeadImgView.mas_right).offset(PADDING_WIDTH/2);
        make.right.equalTo(headerBgView.mas_right).offset(-PADDING_WIDTH);
        make.top.equalTo(headerBgView.mas_top).offset(PADDING_WIDTH);
        make.height.mas_equalTo(30);
    }];
    
    [self.threeGridView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(topUserNameLabel.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.threeGridView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.threeGridView1.mas_left);
        make.right.equalTo(ws.threeGridView1.mas_right);
        make.top.equalTo(ws.threeGridView1.mas_bottom).offset(PADDING_WIDTH);
        make.height.equalTo(ws.threeGridView1.mas_height);
    }];
    
    [self.gridSepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(ws.threeGridView2.mas_top);
        make.height.mas_equalTo(PIXL1_AUTO);
    }];
    
    [jjcTrendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left).offset(PADDING_WIDTH + SECTION_ROUNDHEIGHT + 8);
        make.top.equalTo(ws.threeGridView2.mas_bottom).offset(PADDING_WIDTH/2);
        make.width.mas_equalTo(trendSize.width);
        make.height.mas_equalTo(30);
    }];
    
    [signColorTrendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(jjcTrendLabel.mas_left).offset(-4);
        make.centerY.equalTo(jjcTrendLabel.mas_centerY);
        make.width.mas_equalTo(SECTION_ROUNDHEIGHT);
        make.height.mas_equalTo(SECTION_ROUNDHEIGHT);
    }];
    
    [detailJJCTrendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(jjcTrendLabel.mas_right).offset(PADDING_WIDTH/2);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(jjcTrendLabel.mas_top);
        make.height.equalTo(jjcTrendLabel.mas_height);
    }];
    
    [self.myGraph mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(detailJJCTrendLabel.mas_bottom).offset(PADDING_WIDTH/2);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.62);
    }];
    
    self.viwTable.tableHeaderView = headerBgView;
}

#pragma mark 列表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodHeroDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"CellPortrait";
    
    GoodAtHeroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell)
    {
        cell = [[GoodAtHeroTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MJGoodAtHeroModel *getHeroDataModel = self.goodHeroDataArray[indexPath.row];
    
    NSLog(@"getPlatForm11HeroHeadImgWithHeroId %@",[Tools getPlatForm11HeroHeadImgWithHeroId:getHeroDataModel.heroId]);
    
    [cell.goodHeroHeadImageView sd_setImageWithURL:[NSURL URLWithString:[Tools getPlatForm11HeroHeadImgWithHeroId:getHeroDataModel.heroId]] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    cell.goodHeroNameLabel.text = getHeroDataModel.heroname;
    
    cell.goodHeroTotalUseLabel.text = [NSString stringWithFormat:@"%@",getHeroDataModel.total];
    
    cell.goodHeroPointLabel.text = [NSString stringWithFormat:@"%@",getHeroDataModel.score];
    
    cell.goodHeroWinChanceLabel.text = [NSString stringWithFormat:@"%@",getHeroDataModel.p_win];
    
    NSString *newNormalV = [Tools getStringWithRemovedCharString:getHeroDataModel.p_win andChar:@"%"];
    
    CGFloat persentage = (ceil([newNormalV longLongValue]*100) / 100)/100;
    
    [cell.goodHeroWinChanceProgressView setProgress:persentage animated:NO];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    UILabel *rankOrderLabel = [[UILabel alloc] init];
    
    rankOrderLabel.text = @"擅长英雄";
    
    rankOrderLabel.font = TEXT14_BOLD_FONT;
    
    rankOrderLabel.textColor = COLOR_TITLE_BLACK;
    
    [headerBackView addSubview:rankOrderLabel];
    
    UIView *signColorTrendView = [[UIView alloc] init];
    
    signColorTrendView.backgroundColor = XLS_COLOR_MAIN_GREEN;
    
    signColorTrendView.layer.cornerRadius = SECTION_ROUNDHEIGHT/2;
    
    signColorTrendView.clipsToBounds = YES;
    
    [headerBackView addSubview:signColorTrendView];
    
    UILabel *directHeroImgLabel = [[UILabel alloc] init];
    
    directHeroImgLabel.font = TEXT12_BOLD_FONT;
    
    directHeroImgLabel.text = @"英雄";
    
    directHeroImgLabel.textColor = COLOR_TITLE_BLACK;
    
    directHeroImgLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:directHeroImgLabel];
    
    
    UILabel *directHeroNameLabel = [[UILabel alloc] init];
    
    directHeroNameLabel.font = TEXT12_BOLD_FONT;
    
    directHeroNameLabel.text = @"英雄名";
    
    directHeroNameLabel.textColor = COLOR_TITLE_BLACK;
    
    directHeroNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:directHeroNameLabel];
    
    UILabel *directHeroWinChanceLabel = [[UILabel alloc] init];
    
    directHeroWinChanceLabel.font = TEXT12_BOLD_FONT;
    
    directHeroWinChanceLabel.text = @"胜率";
    
    directHeroWinChanceLabel.textColor = COLOR_TITLE_BLACK;
    
    directHeroWinChanceLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:directHeroWinChanceLabel];
    
    UILabel *directHeroPointLabel = [[UILabel alloc] init];
    
    directHeroPointLabel.font = TEXT12_BOLD_FONT;
    
    directHeroPointLabel.text = @"积分";
    
    directHeroPointLabel.textColor = COLOR_TITLE_BLACK;
    
    directHeroPointLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:directHeroPointLabel];
    
    [rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackView.mas_left).offset(PADDING_WIDTH + SECTION_ROUNDHEIGHT + 8);
        make.top.equalTo(headerBackView.mas_top);
        make.height.mas_equalTo(30);
        make.right.equalTo(headerBackView.mas_right).offset(-PADDING_WIDTH);
    }];
    
    [signColorTrendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rankOrderLabel.mas_left).offset(-4);
        make.centerY.equalTo(rankOrderLabel.mas_centerY);
        make.width.mas_equalTo(SECTION_ROUNDHEIGHT);
        make.height.mas_equalTo(SECTION_ROUNDHEIGHT);
    }];
    
    [directHeroImgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackView.mas_left).offset(PADDING_WIDTH);
        make.top.equalTo(rankOrderLabel.mas_bottom);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    [directHeroNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(directHeroImgLabel.mas_right).offset(PADDING_WIDTH);
        make.top.equalTo(directHeroImgLabel.mas_top);
        make.bottom.equalTo(directHeroImgLabel.mas_bottom);
        make.width.mas_equalTo((SCREEN_WIDTH - 50 - 40)/5 + PADDING_WIDTH);
    }];
    
    [directHeroWinChanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(directHeroNameLabel.mas_right).offset(PADDING_WIDTH);
        make.top.equalTo(directHeroNameLabel.mas_top);
        make.bottom.equalTo(directHeroNameLabel.mas_bottom);
        make.width.mas_equalTo((SCREEN_WIDTH - 50 - 40) * 3/5);
    }];
    
    [directHeroPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(directHeroWinChanceLabel.mas_right).offset(PADDING_WIDTH);
        make.top.equalTo(directHeroWinChanceLabel.mas_top);
        make.bottom.equalTo(directHeroWinChanceLabel.mas_bottom);
        make.width.mas_equalTo((SCREEN_WIDTH - 50 - 40)/5 - PADDING_WIDTH);
    }];
    
    return headerBackView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJGoodAtHeroModel *getHeroDataModel = self.goodHeroDataArray[indexPath.row];
    
    Platform11HeroDetailViewController *detailHeroVC = [[Platform11HeroDetailViewController alloc] init];
    
    detailHeroVC.sendHeroModel = getHeroDataModel;
    
    detailHeroVC.isJJCType = YES;
    
    [self.parentViewController setHidesBottomBarWhenPushed:YES];
    
    [self.parentViewController.navigationController pushViewController:detailHeroVC animated:YES];
}

//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 50;
    
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
    } else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}


#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    
    NSLog(@"arrayOfValues %@",self.arrayOfValues);
    
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}

#pragma mark - SimpleLineGraph Delegate

- (NSInteger)numberOfGapsBetweenLabelsOnLineGraph:(BEMSimpleLineGraphView *)graph {
    
    return 0;
}

-(void) getListDataRequest
{
    NSString *urlString = @"http://score.5211game.com/RecordCenter/request/record";
    
    NSString *body = [NSString stringWithFormat:@"method=getrecord&u=%@&t=10001",[Tools strForKey:LOGIN_RESPONSE_USERID]];
    
    [Tools platform11PostRequest:urlString ParamsBody:body target:self action:@selector(getListDataCallBack:)];
}

-(void) getListDataCallBack:(NSDictionary *) responseDic
{
    [self.viwTable headerFinishedLoading];
    
    if (responseDic && ![responseDic isKindOfClass:[NSNull class]])
    {
        NSNumber *responseRet = responseDic[@"error"];
        
        if ([responseRet isEqualToNumber:[NSNumber numberWithInteger:0]])
        {
            //请求成功
            self.topDataModel = [[JJCTopDataModel alloc] init];
            
            self.topDataModel.topRankString = [NSString stringWithFormat:@"%@",responseDic[@"jjcrank"]];
            
            self.topDataModel.topPointString = [NSString stringWithFormat:@"%@",responseDic[@"jjcRating"]];
            
            self.topDataModel.topTotalPlayString = [NSString stringWithFormat:@"%@",responseDic[@"jjcInfos"][@"Total"]];
            
            self.topDataModel.topWinChanceString = [NSString stringWithFormat:@"%@",responseDic[@"jjcInfos"][@"P_Win"]];
            
            self.topDataModel.topWinPlayString = [NSString stringWithFormat:@"%@",responseDic[@"jjcInfos"][@"Win"]];
            
            self.topDataModel.topLosePlayString = [NSString stringWithFormat:@"%@",responseDic[@"jjcInfos"][@"Lost"]];
            
            self.threeGridView1.customGridView1.gridTopValueLabel.text = self.topDataModel.topPointString;
            
            self.threeGridView1.customGridView2.gridTopValueLabel.text = self.topDataModel.topRankString;
            
            self.threeGridView1.customGridView3.gridTopValueLabel.text = self.topDataModel.topWinChanceString;
            
            self.threeGridView2.customGridView1.gridTopValueLabel.text = self.topDataModel.topTotalPlayString;
            
            self.threeGridView2.customGridView2.gridTopValueLabel.text = self.topDataModel.topWinPlayString;
            
            self.threeGridView2.customGridView3.gridTopValueLabel.text = self.topDataModel.topLosePlayString;
        }
    }
    else
    {
        //CoreSVPError(@"请求失败，请重试", nil);
    }
}

-(void) getTrendAndHeroData
{
    NSString *urlString = @"http://score.5211game.com/RecordCenter/request/record";
    
    NSString *body = [NSString stringWithFormat:@"method=ladderheros&u=%@&t=10032",[Tools strForKey:LOGIN_RESPONSE_USERID]];
    
    [Tools platform11PostRequest:urlString ParamsBody:body target:self action:@selector(getTrendHeroDataCallBack:)];
}

-(void) getTrendHeroDataCallBack:(NSDictionary *) responseDic
{
    [self.viwTable headerFinishedLoading];
    
    if (responseDic && ![responseDic isKindOfClass:[NSNull class]])
    {
        NSNumber *responseRet = responseDic[@"error"];
        
        if ([responseRet isEqualToNumber:[NSNumber numberWithInteger:0]])
        {
            //请求成功
            NSArray *getTrendArray = responseDic[@"heroRoadInfos"];
            
            [self.arrayOfValues removeAllObjects];
            
            [self.arrayOfValues addObjectsFromArray:getTrendArray];
            
            //将一个字典数组转成模型数组
            NSArray *getJJCGoodHeroArray = [MJGoodAtHeroModel mj_objectArrayWithKeyValuesArray:responseDic[@"ratingHeros"]];
            
            //排序
            NSArray *getSortedArray = [Tools changeArray:getJJCGoodHeroArray orderWithKey:@"score" ascending:NO];
            
            [self.goodHeroDataArray removeAllObjects];
            
            [self.goodHeroDataArray addObjectsFromArray:getSortedArray];
            
            WS(ws);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [ws.myGraph reloadGraph];
                
                [ws.viwTable reloadData];
            });
            
        }
    }
    else
    {
        
    }
}

#pragma mark - KSRefreshViewDelegate
- (void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:self.viwTable.header])
    {
        //获取积分数据
        [self getListDataRequest];
        
        //获取走势图数据及擅长英雄数据
        [self getTrendAndHeroData];
        
        return;
    }
}


//5.17号下午18:00 获取的Cookie
//uToken=CF003EBCE506CB81FF46583AABD756C775A948C8B2A4E4D0FCB1877E9F0C3427B4A5913A2011655870C89362B5EFCC0891E367BD7A9335847443F7F0898923A9276DBA5CFF2CFCDCE7FA3AAE61DA7AFD7CE4C5A977AB0B0E7D9FB554BEC9B1AAABD6C9A0BE1D6FD24887CF6AD2995AA876D052D6713826863A127774A877266BC4ABB1B12E0B259BDE049F4EFF4EA6A505D7E4456EE285E6071F9EF1A1C08099ED1319C01F0AA5EEDC5B84FC0B4CA58164592BDD00CE484B092AB19C56A8825068CC7373F8EF831F49C6E7FFD749FA7BA7F1DC3CFB261629180C069AB34147849E7AA28FB1237939C4011F2E1BE5E11C;

@end
