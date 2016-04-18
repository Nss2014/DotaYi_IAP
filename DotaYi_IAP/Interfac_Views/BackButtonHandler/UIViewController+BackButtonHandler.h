//
//  UIViewController+BackButtonHandler.h
//  XMT_IAP
//
//  Created by 牛松松 on 15/11/17.
//  Copyright © 2015年 花儿绽放. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BackButtonHandlerProtocol <NSObject>

@optional

// Override this method in UIViewController derived class to handle 'Back' button click

-(BOOL)navigationShouldPopOnBackButton;

@end

@interface UIViewController (BackButtonHandler)<BackButtonHandlerProtocol>

@end
