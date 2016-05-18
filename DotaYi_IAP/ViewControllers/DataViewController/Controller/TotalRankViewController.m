//
//  TotalRankViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/18.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "TotalRankViewController.h"
#import "JJCRankTableViewCell.h"
#import "JJCRankDataModel.h"


@interface TotalRankViewController ()<ARSegmentControllerDelegate>

@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@end

@implementation TotalRankViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = WHITE_COLOR;
    
    [self getTotalRankRequest];
    
    [self initData];
    
    [self initUI];
}

#pragma mark ARSegmentControllerDelegate

-(NSString *)segmentTitle
{
    return @"总排行榜";
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

-(void) getTotalRankRequest
{
    //竞技场总排行
    NSString *body = @"action=UserRankDatas";
    
    CoreSVPLoading(nil, nil);
    
    [Tools platform11PostRequest:DT_GETJJCRANK_URL ParamsBody:body target:self action:@selector(getTotalRankListDataCallBack:)];
}

-(void) getTotalRankListDataCallBack:(NSDictionary *) responseDic
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
    
    JJCRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[JJCRankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    DetailRankInfo *detailDataInfo = self.dataSourceArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.rankOrderLabel.text = detailDataInfo.Rank;
    
    cell.rankUserNameLabel.text = detailDataInfo.UserName;
    
    cell.rankPointLabel.text = detailDataInfo.Ranking;
    
    //从ExtendProperties中提取总场数和胜率
    NSString *totalPlaysStr = [self getTotalPlaysFromExtendProperties:detailDataInfo.ExtendProperties];
    
    NSString *winningStr = [self getWinningStrFromExtendProperties:detailDataInfo.ExtendProperties];
    
    cell.rankWinningProbabilityLabel.text = winningStr;
    
    cell.rankTotalPlaysLabel.text = totalPlaysStr;
    
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
    
    rankOrderLabel.text = @"排名";
    
    rankOrderLabel.font = TEXT12_BOLD_FONT;
    
    rankOrderLabel.textColor = COLOR_TITLE_BLACK;
    
    rankOrderLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankOrderLabel];
    
    UILabel *rankUserNameLabel = [[UILabel alloc] init];
    
    rankUserNameLabel.text = @"用户名";
    
    rankUserNameLabel.font = TEXT12_BOLD_FONT;
    
    rankUserNameLabel.textColor = COLOR_TITLE_BLACK;
    
    rankUserNameLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankUserNameLabel];
    
    UILabel *rankPointLabel = [[UILabel alloc] init];
    
    rankPointLabel.text = @"竞技场积分";
    
    rankPointLabel.font = TEXT12_BOLD_FONT;
    
    rankPointLabel.textColor = COLOR_TITLE_BLACK;
    
    rankPointLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankPointLabel];
    
    UILabel *rankTotalPlaysLabel = [[UILabel alloc] init];
    
    rankTotalPlaysLabel.text = @"总场次";
    
    rankTotalPlaysLabel.font = TEXT12_BOLD_FONT;
    
    rankTotalPlaysLabel.textColor = COLOR_TITLE_BLACK;
    
    rankTotalPlaysLabel.textAlignment = NSTextAlignmentCenter;

    [headerBackView addSubview:rankTotalPlaysLabel];
    
    UILabel *rankWinningLabel = [[UILabel alloc] init];
    
    rankWinningLabel.text = @"胜率";
    
    rankWinningLabel.font = TEXT12_BOLD_FONT;
    
    rankWinningLabel.textColor = COLOR_TITLE_BLACK;
    
    rankWinningLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerBackView addSubview:rankWinningLabel];
    
    [rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackView.mas_left);
        make.top.equalTo(headerBackView.mas_top);
        make.bottom.equalTo(headerBackView.mas_bottom);
        make.width.equalTo(headerBackView.mas_width).multipliedBy(0.2);
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
    
    [rankWinningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rankTotalPlaysLabel.mas_right);
        make.top.equalTo(rankTotalPlaysLabel.mas_top);
        make.bottom.equalTo(rankTotalPlaysLabel.mas_bottom);
        make.width.equalTo(rankTotalPlaysLabel.mas_width);
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

-(NSString *) getTotalPlaysFromExtendProperties:(NSString *) sendStr
{
    NSArray *sepArr1 = [sendStr componentsSeparatedByString:@"{\"win\":"];
    
    NSString *winPlays = @"";
    
    NSString *losePlays = @"";
    
    if (sepArr1.count > 1)
    {
        NSArray *sepArr2 = [sepArr1[1] componentsSeparatedByString:@",\"lost\":"];
        
        if (sepArr2.count)
        {
            //得到胜利场数
            winPlays = sepArr2[0];
     
            if (sepArr2.count > 1)
            {
                NSArray *sepArr3 = [sepArr2[1] componentsSeparatedByString:@",\"win_rate\":\""];
                
                if (sepArr3.count)
                {
                    losePlays = sepArr3[0];
                    
                    return [NSString stringWithFormat:@"%ld",[winPlays integerValue] + [losePlays integerValue]];
                }
            }
        }
    }
    
    return @"";
}

-(NSString *) getWinningStrFromExtendProperties:(NSString *) sendStr
{
    NSArray *sepArr1 = [sendStr componentsSeparatedByString:@"\"win_rate\":\""];
    
    if (sepArr1.count > 1)
    {
        NSArray *sepArr2 = [sepArr1[1] componentsSeparatedByString:@"\",\"float\""];
        
        if (sepArr2.count)
        {
            return sepArr2[0];
        }
    }
    
    return @"";
}

@end
