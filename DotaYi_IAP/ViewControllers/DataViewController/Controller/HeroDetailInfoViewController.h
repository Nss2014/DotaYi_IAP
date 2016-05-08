//
//  HeroDetailInfoViewController.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/5.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "BaseViewController.h"
#import "HeroDetailDataModel.h"

@interface HeroDetailInfoViewController : BaseViewController

@property (nonatomic,copy) NSString *sendHeroId;//传入英雄id 作为数据库hostID

@property (nonatomic,copy) NSString *sendHeroLink;//传入英雄链接 解析数据用

@end
