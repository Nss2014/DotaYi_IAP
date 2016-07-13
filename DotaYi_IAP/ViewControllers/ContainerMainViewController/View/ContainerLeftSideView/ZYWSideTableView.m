//
//  ZYWSideTableView.m
//  ZYWQQ
//
//  Created by Devil on 16/2/23.
//  Copyright © 2016年 Devil. All rights reserved.
//

#import "ZYWSideTableView.h"

@interface ZYWSideTableView()
@property(nonatomic,strong)NSMutableArray *arrayM;


@end

@implementation ZYWSideTableView
//    实例化
-(NSMutableArray *)arrayM{
    if (_arrayM==nil) {
        _arrayM=[NSMutableArray array];
    }
    return _arrayM;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    //    设置代理和数据源
//    self.delegate=self;
//    self.dataSource=self;
    
    self.rowHeight=50;
    
    self.separatorStyle=NO;
    return  self;
}

@end
