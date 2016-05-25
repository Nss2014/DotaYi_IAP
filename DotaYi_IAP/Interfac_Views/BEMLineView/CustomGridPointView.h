//
//  CustomGridPointView.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/25.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomGridPointView : UIView

@property (nonatomic,strong) UILabel *gridTopValueLabel;

@property (nonatomic,strong) UILabel *gridBottomNameLabel;

@end


@interface ThreeGridView : UIView

@property (nonatomic,strong) CustomGridPointView *customGridView1;

@property (nonatomic,strong) CustomGridPointView *customGridView2;

@property (nonatomic,strong) CustomGridPointView *customGridView3;

@property (nonatomic,strong) UIView *customLineView1;

@property (nonatomic,strong) UIView *customLineView2;

@end