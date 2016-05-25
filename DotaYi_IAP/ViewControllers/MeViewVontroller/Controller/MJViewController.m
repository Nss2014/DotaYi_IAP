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

@interface MJViewController ()<ARSegmentControllerDelegate>

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
}

-(void) addTableViewHeader
{
    //竞技场积分和走势图
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    
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
            
            self.threeGridView1.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"MingJiang"]];
            
            self.threeGridView1.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"Sum"]];
            
            self.threeGridView1.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"P_Win"]];
            
            self.threeGridView2.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"Win"]];
            
            self.threeGridView2.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"Lost"]];
            
            self.threeGridView2.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",responseDic[@"mjInfos"][@"OfflineFormat"]];
            
            //得到名将擅长英雄列表
            
            //将一个字典数组转成模型数组
            NSArray *getMjGoodHeroArray = [MJGoodAtHeroModel mj_objectArrayWithKeyValuesArray:responseDic[@"mjheroInfos"]];
            
            [self.goodHeroListArray removeAllObjects];
            
            [self.goodHeroListArray addObjectsFromArray:getMjGoodHeroArray];   
        }
    }
    else
    {
        CoreSVPError(@"请求失败，请重试", nil);
    }
}


@end
