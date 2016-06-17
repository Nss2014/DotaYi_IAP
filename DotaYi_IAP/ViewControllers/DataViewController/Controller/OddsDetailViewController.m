//
//  OddsDetailViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/11.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "OddsDetailViewController.h"
#import "OddsDetailDataModel.h"
#import "ASHorizontalScrollView.h"
#import "OddsViewController.h"

#define kCellHeight 60

@interface OddsDetailViewController ()

@property (nonatomic,strong) OddsDetailDataModel *oddsDetailModel;

@property (nonatomic,strong) UIImageView *heroBgView;

@property (nonatomic,strong) UIImageView *heroHeaderImgView;

@property (nonatomic,strong) UILabel *heroIntroduceLabel;

@end

@implementation OddsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    WS(ws);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [ws initData];
        
        [ws getOddsDetailData];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [ws initUI];

        });
    });
    
}

-(void) getOddsDetailData
{
    if (self.sendOddId != nil && ![self.sendOddId isKindOfClass:[NSNull class]])
    {
        //取出数据库数据
        NSDictionary *getValueDic = [[HP_Application sharedApplication].store getObjectById:self.sendOddId fromTable:DB_ODDSDETAIL];
        
        //字典转模型
        OddsDetailDataModel *getOddsModel = [OddsDetailDataModel mj_objectWithKeyValues:getValueDic];
        
        NSLog(@"getOddsModel %@",getOddsModel);
        
        if (getOddsModel != nil && ![getOddsModel isKindOfClass:[NSNull class]])
        {
            self.oddsDetailModel = getOddsModel;
        }
        else
        {
            if (self.sendOddLink != nil && ![self.sendOddLink isKindOfClass:[NSNull class]])
            {
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.sendOddLink]];
                
                TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
                
                OddsDetailDataModel *saveModel = [[OddsDetailDataModel alloc] init];
                
                saveModel.oddsDetailLink = self.sendOddLink;
                
                //获取物品图片及简介
                
                NSArray *oddsElements = [xpathParser searchWithXPathQuery:@"//div[@class='part6']"];
                
                for (TFHppleElement *tfElement in oddsElements)
                {
                    //物品图片
                    NSString *getOddPicString = [Tools getHtmlValueWithXPathParser:tfElement XPathQuery:@"//div[@class='lpic']" DetailXPathQuery:@"//img" DetailKey:@"src"];
                    
                    NSLog(@"getOddPicString %@",getOddPicString);
                    
                    saveModel.oddsDetailImg = getOddPicString;
                    
                    //名称
                    NSString *getOddNameString = [Tools getHtmlValueWithXPathParser:tfElement XPathQuery:@"//i[@class='bt']" DetailXPathQuery:nil DetailKey:nil];
                    
                    NSLog(@"getOddNameString %@",getOddNameString);
                    
                    saveModel.oddsDetailName = getOddNameString;
                    
                    //介绍
                    
                    NSArray *getIntroduceArr = [Tools getHtmlValueArrayWithXPathParser:tfElement XPathQuery:@"//div[@class='scontent']"DetailXPathQuery:@"//font" DetailKey:nil];

                    NSString *tempIntroducePriceString = @"";
                    
                    NSString *tempIntroduceBuyPlaceString = @"";
                    
                    NSString *tempIntroduceOtherString = @"";
                    
                    NSString *signChangeStr = @"";
                    
                    for (int i=0; i<getIntroduceArr.count; i++)
                    {
                        if (getIntroduceArr.count > 1)
                        {
                            tempIntroducePriceString = [NSString stringWithFormat:@"%@：%@",getIntroduceArr[0],getIntroduceArr[1]];
                        }
                        
                        if (getIntroduceArr.count > 3)
                        {
                            tempIntroduceBuyPlaceString = [NSString stringWithFormat:@"%@：%@",getIntroduceArr[2],getIntroduceArr[3]];
                        }
                        
                        if (getIntroduceArr.count > 4)
                        {
                            if (i > 3)
                            {
                                if (i > 4)
                                {
                                    signChangeStr = @"\r\n\n";
                                }
                                
                                tempIntroduceOtherString = [tempIntroduceOtherString stringByAppendingFormat:@"%@%@",[Tools exchangeNullToEmptyString:signChangeStr],[Tools exchangeNullToEmptyString:getIntroduceArr[i]]];
                            }
                        }
                    }
                    
                    NSString *finalGetIntroduceStr = [NSString stringWithFormat:@"%@\r\n\n%@\r\n\n%@",tempIntroducePriceString,tempIntroduceBuyPlaceString,tempIntroduceOtherString];
                    
                    NSLog(@"finalGetIntroduceStr %@",finalGetIntroduceStr);
                    
                    saveModel.oddsDetailIntroduce = finalGetIntroduceStr;
                }
                
                //该物品是否有 “合成需要” 字段
                NSArray *composeElements = [xpathParser searchWithXPathQuery:@"//div[@class='part7 clearfix']"];
                
                for (TFHppleElement *tfElement in composeElements)
                {
                    NSString *getComposeString = [Tools getHtmlValueWithXPathParser:tfElement XPathQuery:@"//li[@class='current']" DetailXPathQuery:@"//a" DetailKey:@"id"];
                    
                    if ([getComposeString isEqualToString:@"relation_9"])
                    {
                        NSArray *secondNeedElements = [xpathParser searchWithXPathQuery:@"//div[@id='tab1']"];
                        
                        for (TFHppleElement *thirdElement in secondNeedElements)
                        {
                            
                            NSArray *thirdNeedElements = [thirdElement searchWithXPathQuery:@"//td[@align='center']"];
                            
                            NSLog(@"thirdNeedElements");
                            
                            for (TFHppleElement *finalElement in thirdNeedElements)
                            {
                                NSLog(@"finalElement");
                                //link
                                NSArray *tempNeedLinkArray = [Tools getHtmlValueArrayWithXPathParser:finalElement XPathQuery:@"//td[@class='noh']" DetailXPathQuery:@"//a" DetailKey:@"href"];
                                
                                //img
                                NSArray *tempNeedImgArray = [Tools getHtmlValueArrayWithXPathParser:finalElement XPathQuery:@"//td[@class='noh']" DetailXPathQuery:@"//img" DetailKey:@"src"];
                                
                                for (int i=0; i<tempNeedLinkArray.count/2; i++)
                                {
                                    NSString *needLinkStr = tempNeedLinkArray[i];
                                    
                                    NSString *needImgStr;
                                    
                                    if (i < tempNeedImgArray.count)
                                    {
                                        needImgStr = tempNeedImgArray[i];
                                    }
                                    
                                    DetailOddNeedObj *detailNeedObj = [[DetailOddNeedObj alloc] init];
                                    
                                    detailNeedObj.needOddLink = needLinkStr;
                                    
                                    detailNeedObj.needOddImg = needImgStr;
                                    
                                    [saveModel.oddsDetailNeedArray addObject:detailNeedObj];
                                }
                                
                            }
                            
                        }
                    }
                }
                
                self.oddsDetailModel = saveModel;
                
                //存入数据库
                //使用MJExtension 模型转换字典
                NSDictionary *saveOddDic = saveModel.mj_keyValues;
                
                NSLog(@"saveOddDic %@",saveOddDic);
                
                if (saveOddDic != nil && ![saveOddDic isKindOfClass:[NSNull class]])
                {
                    [[HP_Application sharedApplication].store putObject:saveOddDic
                                                                 withId:self.sendOddId
                                                              intoTable:DB_ODDSDETAIL];
                }
            }
            else
            {
                NSLog(@"传入物品link为空错误！！！");
                
                CoreSVPError(@"数据出错，请重试", nil);
            }
        }
    }
    else
    {
        NSLog(@"传入物品id为空错误！！！");
        
        CoreSVPError(@"数据出错，请重试", nil);
    }
    
    WS(ws);
    
    //主线程更新页面
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ws.navigationItem.title = ws.oddsDetailModel.oddsDetailName;
        
        [ws.viwTable headerFinishedLoading];
        
        [ws.viwTable reloadData];
    });
}

-(void) initData
{

}

-(void) initUI
{
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.viwTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    [self addTableViewHeader];
    
    [self addKSHeaderRefresh];
}

-(void) addTableViewHeader
{
    NSString *showDetailText = [NSString stringWithFormat:@"%@",[Tools exchangeNullToEmptyString:self.oddsDetailModel.oddsDetailIntroduce]];
    
    NSString *exchangedSpeedString = [showDetailText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    CGSize skillDetaiSize = [Tools getAdaptionSizeWithText:exchangedSpeedString andFont:TEXT12_FONT andLabelWidth:SCREEN_WIDTH - 2 * PADDING_WIDTH];
    
    //背景
    if (!self.heroBgView)
    {
        self.heroBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,PADDING_WIDTH + (SCREEN_WIDTH * HEROBG_SCALE - 50) * 2/5 + PADDING_WIDTH + skillDetaiSize.height + 30)];
    }


    self.heroBgView.backgroundColor = WHITE_COLOR;
    
    //头像
    if (!self.heroHeaderImgView)
    {
        self.heroHeaderImgView = [[UIImageView alloc] init];
    }
    
    self.heroHeaderImgView.layer.cornerRadius = (SCREEN_WIDTH * HEROBG_SCALE - 50)/5;
    
    self.heroHeaderImgView.clipsToBounds = YES;
    
    [self.heroHeaderImgView sd_setImageWithURL:[NSURL URLWithString:self.oddsDetailModel.oddsDetailImg] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    [self.heroBgView addSubview:self.heroHeaderImgView];
    
    //介绍
    if (!self.heroIntroduceLabel)
    {
        self.heroIntroduceLabel = [[UILabel alloc] init];
    }
    
    self.heroIntroduceLabel.font = TEXT12_BOLD_FONT;
    
    self.heroIntroduceLabel.textColor = COLOR_TITLE_LIGHTGRAY;
    
    self.heroIntroduceLabel.textAlignment = NSTextAlignmentCenter;
    
    self.heroIntroduceLabel.numberOfLines = 0;
    
    self.heroIntroduceLabel.text = [Tools exchangeNullToEmptyString:exchangedSpeedString];
    
    [self.heroBgView addSubview:self.heroIntroduceLabel];
    
    UIView *lineView = [[UIView alloc] init];
    
    lineView.backgroundColor = SEPRATELINE_GRAYCOLOR;
    
    [self.heroBgView addSubview:lineView];
    
    [self.heroHeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.heroBgView.mas_centerX);
        make.top.equalTo(self.heroBgView.mas_top).offset(PADDING_WIDTH);
        make.height.mas_equalTo((SCREEN_WIDTH * HEROBG_SCALE - 50) * 2/5);
        make.width.equalTo(self.heroHeaderImgView.mas_height);
    }];
    
    [self.heroIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heroBgView.mas_left).offset(PADDING_WIDTH * 3);
        make.top.equalTo(self.heroHeaderImgView.mas_bottom).offset(PADDING_WIDTH);
        make.right.equalTo(self.heroBgView.mas_right).offset(-PADDING_WIDTH * 3);
        make.height.mas_equalTo(skillDetaiSize.height + 20);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.heroBgView.mas_left);
        make.right.equalTo(self.heroBgView.mas_right);
        make.bottom.equalTo(self.heroBgView.mas_bottom);
        make.height.mas_equalTo(PIXL1_AUTO);
    }];
    
    self.viwTable.tableHeaderView = self.heroBgView;
}

-(void) oddDetailImgTaped:(UITapGestureRecognizer *) sender
{
    NSInteger selectIndex = sender.view.tag - 369;
    
    if (selectIndex < self.oddsDetailModel.oddsDetailNeedArray.count)
    {
        NSArray *tempArr = [DetailOddNeedObj mj_objectArrayWithKeyValuesArray:self.oddsDetailModel.oddsDetailNeedArray];
        
        DetailOddNeedObj *detailOddObj = tempArr[selectIndex];
        
        OddsDetailViewController *oddDetailVC = [[OddsDetailViewController alloc] init];
        
        oddDetailVC.sendOddLink = detailOddObj.needOddLink;
        
        oddDetailVC.sendOddId = [Tools getOddIdFromLink:detailOddObj.needOddLink];
        
        [self setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:oddDetailVC animated:YES];
    }
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
    return kCellHeight;
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
    
    for (UIView *cellView in  cell.contentView.subviews)
    {
        [cellView removeFromSuperview];
    }
    
    ASHorizontalScrollView *horizontalScrollView = [[ASHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight)];
    
    horizontalScrollView.tag = 888 + indexPath.section;
    
    horizontalScrollView.miniAppearPxOfLastItem = 10;
    
    horizontalScrollView.uniformItemSize = CGSizeMake(50, 50);
    
    [horizontalScrollView setItemsMarginOnce];
    
    NSMutableArray *buttons = [NSMutableArray array];
    
    NSArray *tempModelArr = [DetailOddNeedObj mj_objectArrayWithKeyValuesArray:self.oddsDetailModel.oddsDetailNeedArray];
    
    NSLog(@"tempModelArr %@",tempModelArr);
    
    for (int i=0; i<tempModelArr.count; i++)
    {
        DetailOddNeedObj *detailModel = tempModelArr[i];
        
        UIImageView *hdImgView = [[UIImageView alloc] init];
        
        [hdImgView sd_setImageWithURL:[NSURL URLWithString:detailModel.needOddImg] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
        
        UITapGestureRecognizer *heroImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oddDetailImgTaped:)];
        
        hdImgView.userInteractionEnabled = YES;
        
        hdImgView.tag = 369 + i;
        
        [hdImgView addGestureRecognizer:heroImgTap];
        
        [buttons addObject:hdImgView];
    }
    
    [horizontalScrollView addItems:buttons];
    
    [cell.contentView addSubview:horizontalScrollView];
    
    [horizontalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.contentView.mas_left);
        make.top.equalTo(cell.contentView.mas_top);
        make.right.equalTo(cell.contentView.mas_right);
        make.height.mas_equalTo(kCellHeight);
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *tempModelArr = [DetailOddNeedObj mj_objectArrayWithKeyValuesArray:self.oddsDetailModel.oddsDetailNeedArray];
    
    if (tempModelArr.count)
    {
        return 30;
    }
    
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *tempModelArr = [DetailOddNeedObj mj_objectArrayWithKeyValuesArray:self.oddsDetailModel.oddsDetailNeedArray];
    
    if (tempModelArr.count)
    {
        UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
        
        UILabel *rankOrderLabel = [[UILabel alloc] init];
        
        rankOrderLabel.text = @"合成需要";
        
        rankOrderLabel.font = TEXT14_BOLD_FONT;
        
        rankOrderLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        [headerBackView addSubview:rankOrderLabel];
        
        [rankOrderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerBackView.mas_left).offset(PADDING_WIDTH);
            make.top.equalTo(headerBackView.mas_top);
            make.bottom.equalTo(headerBackView.mas_bottom);
            make.right.equalTo(headerBackView.mas_right).offset(-PADDING_WIDTH);
        }];
        
        return headerBackView;
    }
    
    return nil;
}

#pragma mark - 系统返回键类别  返回键响应
-(BOOL) navigationShouldPopOnBackButton ///在这个方法里写返回按钮的事件处理
{
    for (UIViewController *tempVC in self.navigationController.viewControllers)
    {
        if ([tempVC isKindOfClass:[OddsViewController class]])
        {
            [self.navigationController popToViewController:tempVC animated:YES];
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - KSRefreshViewDelegate
- (void)refreshViewDidLoading:(id)view
{
    if ([view isEqual:self.viwTable.header])
    {
        //下拉刷新 删除表数据重新添加
        
        WS(ws);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[HP_Application sharedApplication].store deleteObjectById:ws.sendOddId fromTable:DB_ODDSDETAIL];
            
            [ws getOddsDetailData];
            
            [ws.viwTable reloadData];
            
            [ws addTableViewHeader];
        });
        
        return;
    }
}

@end
