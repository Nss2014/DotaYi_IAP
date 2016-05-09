//
//  HeroDetailDataModel.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/6.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroDetailDataModel.h"

@implementation HeroDetailDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

+(NSDictionary *)statementForNSArrayProperties{
    return @{@"detailHeroMatchArray":NSStringFromClass([MatchOrDefenceHeroModel class]),
             @"detailHeroRestrainArray":NSStringFromClass([MatchOrDefenceHeroModel class]),
             @"detaiHeroRecommendAddPointArray":NSStringFromClass([NSString class]),
             @"detailHeroFirstRecommendEquipmentsArray":NSStringFromClass([RecommendEqumentsModel class]),
             @"detailHeroSecondRecommendEquipmentsArray":NSStringFromClass([RecommendEqumentsModel class]),
             @"detailHeroThirdRecommendEquipmentsArray":NSStringFromClass([RecommendEqumentsModel class]),
             @"detailHeroSkillsArray":NSStringFromClass([SkillsIntroduceModel class])};
}

@end

@implementation MatchOrDefenceHeroModel

@end

@implementation RecommendEqumentsModel

@end

@implementation SkillsIntroduceModel

@end
