//
//  HeroViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroViewController.h"

@interface HeroViewController ()

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
    NSString *urlstr = @"http://fight.pcgames.com.cn/warcraft/dota/heros/";
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlstr]];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
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
        }
    }
    
    //英雄信息
    NSArray *heroElements = [xpathParser searchWithXPathQuery:@"//div[@class='tbB']"];
    
    for (TFHppleElement *tfElement in heroElements)
    {
#pragma mark 子节点头像
        
        NSArray *IMGElementsArr = [tfElement searchWithXPathQuery:@"//img"];
        
        for (TFHppleElement *tempAElement in IMGElementsArr)
        {
            
            NSString *imgStr = [tempAElement objectForKey:@"src"];
            
            NSLog(@"imgStr %@",imgStr);
        }
        
#pragma mark 子节点标题
        
        NSArray *TitleElementArr = [tfElement searchWithXPathQuery:@"//span"];
        
        for (TFHppleElement *tempAElement in TitleElementArr) {
            //获得标题
            NSString *titleStr =  [tempAElement content];
            
            NSLog(@"titleStr %@",titleStr);
            
            
        }
        
#pragma mark 子节点链接
        
        NSArray *LinkElementArr = [tfElement searchWithXPathQuery:@"//a"];
        
        for (TFHppleElement *tempAElement in LinkElementArr) {
            //获得链接
            //1.获得子节点（正文连接节点） 2.获得节点属性值 3.加入到字典中
            NSString * titleHrefStr = [tempAElement objectForKey:@"href"];
            
            NSLog(@"linkStr %@",titleHrefStr);
        }
    }
    
}

-(void) initUI
{
    
}
@end
