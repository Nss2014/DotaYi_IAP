//
//  OddsViewController.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/4/17.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "OddsViewController.h"
#import "CollectionViewCell.h"

@interface OddsViewController ()

@property (nonatomic,strong) NSArray *dataSourceArray;

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
    self.dataSourceArray = [NSArray arrayWithObjects:
                            @"圣物关口",
                            @"支援法衣",
                            @"秘法圣所",
                            @"保护领地",
                            @"魅惑遗物",
                            @"远古兵器",
                            @"武器商人比泽",
                            @"饰品商人希娜",
                            @"Quel的密室",
                            @"奇迹古树",
                            @"黑市商人",
                            @"地精实验室",
                            @"地精商人", nil];
    
    self.dataImagesArray = [NSMutableArray array];
    
    for (int i=0; i<13; i++)
    {
        NSString *imageName = [NSString stringWithFormat:@"odds_image%d",i];
        
        [self.dataImagesArray addObject:imageName];
    }
}

-(void) initUI
{
    self.navigationItem.title = @"物品";
    
    [self addCollectionView];
    
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"MyCollectionCell"];
    
    //数据不够一屏时仍然滑动
    self.collectionView.alwaysBounceVertical = YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionCell" forIndexPath:indexPath];
    
    NSString *nameString = self.dataSourceArray[indexPath.row];
    
    NSString *imageString = self.dataImagesArray[indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:imageString];
    
    cell.descLabel.text = nameString;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH - (PADDING_WIDTH * 5)) / 4, (SCREEN_WIDTH - (PADDING_WIDTH * 5)) / 4 + 20);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(PADDING_WIDTH * 2, PADDING_WIDTH, PADDING_WIDTH, PADDING_WIDTH);
}

@end
