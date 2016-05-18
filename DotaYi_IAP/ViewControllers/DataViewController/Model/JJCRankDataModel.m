//
//  JJCRankDataModel.m
//  DotaYi_IAP
//
//  Created by nssnss on 16/5/18.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "JJCRankDataModel.h"

@implementation JJCRankDataModel

+(NSDictionary *)statementForNSArrayProperties{
    return @{@"DataModel":NSStringFromClass([DetailRankInfo class])};
}

@end


@implementation DetailRankInfo

@end