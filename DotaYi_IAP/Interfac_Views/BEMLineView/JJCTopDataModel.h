//
//  JJCTopDataModel.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/25.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JJCTopDataModel : NSObject

@property (nonatomic,copy) NSString *topPointString;//竞技场积分

@property (nonatomic,copy) NSString *topRankString;//排名

@property (nonatomic,copy) NSString *topWinChanceString;//胜率

@property (nonatomic,copy) NSString *topTotalPlayString;//总场次

@property (nonatomic,copy) NSString *topWinPlayString;//胜利场次

@property (nonatomic,copy) NSString *topLosePlayString;//失败场次

@end
