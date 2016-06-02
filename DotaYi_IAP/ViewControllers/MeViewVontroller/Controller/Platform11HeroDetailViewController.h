//
//  Platform11HeroDetailViewController.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/27.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "BaseViewController.h"
#import "MJGoodAtHeroModel.h"

@interface Platform11HeroDetailViewController : BaseViewController

@property (nonatomic,assign) BOOL isJJCType;//0=天梯  1=竞技场

@property (nonatomic,copy) MJGoodAtHeroModel *sendHeroModel;

@end
