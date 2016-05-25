//
//  JJCTopDataModel.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/25.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "JJCTopDataModel.h"

@implementation JJCTopDataModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.topRankString = @"0";
        
        self.topPointString = @"0";
        
        self.topWinPlayString = @"0";
        
        self.topLosePlayString = @"0";
        
        self.topTotalPlayString = @"0";
        
        self.topWinChanceString = @"0";
    }
    return self;
}

@end
