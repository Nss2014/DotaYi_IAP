//
//  HeroDetailDataModel.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/6.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "CoreModel.h"

@interface HeroDetailDataModel : CoreModel

@property (nonatomic,copy) NSString *detailHeroId;//英雄id

@property (nonatomic,copy) NSString *detailHeroLinkString;//链接

#pragma mark - TableViewHeader

@property (nonatomic,copy) NSString *detailHeroPictureUrlString;//英雄背景图

@property (nonatomic,copy) NSString *detailHeroNameString;//名称

@property (nonatomic,copy) NSString *detailHeroHPString;//血量

@property (nonatomic,copy) NSString *detailHeroMPString;//蓝量

@property (nonatomic,copy) NSString *detailHeroAttackString;//攻击&攻速&护甲

@property (nonatomic,copy) NSString *detailHeroStrengthString;//力量&智力&敏捷


@property (nonatomic,strong) NSMutableArray *detailHeroMatchArray;//配合英雄推荐

@property (nonatomic,strong) NSMutableArray *detailHeroRestrainArray;//克制英雄推荐

@property (nonatomic,strong) NSMutableArray *detaiHeroRecommendAddPointArray;//推荐加点方案

@property (nonatomic,strong) NSMutableArray *detailHeroRecommendEquipmentsArray;//推荐出装

@property (nonatomic,strong) NSMutableArray *detailHeroSkillsArray;//技能介绍

@end
