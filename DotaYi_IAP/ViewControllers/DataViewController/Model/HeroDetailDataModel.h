//
//  HeroDetailDataModel.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/6.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "CoreModel.h"

//配合&克制英雄推荐 模型
@interface MatchOrDefenceHeroModel : CoreModel

@property (nonatomic,copy) NSString *mdHeroImgString;

@property (nonatomic,copy) NSString *mdHeroLinkString;

@end

//推荐出装 模型
@interface RecommendEqumentsModel : CoreModel

@property (nonatomic,copy) NSString *reImgString;

@property (nonatomic,copy) NSString *reLinkString;

@end

@interface SkillsIntroduceModel : CoreModel

@property (nonatomic,copy) NSString *skillNameString;//技能名称

@property (nonatomic,copy) NSString *skillImgString;//图标

@property (nonatomic,copy) NSString *skillQuickNameString;//快捷键

@property (nonatomic,copy) NSString *skillIntroduceString;//介绍

@property (nonatomic,copy) NSString *skillDistanceString;//施法距离

@property (nonatomic,copy) NSString *skillIntervalString;//施法间隔

@property (nonatomic,copy) NSString *skillMPExpendString;//魔法消耗

@property (nonatomic,copy) NSString *skillLevelString;//等级提升介绍

@end


@interface HeroDetailDataModel : CoreModel

@property (nonatomic,copy) NSString *detailHeroId;//英雄id

@property (nonatomic,copy) NSString *detailHeroLinkString;//链接

#pragma mark - TableViewHeader

@property (nonatomic,copy) NSString *detailHeroPictureUrlString;//英雄背景图

@property (nonatomic,copy) NSString *detailHeroImgString;//头像

@property (nonatomic,copy) NSString *detailHeroNameString;//名称

@property (nonatomic,copy) NSString *detailHeroHPString;//血量

@property (nonatomic,copy) NSString *detailHeroMPString;//蓝量

@property (nonatomic,copy) NSString *detailHeroRangeString;//射程&移速

@property (nonatomic,copy) NSString *detailHeroAttackString;//攻击&攻速&护甲

@property (nonatomic,copy) NSString *detailHeroStrengthString;//力量&智力&敏捷


@property (nonatomic,strong) NSArray *detailHeroMatchArray;//配合英雄推荐

@property (nonatomic,strong) NSArray *detailHeroRestrainArray;//克制英雄推荐

@property (nonatomic,strong) NSArray *detaiHeroRecommendAddPointArray;//推荐加点方案

@property (nonatomic,strong) NSArray *detailHeroFirstRecommendEquipmentsArray;//推荐出装 初期

@property (nonatomic,strong) NSArray *detailHeroSecondRecommendEquipmentsArray;//推荐出装 中期

@property (nonatomic,strong) NSArray *detailHeroThirdRecommendEquipmentsArray;//推荐出装 后期

@property (nonatomic,strong) NSArray *detailHeroSkillsArray;//技能介绍

@end
