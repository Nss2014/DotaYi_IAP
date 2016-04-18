//
//  FOXRadiusView.h
//  FoxRadiusDemo
//
//  Created by 徐惠雨 on 15/12/17.
//  Copyright © 2015年 XFoxer. All rights reserved.
//

#import <UIKit/UIKit.h>


/*!@brief
 *   options  可以设置view视图任意四个角是否有圆角，解决一些特殊设计圆角问题
 **/

@interface FOXRadiusView : UIView

/** 是否有左上圆角 */
@property (nonatomic, assign) BOOL topLeftRadius;

/** 是否有右上圆角 */
@property (nonatomic, assign) BOOL topRightRadius;

/** 是否有左下圆角 */
@property (nonatomic, assign) BOOL bottomLeftRadius;

/** 是否有右下圆角 */
@property (nonatomic, assign) BOOL bottomRightRadius;

/** 圆角大小 */
@property (nonatomic, assign) CGFloat cornerRadius;



@end
