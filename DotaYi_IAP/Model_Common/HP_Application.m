//
//  HP_Application.m
//  全局的变量设置
//
//  Created by yangyp 15－07-28.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "HP_Application.h"
#import "Tools.h"

@implementation HP_Application
static HP_Application *_sharedApplication = nil;

+ (HP_Application *)sharedApplication
{
    if (!_sharedApplication)
    {
        _sharedApplication = [[self alloc] init];
    }
    return _sharedApplication;
}

//初始化
- (id)init
{
    if ((self = [super init]))
    {
        NSUserDefaults *userdefault=[NSUserDefaults standardUserDefaults];
        
        
        
        [userdefault synchronize];
    }
    return self;
}

-(YTKKeyValueStore *)store
{
    if (!_store)
    {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/main.db"];
        //建数据库
        _store = [[YTKKeyValueStore alloc] initWithDBWithPath:path];
    }
    return _store;
}

@end
