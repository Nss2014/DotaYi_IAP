//
//  OddsTypeInfoModel.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/10.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "CoreModel.h"

@interface OddsMainModel : NSObject

@property (nonatomic,copy) NSString *oddsMainImgString;

@property (nonatomic,copy) NSString *oddsMainLinkString;

@end

@interface OddsTypeInfoModel : NSObject

@property (nonatomic,copy) NSString *oddsTypeNameString;

@property (nonatomic,copy) NSString *oddsTypeImgString;

@property (nonatomic,strong) NSMutableArray *oddsTypeArray;

@end
