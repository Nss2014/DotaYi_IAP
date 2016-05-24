//
//  OddsViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "OddsViewController.h"
#import "OddsTypeInfoModel.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"
#import "OddsDetailViewController.h"

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
    
    //取出数据库数据
    NSArray *getchannelDicArray = [[HP_Application sharedApplication].store getObjectById:DB_ODDS fromTable:DB_ODDS];
    
    NSArray *modelArray = [OddsTypeInfoModel mj_objectArrayWithKeyValuesArray:getchannelDicArray];
    
    if (modelArray.count)
    {
        for (OddsTypeInfoModel *typeModel in modelArray)
        {
            [self.dataSourceArray addObject:typeModel];
        }
    }
    else
    {
        [self getOddsData];
    }
    
    WS(ws);
    
    //主线程显示
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [ws.collectionView reloadData];
        
    });
}


-(void) getOddsData
{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:DT_ODDSLISTDATA_URL]];
    
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *oddsElements = [xpathParser searchWithXPathQuery:@"//div[@class='layAB']"];
    
    BOOL isParserSuccess = YES;
    
    for (TFHppleElement *tfElement in oddsElements)
    {
        NSArray *oddsTypeNameArray = [tfElement searchWithXPathQuery:@"//div[@class='thA']"];
        
        for (int i=0; i<oddsTypeNameArray.count; i++)
        {
            TFHppleElement *tempAElement = oddsTypeNameArray[i];
            
            NSString *oddTypeName = tempAElement.content;
            
            NSString *oddImgName = self.dataImagesArray[i];
            
            OddsTypeInfoModel *saveModel = [[OddsTypeInfoModel alloc] init];
            
            NSLog(@"oddImgName %@ %@",oddTypeName,oddImgName);
            
            saveModel.oddsTypeNameString = oddTypeName;
            
            saveModel.oddsTypeImgString = oddImgName;
            
            NSArray *getDetailOddsImgArray = [Tools getHtmlValueArrayWithXPathParser:tfElement XPathQuery:@"//div[@class='tbA']" DetailXPathQuery:@"//img" DetailKey:@"src"];
            
            NSArray *getDetailOddsLinkArray = [Tools getHtmlValueArrayWithXPathParser:tfElement XPathQuery:@"//div[@class='tbA']" DetailXPathQuery:@"//a" DetailKey:@"href"];
            
            if (getDetailOddsImgArray.count && getDetailOddsLinkArray.count)
            {
                for (int i=0; i<getDetailOddsImgArray.count; i++)
                {
                    NSString *getOddsImgString = getDetailOddsImgArray[i];
                    
                    NSString *getOddsLinkString = getDetailOddsLinkArray[i];
                    
                    OddsMainModel *oddsMailModel = [[OddsMainModel alloc] init];
                    
                    oddsMailModel.oddsMainImgString = getOddsImgString;
                    
                    oddsMailModel.oddsMainLinkString = getOddsLinkString;
                    
                    [saveModel.oddsTypeArray addObject:oddsMailModel];
                }
                
                [self.dataSourceArray addObject:saveModel];
            }
            else
            {
                isParserSuccess = NO;
                
                break;
            }
        }
        
        if (!isParserSuccess)
        {
            break;
        }
    }
    
    if (isParserSuccess)
    {
        //存入数据库
        //使用MJExtension 模型数组转换字典数组
        NSArray *channelDicArray = [OddsTypeInfoModel mj_keyValuesArrayWithObjectArray:self.dataSourceArray];
        
        if (channelDicArray != nil && ![channelDicArray isKindOfClass:[NSNull class]])
        {
            [[HP_Application sharedApplication].store putObject:channelDicArray
                                                         withId:DB_ODDS
                                                      intoTable:DB_ODDS];
        }
    }
    else
    {
        //解析出错  停止并报错  清空表 下次重新写入数据
        CoreSVPError(@"更新数据出错，请重试", nil);
        
        [[HP_Application sharedApplication].store clearTable:DB_ODDS];
    }
    
}

-(void) initUI
{
    self.navigationItem.title = @"物品";
    
    [self addCollectionView];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];
    
    [self.collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    UILabel *tipsFromLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -40, SCREEN_WIDTH, 30)];
    
    tipsFromLabel.numberOfLines = 0;
    
    tipsFromLabel.textAlignment = NSTextAlignmentCenter;
    
    tipsFromLabel.text = @"物品数据来自太平洋游戏网\n版本：6.81c";
    
    tipsFromLabel.font = TEXT12_FONT;
    
    tipsFromLabel.textColor = COLOR_TITLE_LIGHTGRAY;
    
    [self.collectionView addSubview:tipsFromLabel];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    OddsTypeInfoModel *typeModel = self.dataSourceArray[section];
    
    NSArray *detailModelArr = [OddsMainModel mj_objectArrayWithKeyValuesArray:typeModel.oddsTypeArray];
    
    NSArray *rowArray;
    
    if (section < 6)
    {
        rowArray = [detailModelArr subarrayWithRange : NSMakeRange (section * 12 , 12)];
    }
    else if (section == 6)
    {
        rowArray = [detailModelArr subarrayWithRange : NSMakeRange (section * 12 , 10)];
    }
    else
    {
        rowArray = [detailModelArr subarrayWithRange : NSMakeRange (section * 12 - 2, 12)];
    }

    return rowArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionCell" forIndexPath:indexPath];
    
    OddsTypeInfoModel *typeModel = self.dataSourceArray[indexPath.section];
    
    NSArray *detailModelArr = [OddsMainModel mj_objectArrayWithKeyValuesArray:typeModel.oddsTypeArray];

    NSArray *rowArray;
    
    if (indexPath.section < 6)
    {
        rowArray = [detailModelArr subarrayWithRange : NSMakeRange (indexPath.section * 12 , 12)];
    }
    else if (indexPath.section == 6)
    {
        rowArray = [detailModelArr subarrayWithRange : NSMakeRange (indexPath.section * 12 , 10)];
    }
    else
    {
        rowArray = [detailModelArr subarrayWithRange : NSMakeRange (indexPath.section * 12 - 2, 12)];
    }
    
    OddsMainModel *detailModel = rowArray[indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:detailModel.oddsMainImgString] placeholderImage:nil];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSourceArray.count;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusable = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        CollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        OddsTypeInfoModel *typeModel = self.dataSourceArray[indexPath.section];

        view.title.text = typeModel.oddsTypeNameString;
        
        view.title.font = TEXT16_BOLD_FONT;
        
        reusable = view;
    }
    
    return reusable;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OddsTypeInfoModel *typeModel = self.dataSourceArray[indexPath.section];
    
    NSArray *detailModelArr = [OddsMainModel mj_objectArrayWithKeyValuesArray:typeModel.oddsTypeArray];

    NSArray *rowArray;
    
    if (indexPath.section < 6)
    {
        rowArray = [detailModelArr subarrayWithRange : NSMakeRange (indexPath.section * 12 , 12)];
    }
    else if (indexPath.section == 6)
    {
        rowArray = [detailModelArr subarrayWithRange : NSMakeRange (indexPath.section * 12 , 10)];
    }
    else
    {
        rowArray = [detailModelArr subarrayWithRange : NSMakeRange (indexPath.section * 12 - 2, 12)];
    }
    
    OddsMainModel *detailModel = rowArray[indexPath.row];
    
    OddsDetailViewController *oddsDetailVC = [[OddsDetailViewController alloc] init];
    
    oddsDetailVC.sendOddId = [self getHeroIdFromLink:detailModel.oddsMainLinkString];
    
    oddsDetailVC.sendOddLink = detailModel.oddsMainLinkString;
    
    [self setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:oddsDetailVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - (PADDING_WIDTH * 5)) / 4, (SCREEN_WIDTH - (PADDING_WIDTH * 5)) / 4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(PADDING_WIDTH * 2, PADDING_WIDTH, PADDING_WIDTH, PADDING_WIDTH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(300, 20);
}

//从物品链接中提取物品id
-(NSString *) getHeroIdFromLink:(NSString *) theLink
{
    //http://db.pcgames.com.cn/dota/item_965.html
    
    NSString *getHeroId = @"";
    
    NSArray *sepLinkArray = [theLink componentsSeparatedByString:@".html"];
    
    if (sepLinkArray.count)
    {
        NSString *getSepFirstString = sepLinkArray[0];
        
        NSArray *sepSecArray = [getSepFirstString componentsSeparatedByString:@"item_"];
        
        if (sepSecArray.count)
        {
            //得到英雄id
            getHeroId = [sepSecArray lastObject];
        }
    }
    
    return getHeroId;
}

@end
