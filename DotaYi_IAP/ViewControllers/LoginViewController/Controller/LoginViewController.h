//
//  LoginViewController.h
//  XLS_IAP
//
//  Created by 牛松松 on 16/4/11.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "BaseViewController.h"

//回调block
typedef void (^CallBackRefreshLoginBlock)();

@interface LoginViewController : BaseViewController
{
    CallBackRefreshLoginBlock _callBackBlock;
}

-(void) refreshBlock:(CallBackRefreshLoginBlock) callBackblock;

@end
