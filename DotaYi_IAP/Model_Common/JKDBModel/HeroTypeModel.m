//
//  HeroTypeModel.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/4.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroTypeModel.h"

@implementation HeroTypeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.hero_nameArray = [NSMutableArray array];
        
        self.hero_infoLinkArray = [NSMutableArray array];
        
        self.hero_headImageURLArray = [NSMutableArray array];
        
        self.hero_nameForShortArray = [NSMutableArray array];
    }
    return self;
}

//+(NSDictionary *)objectClassInArray{
//    return @{@"hero_infoArray":NSStringFromClass([CommonHeroModel class])};
//}

@end