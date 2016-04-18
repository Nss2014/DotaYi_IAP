//
//  LoginInputTFView.h
//  XLS_IAP
//
//  Created by 牛松松 on 16/4/12.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GetVerifyCoreBtnDelegate <NSObject>

-(void) didClickGetVerifyButton;

@end

@interface LoginInputTFView : UIView

@property (nonatomic,strong) UILabel *LI_leftLabel;

@property (nonatomic,strong) UITextField *LI_rightTextField;

@end


@interface InputWithVerifyBtnView : UIView

@property (nonatomic,strong) UILabel *IW_leftLabel;

@property (nonatomic,strong) UITextField *IW_rightTextField;

@property (nonatomic,strong) UIView *IW_separetLineView;

@property (nonatomic,strong) CoreCountBtn *IW_getVerifyButton;

@property (nonatomic,weak) id<GetVerifyCoreBtnDelegate> delegate;

@end