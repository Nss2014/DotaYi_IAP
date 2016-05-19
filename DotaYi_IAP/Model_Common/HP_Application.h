//
//  HP_Application.h
//  全局的变量设置
//
//  Created by yangyp 15－07-28.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHeader.h"
#import "YTKKeyValueStore.h"

//单例，保存应用数据

@interface HP_Application : NSObject


@property (nonatomic,strong) YTKKeyValueStore *store;

+ (HP_Application *)sharedApplication;

@end

