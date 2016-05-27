//
//  MJViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "MJViewController.h"
#import "CustomGridPointView.h"
#import "JJCTopDataModel.h"
#import "MJGoodAtHeroModel.h"
#import "GoodAtHeroTableViewCell.h"

@interface MJViewController ()<ARSegmentControllerDelegate,KSRefreshViewDelegate>

@property (nonatomic,strong) ThreeGridView *threeGridView1;

@property (nonatomic,strong) ThreeGridView *threeGridView2;

@property (nonatomic,strong) UIView *gridSepLineView;

@property (nonatomic,strong) NSMutableArray *goodHeroListArray;

@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_COLOR;
    
    [self initData];
    
    [self initUI];
    
    [self getListDataRequest];
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"名将";
}

-(void) reloadCurrentTableView
{
    
}

-(void) initData
{
    self.goodHeroListArray = [NSMutableArray array];
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
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130 + 30)];
    
    UIImageView *topHeadImgView = [[UIImageView alloc] init];
    
    [topHeadImgView sd_setImageWithURL:[NSURL URLWithString:@"http://static.7fgame.com/11General/UserIcon/0.jpg"] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    topHeadImgView.layer.cornerRadius = 10.0;
    
    topHeadImgView.clipsToBounds = YES;
    
    [headerBgView addSubview:topHeadImgView];
    
    UILabel *topUserNameLabel = [[UILabel alloc] init];
    
    topUserNameLabel.text = [Tools strForKey:LOGIN_RESPONSE_USERNAME];
    
    topUserNameLabel.font = TEXT14_BOLD_FONT;
    
    topUserNameLabel.textColor = COLOR_TITLE_BLACK;
    
    [headerBgView addSubview:topUserNameLabel];
    
    self.threeGridView1 = [[ThreeGridView alloc] init];
    
    self.threeGridView1.customGridView1.gridTopValueLabel.text = @"0";
    
    self.threeGridView1.customGridView1.gridBottomNameLabel.text = @"名将等级";
    
    self.threeGridView1.customGridView2.gridTopValueLabel.text = @"0";
    
    self.threeGridView1.customGridView2.gridBottomNameLabel.text = @"总场次";
    
    self.threeGridView1.customGridView3.gridTopValueLabel.text = @"0";
    
    self.threeGridView1.customGridView3.gridBottomNameLabel.text = @"胜率";
    
    [headerBgView addSubview:self.threeGridView1];
    
    self.threeGridView2 = [[ThreeGridView alloc] init];
    
    self.threeGridView2.customGridView1.gridTopValueLabel.text = @"0";
    
    self.threeGridView2.customGridView1.gridBottomNameLabel.text = @"胜利场次";
    
    self.threeGridView2.customGridView2.gridTopValueLabel.text = @"0";
    
    self.threeGridView2.customGridView2.gridBottomNameLabel.text = @"失败场次";
    
    self.threeGridView2.customGridView3.gridTopValueLabel.text = @"0";
    
    self.threeGridView2.customGridView3.gridBottomNameLabel.text = @"逃跑率";
    
    [headerBgView addSubview:self.threeGridView2];
    
    self.gridSepLineView = [[UIView alloc] init];
    
    self.gridSepLineView.backgroundColor = CLEAR_COLOR;
    
    [headerBgView addSubview:self.gridSepLineView];
    
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
    
    self.viwTable.tableHeaderView = headerBgView;
}

#pragma mark 列表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.goodHeroListArray.count;
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
    
    MJGoodAtHeroModel *getHeroDataModel = self.goodHeroListArray[indexPath.row];
    
    [cell.goodHeroHeadImageView sd_setImageWithURL:[NSURL URLWithString:[Tools getPlatForm11HeroHeadImgWithHeroId:getHeroDataModel.heroId]] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    cell.goodHeroNameLabel.text = getHeroDataModel.heroname;
    
    cell.goodHeroTotalUseLabel.text = [NSString stringWithFormat:@"%@",getHeroDataModel.total];
    
    cell.goodHeroPointLabel.text = [NSString stringWithFormat:@"%@",getHeroDataModel.cscore];
    
    cell.goodHeroWinChanceLabel.text = getHeroDataModel.p_win;
    
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
            
            self.threeGridView1.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"MingJiang"]];
            
            self.threeGridView1.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"Sum"]];
            
            self.threeGridView1.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"P_Win"]];
            
            self.threeGridView2.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"Win"]];
            
            self.threeGridView2.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"Lost"]];
            
            self.threeGridView2.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"OfflineFormat"]];
            
            //得到名将擅长英雄列表
            
            //将一个字典数组转成模型数组
            NSArray *getMjGoodHeroArray = [MJGoodAtHeroModel mj_objectArrayWithKeyValuesArray:responseDic[@"mjheroInfos"]];
            
            NSLog(@"getMjGoodHeroArray %ld",getMjGoodHeroArray.count);
            
            //排序
            NSArray *getSortedArray = [Tools changeArray:getMjGoodHeroArray orderWithKey:@"cscore" ascending:NO];
            
            [self.goodHeroListArray removeAllObjects];
            
            [self.goodHeroListArray addObjectsFromArray:getSortedArray];
    
            WS(ws);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [ws.viwTable reloadData];
            });
        }
    }
    else
    {
        CoreSVPError(@"请求失败，请重试", nil);
    }
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

#pragma mark - KSRefreshViewDelegate
- (void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:self.viwTable.header])
    {
        //获取积分数据
        [self getListDataRequest];
        
        return;
    }
}

@end
