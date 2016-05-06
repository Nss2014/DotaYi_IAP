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
    NSLog(@"detailHeroLinkString %@",self.sendHeroDetailModel.detailHeroLinkString);
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.sendHeroDetailModel.detailHeroLinkString]];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    //TableHeader数据（头像、背景图片、名称、指数、初始属性）
    [self getTableHeaderData:xpathParser];
    
    //section数据
    //技能介绍
    [self getSkillIntroduceData:xpathParser];
    
    //推荐加点方案
    [self getRecommendAddpointData:xpathParser];

    //配合英雄推荐
    [self getMatchHeroData:xpathParser];
    
    //克制英雄推荐
    [self getRestrainHeroData:xpathParser];
    
    //推荐出装
    [self getRecommendEquipmentsData:xpathParser];
}


-(void) getTableHeaderData:(TFHpple *) xpathParser
{
    //英雄背景图
    NSArray *picMainElementsArr = [xpathParser searchWithXPathQuery:@"//div[@class='dPic fl']"];
    
    for (TFHppleElement *picElement in picMainElementsArr)
    {
        NSArray *IMGElementsArr = [picElement searchWithXPathQuery:@"//img"];
        
        for (TFHppleElement *tempAElement in IMGElementsArr)
        {
            NSString *imgStr = [tempAElement objectForKey:@"src"];
            
            NSLog(@"imgStr %@",imgStr);
        }
    }
    

    
}

-(void) getSkillIntroduceData:(TFHpple *) xpathParser
{
    
}

-(void) getMatchHeroData:(TFHpple *) xpathParser
{
    
}

-(void) getRestrainHeroData:(TFHpple *) xpathParser
{
    
}

-(void) getRecommendAddpointData:(TFHpple *) xpathParser
{
    
}

-(void) getRecommendEquipmentsData:(TFHpple *) xpathParser
{
    
}

-(void) initHeroDetailUI
{   
    
}

@end
