//
//  HeroDetailInfoViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/5.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroDetailInfoViewController.h"

@interface HeroDetailInfoViewController ()

@property (nonatomic,strong) HeroDetailDataModel *heroDetailModel;

@end

@implementation HeroDetailInfoViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getHeroDetailData];
    
    [self initHeroDetailUI];
}

-(void) getHeroDetailData
{
    if (self.sendHeroId != nil && ![self.sendHeroId isKindOfClass:[NSNull class]])
    {
        WS(ws);
        
        NSLog(@"sendHeroId %@   %@",self.sendHeroId,self.sendHeroLink);
        
        __block NSInteger tempChanged = 0;
        
        [HeroDetailDataModel find:[self.sendHeroId integerValue] selectResultBlock:^(id selectResult) {
            
            HeroDetailDataModel *getHeroDetailModel = selectResult;
            
            if (getHeroDetailModel != nil && ![getHeroDetailModel isKindOfClass:[NSNull class]])
            {
                ws.heroDetailModel = getHeroDetailModel;
                
                tempChanged ++;
            }
            else
            {
                if (ws.sendHeroLink != nil && ![ws.sendHeroLink isKindOfClass:[NSNull class]])
                {
                    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:ws.sendHeroLink]];
                    
                    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
                    
                    HeroDetailDataModel *saveModel = [[HeroDetailDataModel alloc] init];
                    
                    saveModel.hostID = [ws.sendHeroId integerValue];
                    
                    //TableHeader数据（头像、背景图片、名称、初始属性）
                    [ws getTableHeaderData:xpathParser SaveModel:saveModel];
                    
                    //section数据
                    //推荐加点方案
                    [ws getRecommendAddpointData:xpathParser SaveModel:saveModel];
                    
                    //配合英雄推荐&克制英雄推荐
                    [ws getMatchHeroData:xpathParser SaveModel:saveModel];
                    
                    //推荐出装
                    [ws getRecommendEquipmentsData:xpathParser SaveModel:saveModel];
                    
                    //技能介绍
                    [ws getSkillIntroduceData:xpathParser SaveModel:saveModel];
                    
                    [HeroDetailDataModel save:saveModel resBlock:nil];
                    
                    ws.heroDetailModel = saveModel;
                    
                    tempChanged ++;
                }
                else
                {
                    NSLog(@"传入英雄link为空错误！！！");
                    
                    CoreSVPError(@"数据出错，请重试", nil);
                }
            }
            
            if (tempChanged == 1)
            {
                //主线程更新页面
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"heroDetailModel %@",ws.heroDetailModel);
                    
                    NSLog(@"detailHeroSkillsArray %@",ws.heroDetailModel.detailHeroHPString);
                    
                    [ws.viwTable reloadData];
                    
                });
            }
            
        }];
    }
    else
    {
        NSLog(@"传入英雄id为空错误！！！");
        
        CoreSVPError(@"数据出错，请重试", nil);
    }
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
    NSString *heroAttackString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//div[@class='lay254 fr']" DetailXPathQuery:@"//dd[@class='d4']" DetailKey:nil];

    //力量&智力&敏捷
    NSString *heroStrengthString = [Tools getHtmlValueWithXPathParser:xpathParser XPathQuery:@"//div[@class='lay254 fr']" DetailXPathQuery:@"//dd[@class='d5']" DetailKey:nil];
    
    NSLog(@"heroHPString %@  %@  %@  %@  %@",heroHPString,heroMPString,heroRangeString,heroAttackString,heroStrengthString);
    
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
                
                NSString *getLinkString = getRecommendSecondLinkArray[i];
                
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
        
        NSLog(@"introduceArray3 %@ \n %@ \n %@",introduceArray3[0],introduceArray3[1],introduceArray3[2]);
        
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
            
            NSString *quickShotString = tempSkillQuickShotArray[i];
            
            NSString *spellDistanceString = tempSkillSpellArray[i];
            
            NSString *levelUpString = tempSkillLevelUpArray[i];
            
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
    
}

@end
