//
//  TTViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "TTViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "CustomGridPointView.h"
#import "JJCTopDataModel.h"

@interface TTViewController ()<ARSegmentControllerDelegate,BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (nonatomic,strong) ThreeGridView *threeGridView1;

@property (nonatomic,strong) ThreeGridView *threeGridView2;

@property (nonatomic,strong) UIView *gridSepLineView;

@property (nonatomic,strong) BEMSimpleLineGraphView *myGraph;//走势图

@property (strong, nonatomic) NSMutableArray *arrayOfValues;//走势图数据源

@property (nonatomic,strong) JJCTopDataModel *topDataModel;//顶部数据

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    [self getListDataRequest];
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"天梯";
}

-(void) reloadCurrentTableView
{
    
}

-(void) initData
{
    self.arrayOfValues = [NSMutableArray arrayWithObjects:@"10",@"100",@"1",@"122",@"30",@"80", nil];
}

-(void) initUI
{
    self.view.backgroundColor = WHITE_COLOR;
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.viwTable.frame = CGRectMake(0, SEGMENT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - SEGMENT_HEIGHT - TABBAR_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    [self addTableViewHeader];
}

-(void) addTableViewHeader
{
    //竞技场积分和走势图
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120 + SCREEN_WIDTH * 0.62)];
    
    self.threeGridView1 = [[ThreeGridView alloc] init];
    
    self.threeGridView1.customGridView1.gridTopValueLabel.text = @"0";
    
    self.threeGridView1.customGridView1.gridBottomNameLabel.text = @"天梯积分";
    
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
    self.view.tintColor = color;
    self.navigationController.navigationBar.tintColor = color;
    
    self.myGraph.animationGraphStyle = BEMLineAnimationFade;
    
    [headerBgView addSubview:self.myGraph];
    
    WS(ws);
    
    [self.threeGridView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(headerBgView.mas_top).offset(PADDING_WIDTH);
        make.height.mas_equalTo(50);
    }];
    
    [self.threeGridView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.threeGridView1.mas_left);
        make.right.equalTo(ws.threeGridView1.mas_right);
        make.top.equalTo(ws.threeGridView1.mas_bottom);
        make.height.equalTo(ws.threeGridView1.mas_height);
    }];
    
    [self.gridSepLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(ws.threeGridView2.mas_top);
        make.height.mas_equalTo(PIXL1_AUTO);
    }];
    
    [self.myGraph mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(ws.threeGridView2.mas_bottom).offset(PADDING_WIDTH);
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"CellPortrait";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    UILabel *rankOrderLabel = [[UILabel alloc] init];
    
    rankOrderLabel.text = @"擅长英雄";
    
    rankOrderLabel.font = TEXT14_BOLD_FONT;
    
    rankOrderLabel.textColor = COLOR_TITLE_BLACK;
    
    [headerBackView addSubview:rankOrderLabel];
    
    [rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackView.mas_left).offset(PADDING_WIDTH);
        make.top.equalTo(headerBackView.mas_top);
        make.bottom.equalTo(headerBackView.mas_bottom);
        make.right.equalTo(headerBackView.mas_right).offset(-PADDING_WIDTH);
    }];
    
    return headerBackView;
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
    if (responseDic && ![responseDic isKindOfClass:[NSNull class]])
    {
        NSNumber *responseRet = responseDic[@"error"];
        
        if ([responseRet isEqualToNumber:[NSNumber numberWithInteger:0]])
        {
            //请求成功
            self.topDataModel = [[JJCTopDataModel alloc] init];
            
            self.threeGridView1.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"rating"]];
            
            self.threeGridView1.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"ttInfos"][@"Total"]];
            
            self.threeGridView1.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"ttInfos"][@"R_Win"]];
            
            self.threeGridView2.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"ttInfos"][@"Win"]];
            
            self.threeGridView2.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"ttInfos"][@"Lost"]];
            
            self.threeGridView2.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"ttInfos"][@"OfflineFormat"]];

        }
    }
    else
    {
        CoreSVPError(@"请求失败，请重试", nil);
    }
}


@end
