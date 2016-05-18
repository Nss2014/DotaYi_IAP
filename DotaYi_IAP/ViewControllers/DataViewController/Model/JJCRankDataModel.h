//
//  JJCRankDataModel.h
//  DotaYi_IAP
//
//  Created by nssnss on 16/5/18.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "CoreModel.h"

@interface DetailRankInfo : CoreModel

@property (nonatomic,copy) NSString *HeroId;

@property (nonatomic,copy) NSString *HeroName;

@property (nonatomic,copy) NSString *HeroType;

@property (nonatomic,copy) NSString *UserId;

@property (nonatomic,copy) NSString *UserName;

@property (nonatomic,copy) NSString *Rank;

@property (nonatomic,copy) NSString *Ranking;

@property (nonatomic,copy) NSString *ExtendProperties;

@property (nonatomic,copy) NSString *HeroHashCode;

@end

@interface JJCRankDataModel : CoreModel

@property (nonatomic,copy) NSString *Code;

@property (nonatomic,copy) NSString *Message;

@property (nonatomic,strong) NSMutableArray *DataModel;

@end
