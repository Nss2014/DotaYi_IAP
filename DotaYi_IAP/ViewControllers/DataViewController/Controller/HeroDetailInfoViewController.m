//
//  HeroDetailInfoViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/5.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroDetailInfoViewController.h"
#import "HeroDetailTableViewCell.h"

#define SKILLBORDER_WIDTH 5.0

#define TRANSFORM_TIME 0.3

#define TRANSFORM_SCALE 1.2

const float kCellHeight = 60.0f;

@interface HeroDetailInfoViewController ()

@property (nonatomic,strong) HeroDetailDataModel *heroDetailModel;

@property (nonatomic,strong) NSArray *sectionHeaderArray;

@property (nonatomic,assign) BOOL isShowOtherSkill;//是否点击了其他技能

@property (nonatomic,assign) CGFloat signSkillCellHeight;//可变cell高度

@property (nonatomic,copy) NSString *signSkillName;//可变技能名称

@property (nonatomic,copy) NSString *signSkillDetailText;//可变技能介绍

@property (nonatomic,assign) NSInteger signSkillSelectIndex;//标记当前查看的技能

@end

@implementation HeroDetailInfoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self getHeroDetailData];
    
    //初始化技能介绍数据源 section＝6
    [self initSkillIntroduceData];
    
    [self initHeroDetailUI];
    
    [self addTableViewHeader];
}

-(void) initSkillIntroduceData
{
    NSArray *tempArr = [SkillsIntroduceModel mj_objectArrayWithKeyValuesArray:self.heroDetailModel.detailHeroSkillsArray];
    
    NSString *skillNameString;//技能名
    
    NSString *skillIntroduceString;//技能介绍
    
    NSString *skillQuickNameString;//快捷键
    
    NSString *skillDistanceString;//施法距离
    
    NSString *skillIntervalString;//施法间隔
    
    NSString *skillMPExpendString;//魔法消耗
    
    NSString *skillLevelString;//等级提升介绍
    
    SkillsIntroduceModel *skillIntroduceModel = tempArr[0];
    
    skillNameString = skillIntroduceModel.skillNameString;
    
    skillIntroduceString = skillIntroduceModel.skillIntroduceString;
    
    skillQuickNameString = skillIntroduceModel.skillQuickNameString;
    
    skillDistanceString = skillIntroduceModel.skillDistanceString;
    
    skillIntervalString = skillIntroduceModel.skillIntervalString;
    
    skillMPExpendString = skillIntroduceModel.skillMPExpendString;
    
    skillLevelString = skillIntroduceModel.skillLevelString;
    
    NSString *showDetailText = [NSString stringWithFormat:@"%@%@",skillDistanceString,skillLevelString];
    
    NSString *exchangedSpeedString = [showDetailText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    exchangedSpeedString = [exchangedSpeedString stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
    
    exchangedSpeedString = [exchangedSpeedString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    CGSize skillDetaiSize = [Tools getAdaptionSizeWithText:exchangedSpeedString andFont:TEXT12_FONT andLabelWidth:SCREEN_WIDTH - 2 * PADDING_WIDTH];
    
    self.signSkillCellHeight = kCellHeight + 10  + 20  + 10 + skillDetaiSize.height + 10;
    
    self.signSkillName = skillIntroduceModel.skillNameString;
    
    self.signSkillDetailText = exchangedSpeedString;
    
    self.signSkillSelectIndex = 0;
    
    self.isShowOtherSkill = NO;
}

-(void) initData
{
    self.sectionHeaderArray = [NSArray arrayWithObjects:
                               @"配合英雄推荐",
                               @"克制英雄推荐",
                               @"加点方案推荐",
                               @"初期出装推荐",
                               @"中期出装推荐",
                               @"后期出装推荐",
                               @"技能介绍",nil];
}

-(void) getHeroDetailData
{
    if (self.sendHeroId != nil && ![self.sendHeroId isKindOfClass:[NSNull class]])
    {
        //取出数据库数据
        NSDictionary *getValueDic = [[HP_Application sharedApplication].store getObjectById:self.sendHeroId fromTable:DB_HEROS];
        
        //字典转模型
        HeroDetailDataModel *heroModel = [HeroDetailDataModel mj_objectWithKeyValues:getValueDic];
        
        NSLog(@"heroModel %@",heroModel);
        
        if (heroModel != nil && ![heroModel isKindOfClass:[NSNull class]])
        {
            self.heroDetailModel = heroModel;
        }
        else
        {
            if (self.sendHeroLink != nil && ![self.sendHeroLink isKindOfClass:[NSNull class]])
            {
                NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.sendHeroLink]];
                
                TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
                
                HeroDetailDataModel *saveModel = [[HeroDetailDataModel alloc] init];
                
                saveModel.hostID = [self.sendHeroId integerValue];
                
                //TableHeader数据（头像、背景图片、名称、初始属性）
                [self getTableHeaderData:xpathParser SaveModel:saveModel];
                
                //section数据
                //推荐加点方案
                [self getRecommendAddpointData:xpathParser SaveModel:saveModel];
                
                //配合英雄推荐&克制英雄推荐
                [self getMatchHeroData:xpathParser SaveModel:saveModel];
                
                //推荐出装
                [self getRecommendEquipmentsData:xpathParser SaveModel:saveModel];
                
                //技能介绍
                [self getSkillIntroduceData:xpathParser SaveModel:saveModel];
                
                self.heroDetailModel = saveModel;
                
                //存入数据库
                //使用MJExtension 模型转换字典
                NSDictionary *saveHeroDic = saveModel.mj_keyValues;
                
                if (saveHeroDic != nil && ![saveHeroDic isKindOfClass:[NSNull class]])
                {
                    [[HP_Application sharedApplication].store putObject:saveHeroDic
                                                                 withId:self.sendHeroId
                                                              intoTable:DB_HEROS];
                }
            }
            else
            {
                NSLog(@"传入英雄link为空错误！！！");
                
                CoreSVPError(@"数据出错，请重试", nil);
            }
        }
    }
    else
    {
        NSLog(@"传入英雄id为空错误！！！");
        
        CoreSVPError(@"数据出错，请重试", nil);
    }

    WS(ws);
    
    //主线程更新页面
    dispatch_async(dispatch_get_main_queue(), ^{
 
        [ws.viwTable reloadData];
    });
}


-(void) getTableHeaderData:(TFHpple *) xpathParser  SaveModel:(HeroDetailDataModel *) saveModel
{
    //英雄背景图
    NSString *heroBgImgString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//div[@class='dPic fl']" DetailXPathQuery:@"//img" DetailKey:@"src"];
    
    NSLog(@"heroBgImgString %@",heroBgImgString);
    
    saveModel.detailHeroPictureUrlString = heroBgImgString;
    
    //头像、名称
    NSString *heroHeadImgString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//div[@class='dLeft clearfix fl']" DetailXPathQuery:@"//img" DetailKey:@"src"];
    
    NSString *heroNameString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//div[@class='dLeft clearfix fl']" DetailXPathQuery:@"//a" DetailKey:nil];
    
    NSLog(@"heroHeadImgString %@",heroHeadImgString);
    
    NSLog(@"heroNameString %@",heroNameString);
    
    saveModel.detailHeroImgString = heroHeadImgString;
    
    saveModel.detailHeroNameString = heroNameString;

    
    //初始属性
    //初始HP
    NSString *heroHPString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//div[@class='lay254 fr']" DetailXPathQuery:@"//dd[@class='d1']" DetailKey:nil];
    
    //初始MP
    NSString *heroMPString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//div[@class='lay254 fr']" DetailXPathQuery:@"//dd[@class='d2']" DetailKey:nil];
    
    //射程移速
    NSString *heroRangeString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//div[@class='lay254 fr']" DetailXPathQuery:@"//dd[@class='d3']" DetailKey:nil];

    //攻击&攻速&护甲
    NSString *heroAttackString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//dl[@class='dlInfo clearfix']" DetailXPathQuery:@"//dd[@class='d4']" DetailKey:nil];

    //力量&智力&敏捷
    NSString *heroStrengthString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//div[@class='lay254 fr']" DetailXPathQuery:@"//dd[@class='d5']" DetailKey:nil];
    
    NSLog(@"heroHPString %@  heroMPString %@  heroRangeString %@  heroAttackString %@  heroStrengthString %@",heroHPString,heroMPString,heroRangeString,heroAttackString,heroStrengthString);
    
    saveModel.detailHeroHPString = heroHPString;
    
    saveModel.detailHeroMPString = heroMPString;
    
    saveModel.detailHeroRangeString = heroRangeString;
    
    saveModel.detailHeroAttackString = heroAttackString;
    
    saveModel.detailHeroStrengthString = heroStrengthString;
}

-(void) getMatchHeroData:(TFHpple *) xpathParser  SaveModel:(HeroDetailDataModel *) saveModel
{
    NSArray *matchElementArr = [xpathParser searchWithXPathQuery:@"//div[@class='tbC']"];
    
    NSInteger getValueSign = 0;//0=配合英雄  1=克制英雄
    
    for (TFHppleElement *tempAElement in matchElementArr) {
        
        //子节点头像
        NSArray *IMGElementsArr = [tempAElement searchWithXPathQuery:@"//img"];
        
        NSMutableArray *tempChildImgArray = [NSMutableArray array];
        
        NSMutableArray *tempChildLinkArray = [NSMutableArray array];
        
        for (TFHppleElement *childTempAElement in IMGElementsArr)
        {
            NSString *childImgString = [childTempAElement objectForKey:@"src"];
            
            [tempChildImgArray addObject:childImgString];
        }
        
        
        //子节点链接
        NSArray *childNameElementsArr = [tempAElement searchWithXPathQuery:@"//a"];
        
        for (TFHppleElement *childTempAElement in childNameElementsArr)
        {
            NSString *childLinkString = [childTempAElement objectForKey:@"href"];
            
            [tempChildLinkArray addObject:childLinkString];
        }
        
        NSLog(@"tempChildImgArray %@ \n tempChildLinkArray %@",tempChildImgArray,tempChildLinkArray);
        
        NSMutableArray *tempMatchArray = [NSMutableArray array];
        
        NSMutableArray *tempRestainArray = [NSMutableArray array];

        for (int i=0; i<tempChildImgArray.count; i++)
        {
            NSString *tempImgString = tempChildImgArray[i];
            
            NSString *tempLinkString = tempChildLinkArray[i];
            
            MatchOrDefenceHeroModel *matchOrDefence = [[MatchOrDefenceHeroModel alloc] init];
            
            matchOrDefence.hostID = 100 + i;

            matchOrDefence.mdHeroImgString = tempImgString;
            
            matchOrDefence.mdHeroLinkString = tempLinkString;
            
            if (getValueSign == 0)
            {
                //配合英雄
                [tempMatchArray addObject:matchOrDefence];
            }
            else if (getValueSign == 1)
            {
                //克制英雄
                [tempRestainArray addObject:matchOrDefence];
            }
        }
        
        if (tempMatchArray.count)
        {
            saveModel.detailHeroMatchArray = [NSArray arrayWithArray:tempMatchArray];
        }
        
        if (tempRestainArray.count)
        {
            saveModel.detailHeroRestrainArray = [NSArray arrayWithArray:tempRestainArray];
        }
        
        NSLog(@"detailHeroMatchArray %@ \n detailHeroRestrainArray %@",saveModel.detailHeroMatchArray,saveModel.detailHeroRestrainArray);
        
        getValueSign ++;

    }
}

-(void) getRecommendAddpointData:(TFHpple *) xpathParser  SaveModel:(HeroDetailDataModel *) saveModel
{
    NSArray *recommendAddPointArray = [Tools getHtmlValueArrayWithXPathParser:xpathParser XPathQuery:@"//div[@class='modD mb10 p1-l728-md-a']" DetailXPathQuery:@"//img" DetailKey:@"src"];
    
    NSLog(@"recommendAddPointArray %@",recommendAddPointArray);
    
    NSMutableArray *tempAddPointArray = [NSMutableArray array];
    
    for (NSString *addPointString in recommendAddPointArray)
    {
        [tempAddPointArray addObject:addPointString];
    }
    
    saveModel.detaiHeroRecommendAddPointArray = [NSArray arrayWithArray:tempAddPointArray];
}

-(void) getRecommendEquipmentsData:(TFHpple *) xpathParser  SaveModel:(HeroDetailDataModel *) saveModel
{
    NSArray *beginElementArr = [xpathParser searchWithXPathQuery:@"//div[@class='modD mb10 p1-l728-md-b']"];
    
    for (TFHppleElement *beginAElement in beginElementArr)
    {
        NSArray *recommendElementArr = [beginAElement searchWithXPathQuery:@"//div[@class='tbA clearfix']"];
        
        for (TFHppleElement *tempAElement in recommendElementArr)
        {
            NSMutableArray *tempModelArray = [NSMutableArray array];
            
            //初期(图片&链接)
            NSArray *getRecommendFirstImgArray = [Tools getHtmlValueArrayWithXPathParser:tempAElement XPathQuery:@"//li[@class='li_132']" DetailXPathQuery:@"//img" DetailKey:@"src"];
            
            NSArray *getRecommendFirstLinkArray = [Tools getHtmlValueArrayWithXPathParser:tempAElement XPathQuery:@"//li[@class='li_132']" DetailXPathQuery:@"//a" DetailKey:@"href"];
            
            [tempModelArray removeAllObjects];
            
            for (int i=0; i<getRecommendFirstImgArray.count; i++)
            {
                NSString *getImgString = getRecommendFirstImgArray[i];
                
                NSString *getLinkString = getRecommendFirstLinkArray[i];
                
                RecommendEqumentsModel *recommendEqumentsModel = [[RecommendEqumentsModel alloc] init];
                
                recommendEqumentsModel.hostID = 100 + i;
                
                recommendEqumentsModel.reImgString = getImgString;
                
                recommendEqumentsModel.reLinkString = getLinkString;
                
                [tempModelArray addObject:recommendEqumentsModel];
            }
            
            saveModel.detailHeroFirstRecommendEquipmentsArray = [NSArray arrayWithArray:tempModelArray];
            
            //中期(图片&链接)
            NSArray *getRecommendSecondImgArray = [Tools getHtmlValueArrayWithXPathParser:tempAElement XPathQuery:@"//li[@class='li_146']" DetailXPathQuery:@"//img" DetailKey:@"src"];
            
            NSArray *getRecommendSecondLinkArray = [Tools getHtmlValueArrayWithXPathParser:tempAElement XPathQuery:@"//li[@class='li_146']" DetailXPathQuery:@"//a" DetailKey:@"href"];
            
            [tempModelArray removeAllObjects];
            
            for (int i=0; i<getRecommendSecondImgArray.count; i++)
            {
                NSString *getImgString = getRecommendSecondImgArray[i];
                
                NSLog(@"iiiiii %d   %@",i,getRecommendSecondImgArray);
                
                NSString *getLinkString;
                
                if (i < getRecommendSecondLinkArray.count)
                {
                    getLinkString = getRecommendSecondLinkArray[i];
                }
                
                RecommendEqumentsModel *recommendEqumentsModel = [[RecommendEqumentsModel alloc] init];
                
                recommendEqumentsModel.hostID = 100 + i;
                
                recommendEqumentsModel.reImgString = getImgString;
                
                recommendEqumentsModel.reLinkString = getLinkString;
                
                [tempModelArray addObject:recommendEqumentsModel];

            }
            
            saveModel.detailHeroSecondRecommendEquipmentsArray = [NSArray arrayWithArray:tempModelArray];
            
            //后期(图片&链接)
            NSArray *getRecommendThirdImgArray = [Tools getHtmlValueArrayWithXPathParser:tempAElement XPathQuery:@"//li[@class='li_138']" DetailXPathQuery:@"//img" DetailKey:@"src"];
            
            NSArray *getRecommendThirdLinkArray = [Tools getHtmlValueArrayWithXPathParser:tempAElement XPathQuery:@"//li[@class='li_138']" DetailXPathQuery:@"//a" DetailKey:@"href"];
            
            [tempModelArray removeAllObjects];
            
            for (int i=0; i<getRecommendThirdImgArray.count; i++)
            {
                NSString *getImgString = getRecommendThirdImgArray[i];
                
                NSString *getLinkString = getRecommendThirdLinkArray[i];
                
                RecommendEqumentsModel *recommendEqumentsModel = [[RecommendEqumentsModel alloc] init];
                
                recommendEqumentsModel.hostID = 200 + i;
                
                recommendEqumentsModel.reImgString = getImgString;
                
                recommendEqumentsModel.reLinkString = getLinkString;
                
                [tempModelArray addObject:recommendEqumentsModel];
            }
            
            saveModel.detailHeroThirdRecommendEquipmentsArray = [NSArray arrayWithArray:tempModelArray];

            
            NSLog(@"detailHeroFirstRecommendEquipmentsArray %@",saveModel.detailHeroFirstRecommendEquipmentsArray);
            
            NSLog(@"detailHeroSecondRecommendEquipmentsArray %@",saveModel.detailHeroSecondRecommendEquipmentsArray);
            
            NSLog(@"detailHeroThirdRecommendEquipmentsArray %@",saveModel.detailHeroThirdRecommendEquipmentsArray);
            
        }

    }

}


-(void) getSkillIntroduceData:(TFHpple *) xpathParser  SaveModel:(HeroDetailDataModel *) saveModel
{
    NSArray *beginElementArr = [xpathParser searchWithXPathQuery:@"//div[@class='modD p1-l728-md-c']"];
    
    NSLog(@"beginElementArr %ld",beginElementArr.count);
    
    for (TFHppleElement *beginAElement in beginElementArr)
    {
        
        NSMutableArray *tempSkillImgArray = [NSMutableArray array];
        
        NSMutableArray *tempSkillNameArray = [NSMutableArray array];
        
        NSMutableArray *tempSkillQuickShotArray = [NSMutableArray array];
        
        NSMutableArray *tempSkillSpellArray = [NSMutableArray array];
        
        NSMutableArray *tempSkillLevelUpArray = [NSMutableArray array];
        
        //技能介绍分为两部分  两个数组
        //技能图片
        NSArray *skillImgStringArray = [Tools getHtmlValueArrayWithXPathParser:beginAElement XPathQuery:@"//img" DetailXPathQuery:nil DetailKey:@"src"];
        
        NSLog(@"skillImgStringArray %@",skillImgStringArray);
        
        for (NSString *imgString in skillImgStringArray)
        {
            [tempSkillImgArray addObject:imgString];
        }
        
        //第一部分  "月光"
        NSArray *introduceArray1 = [Tools getHtmlValueArrayWithXPathParser:beginAElement XPathQuery:@"//table[@class='table1']" DetailXPathQuery:@"//strong" DetailKey:nil];
        
        NSLog(@"introduceArray1 %@",introduceArray1);
        
        for (NSString *name1String in introduceArray1)
        {
            NSLog(@"name1String %@",name1String);
            
            [tempSkillNameArray addObject:name1String];
        }
        
        //快捷键C
        NSArray *introduceArray2 = [Tools getHtmlValueArrayWithXPathParser:beginAElement XPathQuery:@"//table[@class='table1']" DetailXPathQuery:@"//span[@class='span_blue']" DetailKey:nil];
        
        NSLog(@"introduceArray2 %@",introduceArray2);
        
        for (NSString *name2String in introduceArray2)
        {
            NSLog(@"name2String %@",name2String);
            
            [tempSkillQuickShotArray addObject:name2String];
        }
        
        //技能介绍&施法距离等等。。
        NSArray *introduceArray3 = [Tools getHtmlValueArrayWithXPathParser:beginAElement XPathQuery:@"//table[@class='table1']" DetailXPathQuery:@"//tbody" DetailKey:nil];
        
        for (NSString *name3String in introduceArray3)
        {
            NSLog(@"name3String %@",name3String);
            
            [tempSkillSpellArray addObject:name3String];
        }

        
        //等级提升介绍
        NSArray *skillUpIntroduceArray = [Tools getHtmlValueArrayWithXPathParser:beginAElement XPathQuery:@"//table[@class='table2']" DetailXPathQuery:nil DetailKey:nil];
        
        for (NSString *valueSring in skillUpIntroduceArray)
        {
            NSLog(@"valueSring %@",valueSring);
            
            [tempSkillLevelUpArray addObject:valueSring];
        }
        
        NSMutableArray *tempSkillFinalArray = [NSMutableArray array];
        
        for (int i=0; i<tempSkillImgArray.count; i++)
        {
            NSString *imgString = tempSkillImgArray[i];
            
            NSString *nameString = tempSkillNameArray[i];
            
            NSString *quickShotString;
            
            NSString *spellDistanceString;
            
            NSString *levelUpString;
            
            if (i < tempSkillQuickShotArray.count)
            {
                quickShotString = tempSkillQuickShotArray[i];
            }
            
            if (i < tempSkillSpellArray.count)
            {
                spellDistanceString = tempSkillSpellArray[i];
            }
            
            if (i < tempSkillLevelUpArray.count)
            {
                levelUpString = tempSkillLevelUpArray[i];
            }
            
            SkillsIntroduceModel *skillIntroduceModel = [[SkillsIntroduceModel alloc] init];
            
            skillIntroduceModel.hostID = 100 + i;
            
            skillIntroduceModel.skillNameString = nameString;
            
            skillIntroduceModel.skillImgString = imgString;
            
            skillIntroduceModel.skillQuickNameString = quickShotString;
            
            skillIntroduceModel.skillDistanceString = spellDistanceString;
            
            skillIntroduceModel.skillLevelString = levelUpString;

            [tempSkillFinalArray addObject:skillIntroduceModel];
        }
        
        saveModel.detailHeroSkillsArray = [NSArray arrayWithArray:tempSkillFinalArray];
        
        NSLog(@"detailHeroSkillsArray %@",saveModel.detailHeroSkillsArray);
    }
}

-(void) initHeroDetailUI
{   
    self.navigationItem.title = self.sendHeroName;
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.viwTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
}

-(void) addTableViewHeader
{
    //背景图
    UIImageView *heroBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * HEROBG_SCALE)];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UIImage *backImg = [self blurryImage:[Tools imageFromURLString:self.heroDetailModel.detailHeroPictureUrlString] withBlurLevel:0.3];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            heroBgView.contentMode = UIViewContentModeScaleAspectFit;
            
            heroBgView.image = backImg;
        });
    });

    
    //头像
    UIImageView *heroHeaderImgView = [[UIImageView alloc] init];
    
    heroHeaderImgView.layer.cornerRadius = (SCREEN_WIDTH * HEROBG_SCALE - 50)/5;
    
    heroHeaderImgView.clipsToBounds = YES;

    [heroHeaderImgView sd_setImageWithURL:[NSURL URLWithString:self.heroDetailModel.detailHeroImgString] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    [heroBgView addSubview:heroHeaderImgView];
    
    //HP
    UILabel *heroHPLabel = [[UILabel alloc] init];
    
    heroHPLabel.font = TEXT12_BOLD_FONT;
    
    heroHPLabel.backgroundColor = [UIColor colorWithRed:64/255.0 green:155/255.0 blue:117/255.0 alpha:1.0];
    
    heroHPLabel.textColor = WHITE_COLOR;
    
    heroHPLabel.textAlignment = NSTextAlignmentCenter;
    
    heroHPLabel.text = [NSString stringWithFormat:@"HP %@",self.heroDetailModel.detailHeroHPString];
    
    heroHPLabel.layer.cornerRadius = (SCREEN_WIDTH * HEROBG_SCALE - 50) * 3/40;
    
    heroHPLabel.clipsToBounds = YES;
    
    [heroBgView addSubview:heroHPLabel];
    
    //MP
    UILabel *heroMPLabel = [[UILabel alloc] init];
    
    heroMPLabel.font = TEXT12_BOLD_FONT;
    
    heroMPLabel.textColor = WHITE_COLOR;
    
    heroMPLabel.text = [NSString stringWithFormat:@"MP %@",self.heroDetailModel.detailHeroMPString];
    
    heroMPLabel.textAlignment = NSTextAlignmentCenter;
    
    heroMPLabel.layer.cornerRadius = (SCREEN_WIDTH * HEROBG_SCALE - 50) * 3/40;
    
    heroMPLabel.clipsToBounds = YES;

    heroMPLabel.backgroundColor = [UIColor colorWithRed:71/255.0 green:129/255.0 blue:169/255.0 alpha:1.0];
    [heroBgView addSubview:heroMPLabel];
    
    //射程
    UILabel *heroDistanceLabel = [[UILabel alloc] init];
    
    heroDistanceLabel.font = TEXT12_FONT;
    
    heroDistanceLabel.textColor = WHITE_COLOR;
    
    heroDistanceLabel.textAlignment = NSTextAlignmentCenter;
    
    heroDistanceLabel.numberOfLines = 0;
    
    heroDistanceLabel.text = [NSString stringWithFormat:@"初始%@",self.heroDetailModel.detailHeroRangeString];
    
    [heroBgView addSubview:heroDistanceLabel];
    
    //攻速
    UILabel *heroSpeedLabel = [[UILabel alloc] init];
    
    heroSpeedLabel.font = TEXT12_FONT;
    
    heroSpeedLabel.textColor = WHITE_COLOR;
    
    heroSpeedLabel.numberOfLines = 0;
    
    heroSpeedLabel.textAlignment = NSTextAlignmentCenter;
    
    NSString *exchangedSpeedString = [self.heroDetailModel.detailHeroAttackString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    exchangedSpeedString = [exchangedSpeedString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    exchangedSpeedString = [exchangedSpeedString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    heroSpeedLabel.text = [NSString stringWithFormat:@"初始%@",exchangedSpeedString];
    
    [heroBgView addSubview:heroSpeedLabel];
    
    [heroHeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(heroBgView.mas_centerX);
        make.top.equalTo(heroBgView.mas_top).offset(PADDING_WIDTH);
        make.height.mas_equalTo((SCREEN_WIDTH * HEROBG_SCALE - 50) * 2/5);
        make.width.equalTo(heroHeaderImgView.mas_height);
    }];
    
    [heroHPLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(heroBgView.mas_centerX);
        make.top.equalTo(heroHeaderImgView.mas_bottom).offset(PADDING_WIDTH);
        make.width.mas_equalTo(160);
        make.height.mas_equalTo((SCREEN_WIDTH * HEROBG_SCALE - 50) * 3/20);
    }];
    
    [heroMPLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(heroHPLabel.mas_centerX);
        make.top.equalTo(heroHPLabel.mas_bottom).offset(PADDING_WIDTH);
        make.width.equalTo(heroHPLabel.mas_width);
        make.height.equalTo(heroHPLabel.mas_height);
    }];
    
    [heroDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(heroBgView.mas_left).offset(PADDING_WIDTH);
        make.right.equalTo(heroBgView.mas_right).offset(-PADDING_WIDTH);
        make.top.equalTo(heroMPLabel.mas_bottom).offset(PADDING_WIDTH);
        make.height.mas_equalTo((SCREEN_WIDTH * HEROBG_SCALE - 50) * 3/20);
    }];
    
    [heroSpeedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(heroDistanceLabel.mas_left);
        make.right.equalTo(heroDistanceLabel.mas_right);
        make.top.equalTo(heroDistanceLabel.mas_bottom);
        make.height.equalTo(heroDistanceLabel.mas_height);
    }];
    
    self.viwTable.tableHeaderView = heroBgView;
}

-(void) skillImageTaped:(UITapGestureRecognizer *) sender
{
    NSInteger selectIndex = sender.view.tag - 199;
    
    NSArray *tempArr = [SkillsIntroduceModel mj_objectArrayWithKeyValuesArray:self.heroDetailModel.detailHeroSkillsArray];
    
    SkillsIntroduceModel *skillIntroduceModel = tempArr[selectIndex];
    
    NSString *skillDistanceString = skillIntroduceModel.skillDistanceString;
    
    NSString *skillLevelString = skillIntroduceModel.skillLevelString;
    
    NSString *skillDetailStr = [NSString stringWithFormat:@"%@%@",skillDistanceString,skillLevelString];
    
    NSString *exchangedSpeedString = [skillDetailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    exchangedSpeedString = [exchangedSpeedString stringByReplacingOccurrencesOfString:@"\r\n\r\n" withString:@"\r\n"];
    
    exchangedSpeedString = [exchangedSpeedString stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
    
    CGSize skillDetaiSize = [Tools getAdaptionSizeWithText:exchangedSpeedString andFont:TEXT12_FONT andLabelWidth:SCREEN_WIDTH - 2 * PADDING_WIDTH];
    
    self.signSkillCellHeight = kCellHeight + 10  + 20  + 10 + skillDetaiSize.height + 10 ;
    
    self.signSkillName = skillIntroduceModel.skillNameString;
    
    self.signSkillDetailText = exchangedSpeedString;
    
    self.signSkillSelectIndex = selectIndex;
    
    //一个section刷新
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:6];
    
    [self.viwTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark 列表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionHeaderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 6)
    {
        NSArray *tempArr = [SkillsIntroduceModel mj_objectArrayWithKeyValuesArray:self.heroDetailModel.detailHeroSkillsArray];
        
        SkillsIntroduceModel *skillIntroduceModel = tempArr[0];
        
        NSString *skillDistanceString = skillIntroduceModel.skillDistanceString;
        
        NSString *skillLevelString = skillIntroduceModel.skillLevelString;
        
        NSString *skillDetailStr = [NSString stringWithFormat:@"%@%@",skillDistanceString,skillLevelString];
        
        NSString *exchangedSpeedString = [skillDetailStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        
        CGSize skillDetaiSize = [Tools getAdaptionSizeWithText:exchangedSpeedString andFont:TEXT12_FONT andLabelWidth:SCREEN_WIDTH - 2 * PADDING_WIDTH];
        
        
        NSLog(@"signSkillCellHeight %f   %f",self.signSkillCellHeight,kCellHeight + skillDetaiSize.height - 30);
        
        return self.signSkillCellHeight;
    }
    
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 6)
    {
        static NSString *indentifier = @"CellSection";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
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
        
        NSMutableArray *sectionButtons = [NSMutableArray array];
        
        NSArray *tempArr = [SkillsIntroduceModel mj_objectArrayWithKeyValuesArray:self.heroDetailModel.detailHeroSkillsArray];
        
        NSLog(@"signSkillName %@  %ld",self.signSkillName,self.signSkillSelectIndex);
        
        for (int i=0; i<tempArr.count; i++)
        {
            SkillsIntroduceModel *skillIntroduceModel = tempArr[i];
            
            UIImageView *hdImgView = [[UIImageView alloc] init];
            
            NSLog(@"skillImgString %@",skillIntroduceModel.skillImgString);
            
            [hdImgView sd_setImageWithURL:[NSURL URLWithString:skillIntroduceModel.skillImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
            
            UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(skillImageTaped:)];
            
            hdImgView.tag = 199 + i;
            
            hdImgView.userInteractionEnabled = YES;
            
            [hdImgView addGestureRecognizer:imgTap];
            
            [sectionButtons addObject:hdImgView];
        }
        
        [horizontalScrollView addItems:sectionButtons];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.contentView addSubview:horizontalScrollView];
        
        
        UILabel *skillNameLabel = [[UILabel alloc] init];
        
        skillNameLabel.tag = 1999;
        
        skillNameLabel.font = TEXT14_BOLD_FONT;
        
        skillNameLabel.textColor = COLOR_TITLE_BLACK;
        
        [cell.contentView addSubview:skillNameLabel];
        
        UILabel * skillIntrLabel = [[UILabel alloc] init];
        
        skillIntrLabel.tag = 2999;
        
        skillIntrLabel.numberOfLines = 0;
        
        skillIntrLabel.font = TEXT12_FONT;
        
        skillIntrLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        [cell.contentView addSubview:skillIntrLabel];
        
        [horizontalScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left);
            make.top.equalTo(cell.contentView.mas_top);
            make.right.equalTo(cell.contentView.mas_right);
            make.height.mas_equalTo(kCellHeight);
        }];
        
        [skillNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(PADDING_WIDTH);
            make.right.equalTo(cell.contentView.mas_right).offset(-PADDING_WIDTH);
            make.top.equalTo(horizontalScrollView.mas_bottom).offset(PADDING_WIDTH);
            make.height.mas_equalTo(20);
        }];
        
        [skillIntrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(skillNameLabel.mas_left);
            make.right.equalTo(skillNameLabel.mas_right);
            make.top.equalTo(skillNameLabel.mas_bottom);
            make.bottom.equalTo(cell.contentView.mas_bottom).offset(-PADDING_WIDTH);
        }];
        
        
        
        skillNameLabel.text = self.signSkillName;
        
        skillIntrLabel.text = self.signSkillDetailText;
        
        NSLog(@"horizontalScrollView %@",horizontalScrollView.items);
        
        for (int i=0; i<horizontalScrollView.items.count; i++)
        {
            UIImageView *normalImageView = horizontalScrollView.items[i];
            
            if (self.signSkillSelectIndex == i)
            {
                [UIView animateWithDuration:TRANSFORM_TIME animations:^{
                    
                    normalImageView.transform = CGAffineTransformScale(CGAffineTransformIdentity, TRANSFORM_SCALE, TRANSFORM_SCALE);
                    
                }];
            }
            else
            {
                
                [UIView animateWithDuration:TRANSFORM_TIME animations:^{
                    
                    normalImageView.transform = CGAffineTransformIdentity;
                    
                }];
            }
        }
        
        return cell;
    }
    else
    {
        static NSString *indentifier = @"CellPortrait";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        
        if (!cell)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        ASHorizontalScrollView *horizontalScrollView = [[ASHorizontalScrollView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, kCellHeight)];
        
        horizontalScrollView.tag = 888 + indexPath.section;
        
        horizontalScrollView.miniAppearPxOfLastItem = 10;
        
        horizontalScrollView.uniformItemSize = CGSizeMake(50, 50);
        
        [horizontalScrollView setItemsMarginOnce];
        
        NSMutableArray *buttons = [NSMutableArray array];
        
        switch (indexPath.section)
        {
            case 0:
            {
                NSArray *tempModelArr = [MatchOrDefenceHeroModel mj_objectArrayWithKeyValuesArray:self.heroDetailModel.detailHeroMatchArray];
                
                for (int i=0; i<tempModelArr.count; i++)
                {
                    MatchOrDefenceHeroModel *matchOrDefenceModel = tempModelArr[i];
                    
                    UIImageView *hdImgView = [[UIImageView alloc] init];
                    
                    NSLog(@"mdHeroImgString %@",matchOrDefenceModel.mdHeroImgString);
                    
                    [hdImgView sd_setImageWithURL:[NSURL URLWithString:matchOrDefenceModel.mdHeroImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                    
                    [buttons addObject:hdImgView];
                }
                
            }
                break;
            case 1:
            {
                NSArray *tempModelArr = [MatchOrDefenceHeroModel mj_objectArrayWithKeyValuesArray:self.heroDetailModel.detailHeroRestrainArray];
                
                for (int i=0; i<tempModelArr.count; i++)
                {
                    MatchOrDefenceHeroModel *matchOrDefenceModel = tempModelArr[i];
                    
                    UIImageView *hdImgView = [[UIImageView alloc] init];
                    
                    NSLog(@"mdHeroImgString %@",matchOrDefenceModel.mdHeroImgString);
                    
                    [hdImgView sd_setImageWithURL:[NSURL URLWithString:matchOrDefenceModel.mdHeroImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                    
                    [buttons addObject:hdImgView];
                }
            }
                break;
            case 2:
            {
                for (int i=0; i<self.heroDetailModel.detaiHeroRecommendAddPointArray.count; i++)
                {
                    NSString *imgString = self.heroDetailModel.detaiHeroRecommendAddPointArray[i];
                    
                    UIImageView *hdImgView = [[UIImageView alloc] init];
                    
                    NSLog(@"imgString %@",imgString);
                    
                    [hdImgView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                    
                    //添加等级角标
                    UILabel *cornerLevelLabel = [[UILabel alloc] init];
                    
                    cornerLevelLabel.text = [NSString stringWithFormat:@"%d",i+1];
                    
                    cornerLevelLabel.font = TEXT10_FONT;
                    
                    cornerLevelLabel.textColor = WHITE_COLOR;
                    
                    cornerLevelLabel.textAlignment = NSTextAlignmentCenter;
                    
                    [hdImgView addSubview:cornerLevelLabel];
                    
                    [cornerLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(hdImgView.mas_right);
                        make.bottom.equalTo(hdImgView.mas_bottom);
                        make.width.mas_equalTo(15);
                        make.height.mas_equalTo(15);
                    }];
                    
                    [buttons addObject:hdImgView];
                }
            }
                break;
            case 3:
            {
                NSArray *tempArr = [RecommendEqumentsModel mj_objectArrayWithKeyValuesArray:self.heroDetailModel.detailHeroFirstRecommendEquipmentsArray];
                
                for (int i=0; i<tempArr.count; i++)
                {
                    RecommendEqumentsModel *recommendEqumentsModel = tempArr[i];
                    
                    UIImageView *hdImgView = [[UIImageView alloc] init];
                    
                    NSLog(@"recommendEqumentsModel.reImgString %@",recommendEqumentsModel.reImgString);
                    
                    [hdImgView sd_setImageWithURL:[NSURL URLWithString:recommendEqumentsModel.reImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                    
                    [buttons addObject:hdImgView];
                }
            }
                break;
            case 4:
            {
                NSArray *tempArr = [RecommendEqumentsModel mj_objectArrayWithKeyValuesArray:self.heroDetailModel.detailHeroSecondRecommendEquipmentsArray];
                
                for (int i=0; i<tempArr.count; i++)
                {
                    RecommendEqumentsModel *recommendEqumentsModel = tempArr[i];
                    
                    UIImageView *hdImgView = [[UIImageView alloc] init];
                    
                    NSLog(@"recommendEqumentsModel.reImgString %@",recommendEqumentsModel.reImgString);
                    
                    [hdImgView sd_setImageWithURL:[NSURL URLWithString:recommendEqumentsModel.reImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                    
                    [buttons addObject:hdImgView];
                }
            }
                break;
            case 5:
            {
                NSArray *tempArr = [RecommendEqumentsModel mj_objectArrayWithKeyValuesArray:self.heroDetailModel.detailHeroThirdRecommendEquipmentsArray];
                
                for (int i=0; i<tempArr.count; i++)
                {
                    RecommendEqumentsModel *recommendEqumentsModel = tempArr[i];
                    
                    UIImageView *hdImgView = [[UIImageView alloc] init];
                    
                    NSLog(@"recommendEqumentsModel.reImgString %@",recommendEqumentsModel.reImgString);
                    
                    [hdImgView sd_setImageWithURL:[NSURL URLWithString:recommendEqumentsModel.reImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                    
                    [buttons addObject:hdImgView];
                }
            }
                break;
            case 6:
            {
                
            }
                break;
                
            default:
                break;
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    
    UILabel *rankOrderLabel = [[UILabel alloc] init];
    
    rankOrderLabel.text = self.sectionHeaderArray[section];
    
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

#pragma mark -  点击行响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
