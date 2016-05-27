//
//  DataViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/4/15.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "DataViewController.h"
#import "MainGridTableViewCell.h"
#import "HeroViewController.h"
#import "OddsViewController.h"
#import "RankListViewController.h"

@interface DataViewController ()

@property (nonatomic,strong) NSArray *gridDataArray;

@end

@implementation DataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

-(void) initData
{
    self.gridDataArray = [NSArray arrayWithObjects:@"英雄",@"物品",@"排行榜", nil];
}

-(void) initUI
{
    self.navigationItem.title = @"数据";
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    self.viwTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    self.viwTable.scrollEnabled = NO;
}

-(void) cellGridViewFirstTaped:(UITapGestureRecognizer *) sender
{
    NSInteger selectIndex = sender.view.tag - 6000;
    
    NSLog(@"selectIndex %ld",selectIndex);
    if (selectIndex == 0)
    {
        //英雄
        HeroViewController *heroVC = [[HeroViewController alloc] init];
        
        [self setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:heroVC animated:YES];
    }
}

-(void) cellGridViewSecondTaped:(UITapGestureRecognizer *) sender
{
    NSInteger selectIndex = sender.view.tag - 6000;
    
    NSLog(@"selectIndex %ld",selectIndex);
    if (selectIndex == 1)
    {
        //物品
        OddsViewController *oddsVC = [[OddsViewController alloc] init];
        
        [self setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:oddsVC animated:YES];
    }
}

-(void) cellGridViewThirdTaped:(UITapGestureRecognizer *) sender
{
    NSInteger selectIndex = sender.view.tag - 6000;
    
    NSLog(@"selectIndex %ld",selectIndex);
    if (selectIndex == 2)
    {
        //排行榜
        RankListViewController *rankListVC = [[RankListViewController alloc] init];
        
        [self setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:rankListVC animated:YES];
    }
}

#pragma mark 列表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.gridDataArray.count/COUNTPERCELL + self.gridDataArray.count%COUNTPERCELL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREEN_WIDTH/3) * GOLDENSEPARATE_SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellGrid";
    
    MainGridTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[MainGridTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [self setTableViewLeftAlignment:cell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *cellGridGesFirst = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellGridViewFirstTaped:)];
    
    UITapGestureRecognizer *cellGridGesSecond = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellGridViewSecondTaped:)];
    
    UITapGestureRecognizer *cellGridGesThird = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellGridViewThirdTaped:)];
    
    //第一列
    if (indexPath.row * COUNTPERCELL <= self.gridDataArray.count - 1)
    {
        NSString *nameStr = self.gridDataArray[indexPath.row * COUNTPERCELL];
        
        cell.MG_firstItemView.grid_nameLabel.text = nameStr;
        
        cell.MG_firstItemView.grid_ImageView.image = [UIImage imageNamed:@"main_leftNav_image"];
        
        cell.MG_firstItemView.userInteractionEnabled = YES;
        
        cell.MG_firstItemView.tag = 6000 + indexPath.row * COUNTPERCELL;
        
        [cell.MG_firstItemView addGestureRecognizer:cellGridGesFirst];
    }
    else
    {
        cell.MG_firstItemView.grid_nameLabel.text = @"";
    }
    
    //第二列
    if (indexPath.row * COUNTPERCELL + 1 < self.gridDataArray.count)
    {
        NSString *nameStr = self.gridDataArray[indexPath.row * COUNTPERCELL + 1];
        
        cell.MG_secondItemView.grid_nameLabel.text = nameStr;
        
        cell.MG_secondItemView.grid_ImageView.image = [UIImage imageNamed:@"main_leftNav_image"];
        
        cell.MG_secondItemView.userInteractionEnabled = YES;
        
        cell.MG_secondItemView.tag = 6000 + indexPath.row * COUNTPERCELL + 1;
        
        [cell.MG_secondItemView addGestureRecognizer:cellGridGesSecond];
    }
    else
    {
        cell.MG_secondItemView.grid_nameLabel.text = @"";
    }
    
    //第三列
    if (indexPath.row * COUNTPERCELL + 2 < self.gridDataArray.count + 1)
    {
        NSString *nameStr = self.gridDataArray[indexPath.row * COUNTPERCELL + 2];
        
        cell.MG_thirdItemView.grid_nameLabel.text = nameStr;
        
        cell.MG_thirdItemView.grid_ImageView.image = [UIImage imageNamed:@"main_leftNav_image"];
        
        cell.MG_thirdItemView.userInteractionEnabled = YES;
        
        cell.MG_thirdItemView.tag = 6000 + indexPath.row * COUNTPERCELL + 2;
        
        [cell.MG_thirdItemView addGestureRecognizer:cellGridGesThird];
    }
    else
    {
        cell.MG_thirdItemView.grid_nameLabel.text = @"";
    }
    
    return cell;
}

#pragma mark -  点击行响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//分割线左对齐
-(void)viewDidLayoutSubviews {
    if ([self.viwTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.viwTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.viwTable respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.viwTable setLayoutMargins:UIEdgeInsetsZero];
    }
}


@end
