//
//  OddsDetailDataModel.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/24.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailOddNeedObj : NSObject

@property (nonatomic,copy) NSString *needOddImg;//img

@property (nonatomic,copy) NSString *needOddLink;//link

@end


@interface OddsDetailDataModel : NSObject

@property (nonatomic,copy) NSString *oddsDetailId;//id

@property (nonatomic,copy) NSString *oddsDetailName;//name

@property (nonatomic,copy) NSString *oddsDetailLink;//link

@property (nonatomic,copy) NSString *oddsDetailImg;//img

@property (nonatomic,copy) NSString *oddsDetailIntroduce;//介绍

@property (nonatomic,strong) NSMutableArray *oddsDetailNeedArray;//合成需要的数组

@end
