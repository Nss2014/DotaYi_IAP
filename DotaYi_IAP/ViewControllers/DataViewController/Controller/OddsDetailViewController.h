//
//  OddsDetailViewController.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/11.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "BaseViewController.h"

@interface OddsDetailViewController : BaseViewController

@property (nonatomic,copy) NSString *sendOddId;//传入物品id  作为存储数据库的hostID

@property (nonatomic,copy) NSString *sendOddLink;

@end
