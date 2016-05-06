//
//  HeroViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroViewController.h"
#import "HeroTypeInfoModel.h"
#import "CollectionViewCell.h"
#import "CollectionReusableView.h"
#import "HeroDetailInfoViewController.h"
#import "HeroDetailDataModel.h"

@interface HeroViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(strong,nonatomic) UICollectionView *collectionView;

@property (nonatomic,strong) HeroTypeInfoModel *saveMJHeroModel;

@property (nonatomic,strong) HeroTypeInfoModel *saveZLHeroModel;

@property (nonatomic,strong) HeroTypeInfoModel *saveLLHeroModel;

@end

@implementation HeroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getHeroData];
    
    [self creatCollectionViewData];
    
    [self setViewUI];
}

-(void) setViewUI
{
    self.navigationItem.title = @"英雄";
}

-(void) creatCollectionViewData
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:[[UIScreen mainScreen] bounds] collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
}

-(void) getHeroData
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
        
        NSLog(@"getLocalModel %@",getLocalModel);
        
        if (getLocalModel)
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
            
            [HeroTypeInfoModel insert:saveHeroModel resBlock:nil];
        }
        
        //主线程显示
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [ws.collectionView reloadData];
            
        });
    }];

}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.saveMJHeroModel.heroHeadImageURLArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionCell" forIndexPath:indexPath];
    
    NSString *heroHeadImgUrl;
    
    NSString *heroNameString;
    
    NSString *heroNameForShortString;
    
    if (indexPath.section == 0)
    {
        heroHeadImgUrl = self.saveMJHeroModel.heroHeadImageURLArray[indexPath.row];
        
        heroNameString = self.saveMJHeroModel.heroNameArray[indexPath.row + 1];
        
        heroNameForShortString = self.saveMJHeroModel.heroNameForShortArray[indexPath.row + 1];
    }
    else if (indexPath.section == 1)
    {
        heroHeadImgUrl = self.saveZLHeroModel.heroHeadImageURLArray[indexPath.row];
        
        heroNameString = self.saveZLHeroModel.heroNameArray[indexPath.row + 1];
        
        heroNameForShortString = self.saveZLHeroModel.heroNameForShortArray[indexPath.row + 1];
    }
    else if (indexPath.section == 2)
    {
        heroHeadImgUrl = self.saveLLHeroModel.heroHeadImageURLArray[indexPath.row];
        
        heroNameString = self.saveLLHeroModel.heroNameArray[indexPath.row + 1];
        
        heroNameForShortString = self.saveLLHeroModel.heroNameForShortArray[indexPath.row + 1];
    }
    
    NSString *heroNameShortStr;
    
    NSArray *sepShortNameArr = [heroNameForShortString componentsSeparatedByString:@"简称："];
    
    if (sepShortNameArr.count > 1)
    {
        heroNameShortStr = [NSString stringWithFormat:@"(%@)",sepShortNameArr[1]];
    }
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:heroHeadImgUrl] placeholderImage:nil];
    
    cell.descLabel.text = [NSString stringWithFormat:@"%@%@",heroNameString,heroNameShortStr];
    
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusable = nil;
    
    if (kind == UICollectionElementKindSectionHeader)
    {
        CollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        if (indexPath.section == 0)
        {
            view.title.text = self.saveMJHeroModel.heroTypeName;
        }
        else if (indexPath.section == 1)
        {
            view.title.text = self.saveZLHeroModel.heroTypeName;
        }
        else if (indexPath.section == 2)
        {
            view.title.text = self.saveLLHeroModel.heroTypeName;
        }
        
        reusable = view;
    }
    
    return reusable;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString *message = [[NSString alloc] initWithFormat:@"你点击了第%ld个section，第%ld个cell",(long)indexPath.section,(long)indexPath.row];
    
    NSString *heroLinkString = @"";
    
    if (indexPath.section == 0)
    {
        heroLinkString = self.saveMJHeroModel.heroInfoLinkArray[indexPath.row];
    }
    else if (indexPath.section == 1)
    {
        heroLinkString = self.saveZLHeroModel.heroInfoLinkArray[indexPath.row];
    }
    else if (indexPath.section == 2)
    {
        heroLinkString = self.saveLLHeroModel.heroInfoLinkArray[indexPath.row];
    }

    HeroDetailInfoViewController *heroDetailVC = [[HeroDetailInfoViewController alloc] init];
    
    heroDetailVC.sendHeroDetailModel = [[HeroDetailDataModel alloc] init];
    
    heroDetailVC.sendHeroDetailModel.detailHeroLinkString = heroLinkString;
    
    heroDetailVC.sendHeroDetailModel.detailHeroId = [self getHeroIdFromLink:heroLinkString];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:heroDetailVC animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - (PADDING_WIDTH * 4)) / 3, (SCREEN_WIDTH - (PADDING_WIDTH * 4)) / 3 + 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(PADDING_WIDTH * 2, PADDING_WIDTH, PADDING_WIDTH, PADDING_WIDTH);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(300, 20);
}

//从英雄链接中提取英雄id
-(NSString *) getHeroIdFromLink:(NSString *) theLink
{
    //http://fight.pcgames.com.cn/warcraft/dota/heros/1103/2158993.html
    
    NSString *getHeroId = @"";
    
    NSArray *sepLinkArray = [theLink componentsSeparatedByString:@".html"];
    
    if (sepLinkArray.count)
    {
        NSString *getSepFirstString = sepLinkArray[0];
        
        NSArray *sepSecArray = [getSepFirstString componentsSeparatedByString:@"/"];
        
        if (sepSecArray.count)
        {
            //得到英雄id
            getHeroId = [sepSecArray lastObject];
        }
    }
    
    return getHeroId;
}

@end
