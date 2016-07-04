//
//  VideoLeftViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/7/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "VideoLeftViewController.h"
#import "ArticleLeftTableCell.h"
#import "ChannelInfoObj.h"
#import "LeftAnchorDataObj.h"

@interface VideoLeftViewController ()

@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@end

@implementation VideoLeftViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
    [self setTableHeaderView];
}

-(void) initData
{
    self.dataSourceArray = [NSMutableArray array];
}

-(void) initUI
{
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.viwTable.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.6, SCREEN_HEIGHT - NAV_HEIGHT - TABBAR_HEIGHT);
    
    self.viwTable.backgroundColor = XLS_COLOR_MAIN_GRAY;
    
    self.view.backgroundColor = CLEAR_COLOR;
}

-(void) setTableHeaderView
{
    UIView *headerBackBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.6, 60)];
    
    headerBackBGView.backgroundColor = CLEAR_COLOR;
    
    //hot_video_icon
    UIImageView *hotImageView = [[UIImageView alloc] init];
    
    hotImageView.image = [UIImage imageNamed:@"hot_video_icon"];
    
    [headerBackBGView addSubview:hotImageView];
    
    UILabel *DP_nameLabel = [[UILabel alloc] init];
    
    DP_nameLabel.textColor = WHITE_COLOR;
    
    DP_nameLabel.font = TEXT16_BOLD_FONT;
    
    DP_nameLabel.text = @"热门主播";
    
    [headerBackBGView addSubview:DP_nameLabel];
    
    [hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackBGView.mas_left).offset(PADDING_WIDTH);
        make.centerY.equalTo(headerBackBGView.mas_centerY);
        make.width.mas_equalTo(24);
        make.height.equalTo(hotImageView.mas_width);
    }];
    
    [DP_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotImageView.mas_right).offset(PADDING_WIDTH/2);
        make.right.equalTo(headerBackBGView.mas_right).offset(-PADDING_WIDTH);
        make.bottom.equalTo(headerBackBGView.mas_bottom);
        make.top.equalTo(headerBackBGView.mas_top);
    }];

    self.viwTable.tableHeaderView = headerBackBGView;
}

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
                
                [self.viwTable reloadData];
            }
            
        }
    }
    else
    {
        //CoreSVPError(@"请求失败，请重试", nil);
    }
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
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    ArticleLeftTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[ArticleLeftTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.backgroundColor = ARTICLE_CELL_LIGHTGRAY;
    
    LeftAnchorDataObj *channelInfo = self.dataSourceArray[indexPath.row];
    
    cell.AL_channelNameLabel.text = channelInfo.TagName;
    
    [cell.AL_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",VIDEOCOVER_DOMAIN,channelInfo.AvatarUrl]] placeholderImage:[UIImage imageNamed:@"hot_anchor_icon"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.6;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.6, 1.6)];
    
    UIView *headerTopLineView = [[UIView alloc] init];
    
    headerTopLineView.backgroundColor = ARTICLESEP_DEEP_COLOR;
    
    [headerBackView addSubview:headerTopLineView];
    
    UIView *headerBottomLineView = [[UIView alloc] init];
    
    headerBottomLineView.backgroundColor = ARTICLESEP_TINT_COLOR;
    
    [headerBackView addSubview:headerBottomLineView];
    
    [headerTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBackView.mas_left);
        make.right.equalTo(headerBackView.mas_right);
        make.top.equalTo(headerBackView.mas_top);
        make.height.mas_equalTo(0.8);
    }];
    
    [headerBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerTopLineView.mas_left);
        make.right.equalTo(headerTopLineView.mas_right);
        make.top.equalTo(headerTopLineView.mas_bottom);
        make.height.equalTo(headerTopLineView.mas_height);
    }];
    
    return headerBackView;
}

#pragma mark -  点击行响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftAnchorDataObj *channelInfo = self.dataSourceArray[indexPath.row];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectChannelWithChannleID:AndChannelName:AndChannelImageUrl:)])
    {
        NSString *tempSendChannelId = [NSString stringWithFormat:@"%@",channelInfo.TagId];
        
        if (indexPath.row == 0)
        {
            tempSendChannelId = @"1";
        }
        
        [self.delegate didSelectChannelWithChannleID:tempSendChannelId AndChannelName:channelInfo.TagName AndChannelImageUrl:channelInfo.AvatarUrl];
    }
}

-(void) reloadData
{
    [self.dataSourceArray removeAllObjects];
    
    //取出本地存储的频道数组
    NSArray *getLocalChannelArray = [self getChannelListDataArray];
    
    if(getLocalChannelArray  &&  (NSNull*)getLocalChannelArray != [NSNull null])
    {
        WS(ws);
        
        [getLocalChannelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LeftAnchorDataObj *detailObj = (LeftAnchorDataObj *)obj;
            
            [ws.dataSourceArray addObject:detailObj];
        }];
        
    }
    
    [self.viwTable reloadData];
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

-(NSArray *) getChannelListDataArray
{
    NSArray *channelDicArray = [[HP_Application sharedApplication].store getObjectById:DB_CHANNELLIST_DATA fromTable:DB_CHANNELLIST_DATA];
    
    NSArray *modelArray = [LeftAnchorDataObj mj_objectArrayWithKeyValuesArray:channelDicArray];
    
    return modelArray;
}

@end
