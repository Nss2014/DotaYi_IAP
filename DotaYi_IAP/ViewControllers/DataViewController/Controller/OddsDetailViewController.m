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

#define kCellHeight 60

@interface OddsDetailViewController ()

@property (nonatomic,strong) OddsDetailDataModel *oddsDetailModel;

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

                    NSString *tempIntroducePriceString;
                    
                    NSString *tempIntroduceBuyPlaceString;
                    
                    NSString *tempIntroduceOtherString = @"";
                    
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
                            NSString *signChangeStr = @"";
                            
                            if (i > 3)
                            {
                                tempIntroduceOtherString = [tempIntroduceOtherString stringByAppendingFormat:@"%@%@",signChangeStr,getIntroduceArr[i]];
                                
                                if (i > 4 && getIntroduceArr[i] != nil && ![getIntroduceArr[i] isEqualToString:@""])
                                {
                                    signChangeStr = @"\r\n\n";
                                }
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
                        //有  取出 “合成需要” 数组//div[@id='slide09']//td[@class='noh']//table[@class='nobk']
                        NSArray *needComposeArrElements = [xpathParser searchWithXPathQuery:@"//div[@id='slide09']"];
                        
                        for (TFHppleElement *needElement in needComposeArrElements)
                        {
                            
                            //link
                            NSArray *tempNeedLinkArray = [Tools getHtmlValueArrayWithXPathParser:needElement XPathQuery:@"//table[@class='nobk']" DetailXPathQuery:@"//a" DetailKey:@"href"];
                            
                            //img
                            NSArray *tempNeedImgArray = [Tools getHtmlValueArrayWithXPathParser:needElement XPathQuery:@"//table[@class='nobk']" DetailXPathQuery:@"//img" DetailKey:@"src"];
                            
                            NSLog(@"tempNeedLinkArray %@",tempNeedLinkArray);
                            
                            
                            NSLog(@"tempNeedImgArray %@",tempNeedImgArray);
                            
                            
                            for (int i=0; i<tempNeedLinkArray.count; i++)
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
}

-(void) addTableViewHeader
{
    NSString *showDetailText = [NSString stringWithFormat:@"%@",[Tools exchangeNullToEmptyString:self.oddsDetailModel.oddsDetailIntroduce]];
    
    NSString *exchangedSpeedString = [showDetailText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    exchangedSpeedString = [exchangedSpeedString stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
    
    exchangedSpeedString = [exchangedSpeedString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    CGSize skillDetaiSize = [Tools getAdaptionSizeWithText:exchangedSpeedString andFont:TEXT12_FONT andLabelWidth:SCREEN_WIDTH - 2 * PADDING_WIDTH];
    
    //背景
    UIImageView *heroBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,PADDING_WIDTH + (SCREEN_WIDTH * HEROBG_SCALE - 50) * 2/5 + PADDING_WIDTH + skillDetaiSize.height + 30)];
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        
//        UIImage *backImg = [self blurryImage:[UIImage imageNamed:@"odds_bg_pic.jpg"] withBlurLevel:0.3];
//        
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            
//            heroBgView.contentMode = UIViewContentModeScaleAspectFill;
//            
//            heroBgView.image = backImg;
//        });
//    });

    heroBgView.backgroundColor = XLS_COLOR_MAIN_GRAY;
    
    
    //头像
    UIImageView *heroHeaderImgView = [[UIImageView alloc] init];
    
    heroHeaderImgView.layer.cornerRadius = (SCREEN_WIDTH * HEROBG_SCALE - 50)/5;
    
    heroHeaderImgView.clipsToBounds = YES;
    
    [heroHeaderImgView sd_setImageWithURL:[NSURL URLWithString:self.oddsDetailModel.oddsDetailImg] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    [heroBgView addSubview:heroHeaderImgView];
    
    //介绍
    UILabel *heroIntroduceLabel = [[UILabel alloc] init];
    
    heroIntroduceLabel.font = TEXT12_BOLD_FONT;
    
    heroIntroduceLabel.textColor = WHITE_COLOR;
    
    heroIntroduceLabel.textAlignment = NSTextAlignmentCenter;
    
    heroIntroduceLabel.numberOfLines = 0;
    
    heroIntroduceLabel.text = exchangedSpeedString;
    
    [heroBgView addSubview:heroIntroduceLabel];
    
    [heroHeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(heroBgView.mas_centerX);
        make.top.equalTo(heroBgView.mas_top).offset(PADDING_WIDTH);
        make.height.mas_equalTo((SCREEN_WIDTH * HEROBG_SCALE - 50) * 2/5);
        make.width.equalTo(heroHeaderImgView.mas_height);
    }];
    
    [heroIntroduceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(heroBgView.mas_left).offset(PADDING_WIDTH * 3);
        make.top.equalTo(heroHeaderImgView.mas_bottom).offset(PADDING_WIDTH);
        make.right.equalTo(heroBgView.mas_right).offset(-PADDING_WIDTH * 3);
        make.height.mas_equalTo(skillDetaiSize.height + 20);
    }];
    
    self.viwTable.tableHeaderView = heroBgView;
}

-(void) oddDetailImgTaped:(UITapGestureRecognizer *) sender
{
    
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

@end
