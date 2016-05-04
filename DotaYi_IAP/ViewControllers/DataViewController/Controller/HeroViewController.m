//
//  HeroViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroViewController.h"
#import "HeroTypeInfoModel.h"

@interface HeroViewController ()

@property (nonatomic,strong) HeroTypeInfoModel *saveMJHeroModel;

@property (nonatomic,strong) HeroTypeInfoModel *saveZLHeroModel;

@property (nonatomic,strong) HeroTypeInfoModel *saveLLHeroModel;

@end

@implementation HeroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self creatData];
    
    [self initUI];
}

-(void) creatData
{
    //获取敏捷英雄数据
    [self getHeroDataWithTypeId:1];

    //获取智力英雄数据
    [self getHeroDataWithTypeId:2];
    
    //获取力量英雄数据
    [self getHeroDataWithTypeId:3];
}

-(void) getHeroDataWithTypeId:(NSInteger) aTypeID
{
    WS(ws);
    
    [HeroTypeInfoModel find:aTypeID selectResultBlock:^(id selectResult) {
        
        HeroTypeInfoModel *getLocalModel = selectResult;
        
        if (getLocalModel.heroNameArray.count)
        {
            if (aTypeID == 1)
            {
                ws.saveMJHeroModel = getLocalModel;
            }
            else if (aTypeID == 2)
            {
                ws.saveZLHeroModel = getLocalModel;
            }
            else if (aTypeID == 3)
            {
                ws.saveLLHeroModel = getLocalModel;
            }
        }
        else
        {
            NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:DT_HEROLISTDATA_URL]];
            
            TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
            
            NSString *headXPathQuary = @"";
            
            if (aTypeID == 1)
            {
                headXPathQuary = @"//div[@class='modB mt3 mb10']";
            }
            else if (aTypeID == 2)
            {
                headXPathQuary = @"//div[@class='modB mb10']";
            }
            else if (aTypeID == 3)
            {
                headXPathQuary = @"//div[@class='modB']";
            }
            
            //英雄信息
            NSArray *heroElements = [xpathParser searchWithXPathQuery:headXPathQuary];
            
            HeroTypeInfoModel *saveHeroModel = [[HeroTypeInfoModel alloc] init];
            
            saveHeroModel.hostID = aTypeID;
            
            for (TFHppleElement *tfElement in heroElements)
            {
                if (aTypeID == 1)
                {
                    //"敏捷英雄"四个字
                    NSArray *titleElements = [xpathParser searchWithXPathQuery:@"//div[@class='thB']"];
                    
                    for (TFHppleElement *titleElement in titleElements)
                    {
                        NSArray *TitleElementArr = [titleElement searchWithXPathQuery:@"//span[@class='mark sbg1']"];
                        
                        for (TFHppleElement *tempAElement in TitleElementArr)
                        {
                            //获得title
                            NSLog(@"text %@",tempAElement.text);
                            
                            NSLog(@"content %@",tempAElement.content);
                            
                            saveHeroModel.heroTypeName = tempAElement.text;
                        }
                    }
                }
                else if (aTypeID == 2)
                {
                    //"智力英雄"四个字
                    NSArray *titleElements = [xpathParser searchWithXPathQuery:@"//div[@class='thB']"];
                    
                    for (TFHppleElement *titleElement in titleElements)
                    {
                        NSArray *TitleElementArr = [titleElement searchWithXPathQuery:@"//span[@class='mark sbg2 ']"];
                        for (TFHppleElement *tempAElement in TitleElementArr)
                        {
                            //获得title
                            NSLog(@"text %@",tempAElement.text);
                            
                            NSLog(@"content %@",tempAElement.content);
                            
                            saveHeroModel.heroTypeName = tempAElement.text;
                        }
                    }
                }
                else if (aTypeID == 3)
                {
                    //"力量英雄"四个字
                    NSArray *titleElements = [xpathParser searchWithXPathQuery:@"//div[@class='thB']"];
                    
                    for (TFHppleElement *titleElement in titleElements)
                    {
                        NSArray *TitleElementArr = [titleElement searchWithXPathQuery:@"//span[@class='mark sbg3']"];
                        for (TFHppleElement *tempAElement in TitleElementArr)
                        {
                            //获得title
                            NSLog(@"text %@",tempAElement.text);
                            
                            NSLog(@"content %@",tempAElement.content);
                            
                            saveHeroModel.heroTypeName = tempAElement.text;
                        }
                    }
                }
                
#pragma mark 子节点头像
                
                NSArray *IMGElementsArr = [tfElement searchWithXPathQuery:@"//img"];
                
                NSMutableArray *tempImgArray = [NSMutableArray array];
                
                for (TFHppleElement *tempAElement in IMGElementsArr)
                {
                    
                    NSString *imgStr = [tempAElement objectForKey:@"src"];
                    
                    NSLog(@"imgStr %@",imgStr);
                    
                    [tempImgArray addObject:imgStr];
                }
                
                saveHeroModel.heroHeadImageURLArray = [NSArray arrayWithArray:tempImgArray];
                
#pragma mark 子节点标题
                
                NSArray *TitleElementArr = [tfElement searchWithXPathQuery:@"//span"];
                
                NSInteger isShortIndex = 0;
                
                NSMutableArray *tempTitleArray = [NSMutableArray array];
                
                NSMutableArray *tempShortTitleArray = [NSMutableArray array];
                
                for (TFHppleElement *tempAElement in TitleElementArr) {
                    //获得标题
                    NSString *titleStr =  [tempAElement content];
                    
                    NSLog(@"titleStr %@",titleStr);
                    
                    if (isShortIndex == 0)
                    {
                        [tempTitleArray addObject:titleStr];
                        
                        isShortIndex ++;
                    }
                    else if (isShortIndex == 1)
                    {
                        [tempShortTitleArray addObject:titleStr];
                        
                        isShortIndex = 0;
                    }
                }
                
                
                saveHeroModel.heroNameArray = [NSArray arrayWithArray:tempTitleArray];
                
                saveHeroModel.heroNameForShortArray = [NSArray arrayWithArray:tempShortTitleArray];
                
#pragma mark 子节点链接
                
                NSArray *LinkElementArr = [tfElement searchWithXPathQuery:@"//a"];
                
                NSMutableArray *tempLinkArray = [NSMutableArray array];
                
                for (TFHppleElement *tempAElement in LinkElementArr) {
                    //获得链接
                    //1.获得子节点（正文连接节点） 2.获得节点属性值 3.加入到字典中
                    NSString * titleHrefStr = [tempAElement objectForKey:@"href"];
                    
                    NSLog(@"linkStr %@",titleHrefStr);
                    
                    [tempLinkArray addObject:titleHrefStr];
                }
                
                saveHeroModel.heroInfoLinkArray = [NSArray arrayWithArray:tempLinkArray];
                
            }
            
            if (aTypeID == 1)
            {
                self.saveMJHeroModel = saveHeroModel;
            }
            else if (aTypeID == 2)
            {
                self.saveZLHeroModel = saveHeroModel;
            }
            else if (aTypeID == 3)
            {
                self.saveLLHeroModel = saveHeroModel;
            }
            
            NSLog(@"saveMJHeroModel %@",self.saveMJHeroModel.heroNameArray[0]);
            
            NSLog(@"saveZLHeroModel %@",self.saveZLHeroModel.heroNameArray[0]);
            
            NSLog(@"saveLLHeroModel %@",self.saveLLHeroModel.heroNameArray[0]);
            
            [HeroTypeInfoModel insert:saveHeroModel resBlock:nil];
        }
    }];

}



-(void) initUI
{
    [HeroTypeInfoModel find:1 selectResultBlock:^(id selectResult) {
        
        HeroTypeInfoModel *getLocalModel = selectResult;
        
        NSLog(@"hero_nameArray11 %@",getLocalModel.heroNameArray[0]);
    }];
    
    [HeroTypeInfoModel find:2 selectResultBlock:^(id selectResult) {
        
        HeroTypeInfoModel *getLocalModel = selectResult;
        
        NSLog(@"hero_nameArray22 %@",getLocalModel.heroNameArray[0]);
    }];
    
    [HeroTypeInfoModel find:3 selectResultBlock:^(id selectResult) {
        
        HeroTypeInfoModel *getLocalModel = selectResult;
        
        NSLog(@"hero_nameArray33 %@",getLocalModel.heroNameArray[0]);
    }];
}

@end
