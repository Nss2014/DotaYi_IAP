//
//  OddsViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "OddsViewController.h"
#import "OddsTypeInfoModel.h"

@interface OddsViewController ()

@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@property (nonatomic,strong) NSMutableArray *dataImagesArray;

@end

@implementation OddsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self initData];
    
    [self initUI];
}

-(void) initData
{
    self.dataSourceArray = [NSMutableArray array];
    
    self.dataImagesArray = [NSMutableArray array];
    
    for (int i=0; i<13; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"odds_image%d",i];
        
        [self.dataImagesArray addObject:imageName];
    }
    
    WS(ws);
    
    __block NSInteger tempChange = 0;
    
    [OddsTypeInfoModel selectWhere:nil groupBy:nil orderBy:nil limit:nil selectResultsBlock:^(NSArray *selectResults) {
  
        tempChange ++;
        
        if (tempChange == 1)
        {
            if (selectResults && selectResults.count > 0)
            {
                for (OddsTypeInfoModel *findModel in selectResults)
                {
                    [ws.dataSourceArray addObject:findModel];
                }
            }
            else
            {
                [ws getOddsData];
            }
            
            //主线程更新界面
        }
    }];
}

-(void) getOddsData
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:DT_ODDSLISTDATA_URL]];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *oddsElements = [xpathParser searchWithXPathQuery:@"//div[@class='layAB']"];

    for (TFHppleElement *tfElement in oddsElements)
    {
        NSArray *oddsTypeNameArray = [tfElement searchWithXPathQuery:@"//div[@class='thA']"];
        
        for (int i=0; i<oddsTypeNameArray.count; i++)
        {
            TFHppleElement *tempAElement = oddsTypeNameArray[i];
            
            NSString *oddTypeName = tempAElement.content;
            
            NSString *oddImgName = self.dataImagesArray[i];
            
            OddsTypeInfoModel *saveModel = [[OddsTypeInfoModel alloc] init];
            
            saveModel.hostID = 10 + i;
            
            NSLog(@"oddImgName %@ %@",oddTypeName,oddImgName);
            
            saveModel.oddsTypeNameString = oddTypeName;
            
            saveModel.oddsTypeImgString = oddImgName;
            
            NSMutableArray *tempOddsArray = [NSMutableArray array];
            
            NSArray *getDetailOddsImgArray = [Tools getHtmlValueArrayWithXPathParser:tfElement XPathQuery:@"//div[@class='tbA']" DetailXPathQuery:@"//img" DetailKey:@"src"];
            
            NSArray *getDetailOddsLinkArray = [Tools getHtmlValueArrayWithXPathParser:tfElement XPathQuery:@"//div[@class='tbA']" DetailXPathQuery:@"//a" DetailKey:@"href"];
            
            for (int i=0; i<getDetailOddsImgArray.count; i++)
            {
                NSString *getOddsImgString = getDetailOddsImgArray[i];
                
                NSString *getOddsLinkString = getDetailOddsLinkArray[i];
                
                OddsMainModel *oddsMailModel = [[OddsMainModel alloc] init];
                
                oddsMailModel.hostID = 10 + i;
                
                oddsMailModel.oddsMainImgString = getOddsImgString;
                
                oddsMailModel.oddsMainLinkString = getOddsLinkString;
                
                [tempOddsArray addObject:oddsMailModel];
            }
            
            saveModel.oddsTypeArray = [NSArray arrayWithArray:tempOddsArray];
            
            [self.dataSourceArray addObject:saveModel];
        }
    }

    [OddsTypeInfoModel saveModels:self.dataSourceArray resBlock:nil];
}

-(void) initUI
{
    self.navigationItem.title = @"物品";
}

@end
