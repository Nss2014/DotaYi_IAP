//
//  OddsTypeInfoModel.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/10.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "OddsTypeInfoModel.h"

@implementation OddsTypeInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.oddsTypeArray = [NSMutableArray array];
    }
    return self;
}

//+(NSDictionary *)statementForNSArrayProperties{
//    return @{@"oddsTypeArray":NSStringFromClass([OddsMainModel class])};
//}

@end


@implementation OddsMainModel

@end