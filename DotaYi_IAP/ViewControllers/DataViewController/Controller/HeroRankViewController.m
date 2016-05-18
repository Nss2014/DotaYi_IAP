//
//  HeroRankViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/18.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroRankViewController.h"
#import "JJCHeroTableViewCell.h"
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
    
    CoreSVPLoading(nil, nil);
    
    [Tools platform11PostRequest:DT_GETJJCRANK_URL ParamsBody:body target:self action:@selector(getHeroRankDataCallBack:)];
}

-(void) getHeroRankDataCallBack:(NSDictionary *) responseDic
{
    CoreSVPDismiss;
    
    NSLog(@"responseDic %@",responseDic);
    
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
    
    JJCHeroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[JJCHeroTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    DetailRankInfo *detailDataInfo = self.dataSourceArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.rankOrderLabel.text = detailDataInfo.HeroName;
    
    //英雄属性 0=力量 1=敏捷 2=智力
    
    NSString *heroProperty = @"";
    
    if ([detailDataInfo.HeroType isEqualToString:@"0"])
    {
        heroProperty = @"力量";
    }
    else if ([detailDataInfo.HeroType isEqualToString:@"1"])
    {
        heroProperty = @"敏捷";
    }
    else if ([detailDataInfo.HeroType isEqualToString:@"2"])
    {
        heroProperty = @"智力";
    }
    
    cell.rankUserNameLabel.text = heroProperty;
    
    cell.rankPointLabel.text = detailDataInfo.Ranking;
    
    cell.rankTotalPlaysLabel.text = detailDataInfo.UserName;
    
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
    
    rankOrderLabel.text = @"英雄名";
    
    rankOrderLabel.font = TEXT12_BOLD_FONT;
    
    rankOrderLabel.textColor = COLOR_TITLE_BLACK;
    
    rankOrderLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankOrderLabel];
    
    UILabel *rankUserNameLabel = [[UILabel alloc] init];
    
    rankUserNameLabel.text = @"英雄属性";
    
    rankUserNameLabel.font = TEXT12_BOLD_FONT;
    
    rankUserNameLabel.textColor = COLOR_TITLE_BLACK;
    
    rankUserNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankUserNameLabel];
    
    UILabel *rankPointLabel = [[UILabel alloc] init];
    
    rankPointLabel.text = @"英雄积分";
    
    rankPointLabel.font = TEXT12_BOLD_FONT;
    
    rankPointLabel.textColor = COLOR_TITLE_BLACK;
    
    rankPointLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankPointLabel];
    
    UILabel *rankTotalPlaysLabel = [[UILabel alloc] init];
    
    rankTotalPlaysLabel.text = @"用户名";
    
    rankTotalPlaysLabel.font = TEXT12_BOLD_FONT;
    
    rankTotalPlaysLabel.textColor = COLOR_TITLE_BLACK;
    
    rankTotalPlaysLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankTotalPlaysLabel];
    
    [rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackView.mas_left);
        make.top.equalTo(headerBackView.mas_top);
        make.bottom.equalTo(headerBackView.mas_bottom);
        make.width.equalTo(headerBackView.mas_width).multipliedBy(0.25);
    }];
    
    [rankUserNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rankOrderLabel.mas_right);
        make.top.equalTo(rankOrderLabel.mas_top);
        make.bottom.equalTo(rankOrderLabel.mas_bottom);
        make.width.equalTo(rankOrderLabel.mas_width);
    }];
    
    [rankPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rankUserNameLabel.mas_right);
        make.top.equalTo(rankUserNameLabel.mas_top);
        make.bottom.equalTo(rankUserNameLabel.mas_bottom);
        make.width.equalTo(rankUserNameLabel.mas_width);
    }];
    
    [rankTotalPlaysLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rankPointLabel.mas_right);
        make.top.equalTo(rankPointLabel.mas_top);
        make.bottom.equalTo(rankPointLabel.mas_bottom);
        make.width.equalTo(rankPointLabel.mas_width);
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

@end
