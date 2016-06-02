//
//  Platform11HeroDetailViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/27.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "Platform11HeroDetailViewController.h"
#import "BEMSimpleLineGraphView.h"
#import "CustomGridPointView.h"

@interface Platform11HeroDetailViewController ()<BEMSimpleLineGraphDataSource, BEMSimpleLineGraphDelegate>

@property (nonatomic,strong) ThreeGridView *threeGridView1;

@property (nonatomic,strong) ThreeGridView *threeGridView2;

@property (nonatomic,strong) BEMSimpleLineGraphView *myGraph;//走势图

@property (strong, nonatomic) NSMutableArray *arrayOfValues;//走势图数据源

@end

@implementation Platform11HeroDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    [self getTrendAndHeroData];
}

-(void) initData
{
    self.arrayOfValues = [NSMutableArray array];
}

-(void) initUI
{
    self.view.backgroundColor = WHITE_COLOR;
    
    self.navigationItem.title = self.sendHeroModel.heroname;
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.viwTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    [self addTableViewHeader];
    
    [self addKSHeaderRefresh];
}

-(void) addTableViewHeader
{
    //竞技场积分和走势图
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130 + SCREEN_WIDTH * 0.62 + HERODETAIL_IMGHEIGHT + 50)];
    
    //头像
    UIImageView *heroHeaderImgView = [[UIImageView alloc] init];
    
    heroHeaderImgView.layer.cornerRadius = HERODETAIL_IMGHEIGHT/2;
    
    heroHeaderImgView.clipsToBounds = YES;
    
    [heroHeaderImgView sd_setImageWithURL:[NSURL URLWithString:[Tools getPlatForm11HeroHeadImgWithHeroId:self.sendHeroModel.heroId]] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    [headerBgView addSubview:heroHeaderImgView];
    
    self.threeGridView1 = [[ThreeGridView alloc] init];
    
    self.threeGridView1.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.score];
    
    self.threeGridView1.customGridView1.gridBottomNameLabel.text = @"英雄积分";
    
    self.threeGridView1.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.total];
    
    self.threeGridView1.customGridView2.gridBottomNameLabel.text = @"对战局数";
    
    self.threeGridView1.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.win];
    
    self.threeGridView1.customGridView3.gridBottomNameLabel.text = @"胜利局数";
    
    [headerBgView addSubview:self.threeGridView1];
    
    self.threeGridView2 = [[ThreeGridView alloc] init];
    
    self.threeGridView2.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.p_win];
    
    self.threeGridView2.customGridView1.gridBottomNameLabel.text = @"胜率";
    
    self.threeGridView2.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.herokill];
    
    self.threeGridView2.customGridView2.gridBottomNameLabel.text = @"击杀英雄";
    
    self.threeGridView2.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.roshan];
    
    self.threeGridView2.customGridView3.gridBottomNameLabel.text = @"夺肉山盾";
    
    [headerBgView addSubview:self.threeGridView2];
    
    UILabel *jjcTrendLabel = [[UILabel alloc] init];
    
    jjcTrendLabel.text = @"英雄积分曲线";
    
    jjcTrendLabel.font = TEXT14_BOLD_FONT;
    
    jjcTrendLabel.textColor = COLOR_TITLE_BLACK;
    
    CGSize trendSize = [Tools getAdaptionSizeWithText:@"英雄积分曲线" AndFont:TEXT14_BOLD_FONT andLabelHeight:30];
    
    [headerBgView addSubview:jjcTrendLabel];
    
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
    
    [heroHeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerBgView.mas_centerX);
        make.top.equalTo(headerBgView.mas_top).offset(PADDING_WIDTH);
        make.height.mas_equalTo(HERODETAIL_IMGHEIGHT);
        make.width.equalTo(heroHeaderImgView.mas_height);
    }];
    
    [self.threeGridView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(heroHeaderImgView.mas_bottom).offset(PADDING_WIDTH);
        make.height.mas_equalTo(50);
    }];
    
    [self.threeGridView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.threeGridView1.mas_left);
        make.right.equalTo(ws.threeGridView1.mas_right);
        make.top.equalTo(ws.threeGridView1.mas_bottom).offset(PADDING_WIDTH);
        make.height.equalTo(ws.threeGridView1.mas_height);
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
    
    [self.myGraph mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(jjcTrendLabel.mas_bottom).offset(PADDING_WIDTH/2);
        make.height.mas_equalTo(SCREEN_WIDTH * 0.62);
    }];
    
    self.viwTable.tableHeaderView = headerBgView;
}

-(void) getTrendAndHeroData
{
    NSString *tTypeString;
    
    if (self.isJJCType)
    {
        tTypeString = @"10032";
    }
    else
    {
        tTypeString = @"10001";
    }
    
    NSString *urlString = @"http://score.5211game.com/RecordCenter/request/record";
    
    NSString *body = [NSString stringWithFormat:@"method=getscore&uid=%@&heroId=%@&t=%@",[Tools strForKey:LOGIN_RESPONSE_USERID],self.sendHeroModel.heroId,tTypeString];
    
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
            NSArray *getTrendArray = responseDic[@"data"];
            
            [self.arrayOfValues removeAllObjects];
            
            [self.arrayOfValues addObjectsFromArray:getTrendArray];
            
            WS(ws);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [ws.myGraph reloadGraph];
            });
            
        }
    }
    else
    {
        
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

#pragma mark - KSRefreshViewDelegate
- (void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:self.viwTable.header])
    {
        //获取走势图数据及擅长英雄数据
        [self getTrendAndHeroData];
        
        return;
    }
}


@end
