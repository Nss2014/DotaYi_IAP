//
//  HeroTypeInfoModel.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/4.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroTypeInfoModel.h"

@implementation HeroTypeInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+(NSDictionary *)statementForNSArrayProperties{
    return @{@"heroNameArray":NSStringFromClass([NSString class]),@"heroInfoLinkArray":NSStringFromClass([NSString class]),@"heroHeadImageURLArray":NSStringFromClass([NSString class]),@"heroNameForShortArray":NSStringFromClass([NSString class])};
}


@end
