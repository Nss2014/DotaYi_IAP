//
//  HeroRankViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/18.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroRankViewController.h"
#import "HeroRankTableViewCell.h"
#import "JJCRankDataModel.h"

@interface HeroRankViewController ()<ARSegmentControllerDelegate>

@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@end

@implementation HeroRankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_COLOR;
    
    [self getHeroRankRequest];
    
    [self initData];
    
    [self initUI];
    
    [self setTableHeaderView];
    
    [self addKSHeaderRefresh];
}

-(void) setTableHeaderView
{
    UILabel *tipsFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, 30)];
    
    tipsFromLabel.numberOfLines = 0;
    
    tipsFromLabel.textAlignment = NSTextAlignmentCenter;
    
    tipsFromLabel.text = @"11对战平台英雄排行榜";
    
    tipsFromLabel.font = TEXT12_FONT;
    
    tipsFromLabel.textColor = COLOR_TITLE_LIGHTGRAY;
    
    [self.viwTable setTableHeaderView:tipsFromLabel];
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"英雄排行榜";
}

-(void) getHeroRankRequest
{
    //DT_GETJJCRANK_URL
    NSString *body = @"action=HerosUserDatas";
    
    [Tools platform11PostRequest:DT_GETJJCRANK_URL ParamsBody:body target:self action:@selector(getHeroRankDataCallBack:)];
}

-(void) getHeroRankDataCallBack:(NSDictionary *) responseDic
{
    NSLog(@"responseDic %@",responseDic);
    
    [self.viwTable headerFinishedLoading];
    
    NSString *responseMsg = responseDic[@"Message"];
    
    if ([responseMsg isEqualToString:@"Complete!"])
    {
        NSArray *getDataArr = responseDic[@"DataModel"];
        
        WS(ws);
        
        [getDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSDictionary *getDetailDic = (NSDictionary *) obj;
            
            DetailRankInfo *getDetailInfo = [DetailRankInfo mj_objectWithKeyValues:getDetailDic];
            
            [ws.dataSourceArray addObject:getDetailInfo];
            
        }];
    }
    else
    {
        [self addEmptyTipsViewWithTitle:@"暂无数据" IsShowButton:NO ButtonTitle:nil];
    }
    
    [self.viwTable reloadData];
}


-(void) initData
{
    self.dataSourceArray = [NSMutableArray array];
}

-(void) initUI
{
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.viwTable.frame = CGRectMake(0, SEGMENT_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT - SEGMENT_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    HeroRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[HeroRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    DetailRankInfo *detailDataInfo = self.dataSourceArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.heroRankHeadImageView sd_setImageWithURL:[NSURL URLWithString:[Tools getPlatForm11HeroHeadImgWithHeroId:detailDataInfo.HeroHashCode]] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    cell.heroRankHeroNameLabel.text = detailDataInfo.HeroName;
    
    cell.heroRankHeroPointLabel.text = detailDataInfo.Ranking;
    
    cell.heroRankUserNameLabel.text = detailDataInfo.UserName;
    
    if (indexPath.row % 2 == 1)
    {
        cell.backgroundColor = SEPRATELINE_GRAYCOLOR;
    }
    else
    {
        cell.backgroundColor = WHITE_COLOR;
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
    
    rankOrderLabel.text = @"英雄";
    
    rankOrderLabel.font = TEXT12_BOLD_FONT;
    
    rankOrderLabel.textColor = COLOR_TITLE_BLACK;
    
    rankOrderLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankOrderLabel];
    
    UILabel *rankUserNameLabel = [[UILabel alloc] init];
    
    rankUserNameLabel.text = @"英雄名";
    
    rankUserNameLabel.font = TEXT12_BOLD_FONT;
    
    rankUserNameLabel.textColor = COLOR_TITLE_BLACK;
    
    rankUserNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankUserNameLabel];
    
    UILabel *rankTotalPlaysLabel = [[UILabel alloc] init];
    
    rankTotalPlaysLabel.text = @"英雄积分";
    
    rankTotalPlaysLabel.font = TEXT12_BOLD_FONT;
    
    rankTotalPlaysLabel.textColor = COLOR_TITLE_BLACK;
    
    rankTotalPlaysLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankTotalPlaysLabel];
    
    UILabel *rankWinningLabel = [[UILabel alloc] init];
    
    rankWinningLabel.text = @"用户名";
    
    rankWinningLabel.font = TEXT12_BOLD_FONT;
    
    rankWinningLabel.textColor = COLOR_TITLE_BLACK;
    
    rankWinningLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankWinningLabel];
    
    [rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackView.mas_left);
        make.top.equalTo(headerBackView.mas_top);
        make.bottom.equalTo(headerBackView.mas_bottom);
        make.width.mas_equalTo(60);
    }];
    
    [rankUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rankOrderLabel.mas_right);
        make.top.equalTo(rankOrderLabel.mas_top);
        make.bottom.equalTo(rankOrderLabel.mas_bottom);
        make.width.mas_equalTo((SCREEN_WIDTH - 60) * 0.35);
    }];
    
    [rankTotalPlaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rankUserNameLabel.mas_right);
        make.top.equalTo(rankUserNameLabel.mas_top);
        make.bottom.equalTo(rankUserNameLabel.mas_bottom);
        make.width.mas_equalTo((SCREEN_WIDTH - 60) * 0.25);
    }];
    
    [rankWinningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rankTotalPlaysLabel.mas_right);
        make.top.equalTo(rankTotalPlaysLabel.mas_top);
        make.bottom.equalTo(rankTotalPlaysLabel.mas_bottom);
        make.width.mas_equalTo((SCREEN_WIDTH - 60) * 0.4);
    }];
    
    return headerBackView;
}

#pragma mark -  点击行响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//uitableview处理section的不悬浮，禁止section停留的方法，主要是这段代码
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 30;
    
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
        //下拉刷新
        [self getHeroRankRequest];
        
        return;
    }
}


@end
