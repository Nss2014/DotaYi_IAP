//
//  ZYWSideView.h
//  ZYWQQ
//
//  Created by Devil on 16/2/23.
//  Copyright © 2016年 Devil. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideTableViewDelegate <NSObject>

-(void) didSelectRowAtIndex:(NSInteger) index;

@end

@interface ZYWSideView : UIView

@property (nonatomic,weak) id<SideTableViewDelegate> delegate;

@end
