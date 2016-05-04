//
//  HeroTypeInfoModel.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/4.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "CoreModel.h"

@interface HeroTypeInfoModel : CoreModel

@property (nonatomic,copy) NSString *heroTypeName;//敏捷&智力&力量

@property (nonatomic,strong) NSArray *heroHeadImageURLArray;//头像

@property (nonatomic,strong) NSArray *heroNameArray;//名称

@property (nonatomic,strong) NSArray *heroNameForShortArray;//简称

@property (nonatomic,strong) NSArray *heroInfoLinkArray;//信息链接

@end
