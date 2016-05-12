//
//  OddsDetailViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/11.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "OddsDetailViewController.h"

@interface OddsDetailViewController ()

@end

@implementation OddsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

-(void) initData
{
    NSString *oddLinkString = [NSString stringWithFormat:@"http://db.pcgames.com.cn/dota/item_%@.html",self.sendOddId];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:oddLinkString]];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    //获取物品图片及简介
    
    NSArray *oddsElements = [xpathParser searchWithXPathQuery:@"//div[@class='part6']"];
    
    for (TFHppleElement *tfElement in oddsElements)
    {
        //物品图片
        NSString *getOddPicString = [Tools getHtmlValueWithXPathParser:tfElement XPathQuery:@"//div[@class='lpic']" DetailXPathQuery:@"//img" DetailKey:@"src"];
        
        NSLog(@"getOddPicString %@",getOddPicString);
        
        //名称 介绍 加强属性..
        NSString *getOddNameString = [Tools getHtmlValueWithXPathParser:tfElement XPathQuery:@"//div[@class='scontent']" DetailXPathQuery:@"//i" DetailKey:nil];
        
        NSLog(@"getOddNameString %@",getOddNameString);
    }
}

-(void) initUI
{
    
}

@end
