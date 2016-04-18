//
//  BaseRespObject.h
//  HaokanBG_IAP
//
//  Created by 牛松松 on 16/3/21.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRespObject : NSObject

@property (nonatomic,copy) NSString *msg;

@property (nonatomic,copy) NSNumber *ret;

@property (nonatomic,copy) NSNumber *total;

@end
