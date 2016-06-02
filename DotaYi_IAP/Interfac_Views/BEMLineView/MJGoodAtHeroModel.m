//
//  MJGoodAtHeroModel.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/25.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "MJGoodAtHeroModel.h"

@implementation MJGoodAtHeroModel

#pragma mark- NSCopying
- (id)copyWithZone:(NSZone *)zone
{
    MJGoodAtHeroModel *myCopy = [[self class] allocWithZone:zone];
    
    myCopy.heroId = _heroId;
    
    myCopy.heroname = _heroname;
    
    myCopy.herotype = _herotype;
    
    myCopy.total = _total;
    
    myCopy.exp = _exp;
    
    myCopy.herokill = _herokill;
    
    myCopy.cscore = _cscore;
    
    myCopy.win = _win;
    
    myCopy.lost = _lost;
    
    myCopy.offline = _offline;
    
    myCopy.use = _use;
    
    myCopy.score = _score;
    
    myCopy.p_win = _p_win;
    
    myCopy.r_win = _r_win;
    
    myCopy.mvp = _mvp;
    
    myCopy.resv6 = _resv6;
    
    myCopy.resv8 = _resv8;
    
    myCopy.resv5 = _resv5;
    
    myCopy.resv7 = _resv7;
    
    myCopy.resv9 = _resv9;
    
    myCopy.resv10 = _resv10;
    
    myCopy.roshan = _roshan;
    
    return  myCopy;
}

@end
