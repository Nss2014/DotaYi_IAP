//
//  BaseRoundradiusBackCell.h
//  Huaer_haokan_IAP
//
//  Created by 牛松松 on 16/3/3.
//  Copyright © 2016年 杨云鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FOXRadiusView.h"

typedef enum : NSUInteger {
    CR_typeTop = 0,
    CR_typeMiddle,
    CR_typeBottom,
    CR_typeAll,
    CR_typeNone
} CornerRadiusType;


@interface BaseRoundradiusBackCell : UITableViewCell

@property (nonatomic,strong) FOXRadiusView *base_backGroundView;

@property (nonatomic,assign) CornerRadiusType base_type;

@property (nonatomic,strong) UIView *base_bottomLineView;

@end
