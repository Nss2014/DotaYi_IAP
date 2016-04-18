
//
//  FOXRadiusView.m
//  FoxRadiusDemo
//
//  Created by 徐惠雨 on 15/12/17.
//  Copyright © 2015年 XFoxer. All rights reserved.
//

#import "FOXRadiusView.h"

@interface FOXRadiusView ()

/** 填充的颜色 */
@property (nonatomic, strong) UIColor *bgColor;

@end

@implementation FOXRadiusView

- (void)dealloc
{
    _bgColor = nil;
}

/*!
 *  @brief 初始化
 *
 *  @param frame 视图大小
 *
 *  @return 视图self
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*!
 *  @brief 更改父视图的颜色
 *
 *  @param backgroundColor 背景颜色
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    [self setBgColor:backgroundColor];
}


/*!
 *  @brief 画可自定义显示圆角的视图
 *
 *  @param rect frame
 */
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:
                          
                                                   (_bottomLeftRadius?UIRectCornerBottomLeft:0)|
                                                   (_bottomRightRadius?UIRectCornerBottomRight:0)|
                                                   (_topLeftRadius?UIRectCornerTopLeft:0)|
                                                   (_topRightRadius?UIRectCornerTopRight:0)
                          
                                                     cornerRadii:CGSizeMake(_cornerRadius, _cornerRadius)];
    
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path.CGPath);
    //按照贝塞尔曲线路径收拢视图
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextAddRect(context, rect);
    //设置填充颜色
    CGContextSetFillColorWithColor(context, _bgColor.CGColor);
    CGContextFillPath(context);
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
    
}


@end
