//
//  LoginInputTFView.m
//  XLS_IAP
//
//  Created by 牛松松 on 16/4/12.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "LoginInputTFView.h"

@implementation LoginInputTFView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = WHITE_COLOR;
        
        self.LI_leftLabel = [[UILabel alloc] init];
        
        self.LI_leftLabel.textColor = COLOR_TITLE_BLACK;
        
        self.LI_leftLabel.font = TEXT14_FONT;
        
        [self addSubview:self.LI_leftLabel];
        
        self.LI_rightTextField = [[UITextField alloc] init];
        
        [self addSubview:self.LI_rightTextField];
        
        WS(ws);
        
        CGFloat padding = 10;
        
        [self.LI_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.mas_left).offset(padding/2);
            make.centerY.equalTo(ws.mas_centerY);
            make.width.mas_equalTo(50);
            make.height.equalTo(ws.mas_height);
        }];
        
        [self.LI_rightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.LI_leftLabel.mas_right).offset(padding);
            make.right.equalTo(ws.mas_right).offset(-padding/2);
            make.centerY.equalTo(ws.mas_centerY);
            make.height.equalTo(ws.mas_height);
        }];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.borderWidth = PIXL1_AUTO;
    
    self.layer.borderColor = COLOR_TITLE_LIGHTGRAY.CGColor;
    
    self.clipsToBounds = YES;
}

@end

@implementation InputWithVerifyBtnView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = WHITE_COLOR;
        
        self.IW_leftLabel = [[UILabel alloc] init];
        
        self.IW_leftLabel.textColor = COLOR_TITLE_BLACK;
        
        self.IW_leftLabel.font = TEXT14_FONT;
        
        [self addSubview:self.IW_leftLabel];
        
        self.IW_rightTextField = [[UITextField alloc] init];
        
        [self addSubview:self.IW_rightTextField];
        
        self.IW_separetLineView = [[UIView alloc] init];
        
        [self addSubview:self.IW_separetLineView];
        
        self.IW_getVerifyButton = [[CoreCountBtn alloc] init];
        
        self.IW_getVerifyButton.backgroundColorForNormal = CLEAR_COLOR;
        
        self.IW_getVerifyButton.countNum = WAIT_NUMBER;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(16.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.IW_getVerifyButton.status=CoreCountBtnStatusNormal;
        });
        
        [self addSubview:self.IW_getVerifyButton];
        
        WS(ws);
        
        CGFloat padding = 10;
        
        [self.IW_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.mas_left).offset(padding/2);
            make.centerY.equalTo(ws.mas_centerY);
            make.width.mas_equalTo(50);
            make.height.equalTo(ws.mas_height);
        }];
        
        [self.IW_rightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.IW_leftLabel.mas_right).offset(padding);
            make.right.equalTo(ws.IW_separetLineView.mas_left).offset(-padding/2);
            make.centerY.equalTo(ws.mas_centerY);
            make.height.equalTo(ws.mas_height);
        }];
        
        [self.IW_separetLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.IW_getVerifyButton.mas_left).offset(-padding/2);
            make.top.equalTo(ws.mas_top).offset(padding/2);
            make.bottom.equalTo(ws.mas_bottom).offset(-padding/2);
            make.width.mas_equalTo(1.0);
        }];
        
        [self.IW_getVerifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.mas_right).offset(-padding/2);
            make.top.equalTo(ws.mas_top).offset(padding/2);
            make.bottom.equalTo(ws.mas_bottom).offset(-padding/2);
            make.width.mas_equalTo(90);
        }];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.borderWidth = PIXL1_AUTO;
    
    self.layer.borderColor = COLOR_TITLE_LIGHTGRAY.CGColor;
    
    self.clipsToBounds = YES;
    
    self.IW_separetLineView.backgroundColor = XLS_COLOR_MAIN_RED;
    
    [self.IW_getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    self.IW_getVerifyButton.titleLabel.font = TEXT13_FONT;
    
    [self.IW_getVerifyButton setTitleColor:COLOR_TITLE_LIGHTGRAY forState:UIControlStateNormal];
    
    [self.IW_getVerifyButton addTarget:self action:@selector(getVerifyBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) getVerifyBtnPressed:(CoreCountBtn *)countBtn
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickGetVerifyButton)])
    {
        [self.delegate didClickGetVerifyButton];
    }
}

@end
