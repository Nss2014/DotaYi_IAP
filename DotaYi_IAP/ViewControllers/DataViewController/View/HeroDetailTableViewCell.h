//
//  HeroDetailTableViewCell.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/20.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASHorizontalScrollView.h"
#import "HeroDetailDataModel.h"

@interface HeroDetailTableViewCell : UITableViewCell

@property (nonatomic,strong) ASHorizontalScrollView *HD_horiScrollView;//横向scrollView

@property (nonatomic,strong) NSArray *HD_scrollViewDataArray;//传入scrollView数据源

@property (nonatomic,assign) NSInteger HD_type;//0=@"配合英雄推荐",@"克制英雄推荐",@"加点方案推荐",@"初期出装推荐",@"中期出装推荐",@"后期出装推荐"

@end
