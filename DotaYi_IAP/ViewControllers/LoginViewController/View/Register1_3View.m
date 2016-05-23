//
//  Register1_3View.m
//  XMT_IAP
//
//  Created by 牛松松 on 15/11/13.
//  Copyright © 2015年 花儿绽放. All rights reserved.
//

#import "Register1_3View.h"

@implementation Register1_3View

@end


@implementation RegisteFrontView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self addSubview:self.RF_textField1];
        
        [self addSubview:self.RF_tfLineView1];
        
        [self addSubview:self.RF_textField2];
        
        [self addSubview:self.RF_tfLineView2];
        
        [self addSubview:self.RF_textField3];
        
        [self addSubview:self.RF_tfLineView3];
        
        [self addSubview:self.RF_verifyCodeImageView];
        
        [self addSubview:self.RF_doneButton];
    }
    return self;
}

-(void)updateConstraints
{
    [super updateConstraints];
    
    WS(ws);
    
    [self.RF_textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).offset(GRAPHIC_EDGE * 4);
        make.right.equalTo(ws.mas_right).offset(-GRAPHIC_EDGE * 4);
        make.top.equalTo(ws.mas_top).offset(SCREEN_WIDTH / 8);
        make.height.mas_equalTo(30);
    }];
    
    [self.RF_tfLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.RF_textField1.mas_left).offset(-GRAPHIC_EDGE);
        make.right.equalTo(ws.RF_textField1.mas_right).offset(GRAPHIC_EDGE);
        make.bottom.equalTo(ws.RF_textField1.mas_bottom);
        make.height.mas_equalTo(PIXL1_AUTO_6PLUS * 2);
    }];
    
    [self.RF_textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).offset(GRAPHIC_EDGE * 4);
        make.right.equalTo(ws.mas_right).offset(-GRAPHIC_EDGE * 4);
        make.top.equalTo(ws.RF_textField1.mas_bottom).offset(GRAPHIC_EDGE * 3);
        make.height.mas_equalTo(30);
    }];
    
    [self.RF_tfLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.RF_textField2.mas_left).offset(-GRAPHIC_EDGE);
        make.right.equalTo(ws.RF_textField2.mas_right).offset(GRAPHIC_EDGE);
        make.bottom.equalTo(ws.RF_textField2.mas_bottom);
        make.height.mas_equalTo(PIXL1_AUTO_6PLUS * 2);
    }];
    
    [self.RF_textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).offset(GRAPHIC_EDGE * 4);
        make.right.equalTo(ws.mas_right).offset(-180);
        make.top.equalTo(ws.RF_tfLineView2.mas_bottom).offset(GRAPHIC_EDGE * 3);
        make.height.mas_equalTo(30);
    }];
    
    [self.RF_tfLineView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.RF_textField3.mas_left).offset(-GRAPHIC_EDGE);
        make.right.equalTo(ws.RF_textField3.mas_right).offset(GRAPHIC_EDGE);
        make.bottom.equalTo(ws.RF_textField3.mas_bottom);
        make.height.equalTo(ws.RF_tfLineView2.mas_height);
    }];
    
    [self.RF_verifyCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.RF_tfLineView3.mas_right).offset(GRAPHIC_EDGE);
        make.bottom.equalTo(ws.RF_tfLineView3.mas_bottom);
        make.right.equalTo(ws.RF_tfLineView2.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [self.RF_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).offset(GRAPHIC_EDGE * 2);
        make.right.equalTo(ws.mas_right).offset(-GRAPHIC_EDGE * 2);
        make.top.equalTo(ws.RF_tfLineView3.mas_bottom).offset(GRAPHIC_EDGE * 4);
        make.height.mas_equalTo(sGapLength);
    }];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.layer.cornerRadius = CORNERRADIUS_BUTTON;
    
    self.clipsToBounds = YES;
    
    self.RF_textField1.font = TEXT16_BOLD_FONT;
    
    self.RF_textField2.font = TEXT16_BOLD_FONT;
    
    self.RF_textField3.font = TEXT16_BOLD_FONT;
    
    self.RF_textField1.textColor = COLOR_TITLE_BLACK;
    
    self.RF_textField2.textColor = COLOR_TITLE_BLACK;
    
    self.RF_textField3.textColor = COLOR_TITLE_BLACK;
    
    self.RF_tfLineView1.backgroundColor = CELL_LINE_COLOR;
    
    self.RF_tfLineView2.backgroundColor = CELL_LINE_COLOR;
    
    self.RF_tfLineView3.backgroundColor = CELL_LINE_COLOR;
    
    self.RF_textField1.keyboardType = UIKeyboardTypeNumberPad;
    
    [self.RF_doneButton setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    
    self.RF_doneButton.titleLabel.font = TEXT18_FONT;
    
    self.RF_doneButton.backgroundColor = XLS_COLOR_MAIN_GRAY;
    
    self.RF_doneButton.layer.cornerRadius = CORNERRADIUS_BUTTON;
    
    self.RF_doneButton.clipsToBounds = YES;
}

#pragma mark - Setters

-(UIImageView *)RF_verifyCodeImageView
{
    if (!_RF_verifyCodeImageView)
    {
        _RF_verifyCodeImageView = [[UIImageView alloc] init];
    }
    return _RF_verifyCodeImageView;
}

-(UITextField *)RF_textField3
{
    if (!_RF_textField3)
    {
        _RF_textField3 = [[UITextField alloc] init];
    }
    return _RF_textField3;
}

-(UIView *)RF_tfLineView3
{
    if (!_RF_tfLineView3)
    {
        _RF_tfLineView3 = [[UIView alloc] init];
    }
    return _RF_tfLineView3;
}

-(UIButton *)RF_doneButton
{
    if (!_RF_doneButton)
    {
        _RF_doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }
    return _RF_doneButton;
}

-(UITextField *)RF_textField1
{
    if (!_RF_textField1)
    {
        _RF_textField1 = [[UITextField alloc] init];
    }
    return _RF_textField1;
}

-(UITextField *)RF_textField2
{
    if (!_RF_textField2)
    {
        _RF_textField2 = [[UITextField alloc] init];
    }
    return _RF_textField2;
}

-(UIView *)RF_tfLineView1
{
    if (!_RF_tfLineView1)
    {
        _RF_tfLineView1 = [[UIView alloc] init];
    }
    return _RF_tfLineView1;
}

-(UIView *)RF_tfLineView2
{
    if (!_RF_tfLineView2)
    {
        _RF_tfLineView2 = [[UIView alloc] init];
    }
    return _RF_tfLineView2;
}

@end