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
        
        self.detailHeroMatchArray = [NSMutableArray array];
        
        self.detailHeroRestrainArray = [NSMutableArray array];
        
        self.detaiHeroRecommendAddPointArray = [NSMutableArray array];
        
        self.detailHeroRecommendEquipmentsArray = [NSMutableArray array];
        
        self.detailHeroSkillsArray = [NSMutableArray array];
    }
    return self;
}

@end
