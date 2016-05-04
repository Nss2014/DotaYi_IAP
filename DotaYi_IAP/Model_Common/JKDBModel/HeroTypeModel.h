//
//  HeroTypeModel.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/4.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "CoreModel.h"

@interface HeroTypeModel : CoreModel

@property (nonatomic,copy) NSString *hero_typeName;//敏捷&智力&力量

@property (nonatomic,strong) NSMutableArray *hero_headImageURLArray;//头像

@property (nonatomic,strong) NSMutableArray *hero_nameArray;//名称

@property (nonatomic,strong) NSMutableArray *hero_nameForShortArray;//简称

@property (nonatomic,strong) NSMutableArray *hero_infoLinkArray;//信息链接

@end