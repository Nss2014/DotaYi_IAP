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

@end

@implementation HeroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self creatData];
    
    [self performSelector:@selector(initUI) withObject:nil afterDelay:1.5];
    
//    [self initUI];
}

-(void) creatData
{

    //获取敏捷英雄数据
    [self getHeroDataWithTypeId:1];
//
//    //获取智力英雄数据
//    [self getHeroDataWithTypeId:2];
//    
//    //获取力量英雄数据
//    [self getHeroDataWithTypeId:3];
}

-(void) getHeroDataWithTypeId:(NSInteger) aTypeID
{
    __block BOOL isNeedSaveData = YES;
    
    HeroTypeInfoModel *saveHeroModel = [[HeroTypeInfoModel alloc] init];
    
    [HeroTypeInfoModel find:aTypeID selectResultBlock:^(id selectResult) {
        
        HeroTypeInfoModel *getLocalModel = selectResult;
        
        if (getLocalModel.hero_nameArray.count > 0)
        {
            isNeedSaveData = NO;
        }
        else
        {
            isNeedSaveData = YES;
        }
    }];
    
    if (isNeedSaveData)
    {
        NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:DT_HEROLISTDATA_URL]];
        
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
        
        //英雄信息
        NSArray *heroElements = [xpathParser searchWithXPathQuery:@"//div[@class='tbB']"];
        
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
                        
                        saveHeroModel.hero_typeName = tempAElement.text;
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
                        
                        saveHeroModel.hero_typeName = tempAElement.text;
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
                        
                        saveHeroModel.hero_typeName = tempAElement.text;
                    }
                }
            }
            
#pragma mark 子节点头像
            
            NSArray *IMGElementsArr = [tfElement searchWithXPathQuery:@"//img"];
            
            for (TFHppleElement *tempAElement in IMGElementsArr)
            {
                
                NSString *imgStr = [tempAElement objectForKey:@"src"];
                
                NSLog(@"imgStr %@",imgStr);
                
                [saveHeroModel.hero_headImageURLArray addObject:tempAElement];
            }
            
#pragma mark 子节点标题
            
            NSArray *TitleElementArr = [tfElement searchWithXPathQuery:@"//span"];
            
            NSInteger isShortIndex = 0;
            
            for (TFHppleElement *tempAElement in TitleElementArr) {
                //获得标题
                NSString *titleStr =  [tempAElement content];
                
                NSLog(@"titleStr %@",titleStr);
                
                if (isShortIndex == 0)
                {
                    [saveHeroModel.hero_nameArray addObject:titleStr];
                }
                else if (isShortIndex == 1)
                {
                    [saveHeroModel.hero_nameForShortArray addObject:titleStr];
                }
                
                isShortIndex ++;
            }
            
#pragma mark 子节点链接
            
            NSArray *LinkElementArr = [tfElement searchWithXPathQuery:@"//a"];
            
            for (TFHppleElement *tempAElement in LinkElementArr) {
                //获得链接
                //1.获得子节点（正文连接节点） 2.获得节点属性值 3.加入到字典中
                NSString * titleHrefStr = [tempAElement objectForKey:@"href"];
                
                NSLog(@"linkStr %@",titleHrefStr);
                
                [saveHeroModel.hero_infoLinkArray addObject:titleHrefStr];
            }
            
        }
        
        [HeroTypeInfoModel save:saveHeroModel resBlock:nil];
    }
}



-(void) initUI
{
    [HeroTypeInfoModel find:1 selectResultBlock:^(id selectResult) {
        
        HeroTypeInfoModel *getLocalModel = selectResult;
        
        NSLog(@"hero_nameArray %@",getLocalModel.hero_nameArray);
    }];
}

@end
