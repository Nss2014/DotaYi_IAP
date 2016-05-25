//
//  CustomGridPointView.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/25.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "CustomGridPointView.h"

@implementation CustomGridPointView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.gridTopValueLabel = [[UILabel alloc] init];
        
        self.gridTopValueLabel.textAlignment = NSTextAlignmentCenter;
        
        self.gridTopValueLabel.font = TEXT18_BOLD_FONT;
        
        self.gridTopValueLabel.textColor = XLS_COLOR_MAIN_GREEN;
        
        [self addSubview:self.gridTopValueLabel];
        
        self.gridBottomNameLabel = [[UILabel alloc] init];
        
        self.gridBottomNameLabel.textAlignment = NSTextAlignmentCenter;
        
        self.gridBottomNameLabel.font = TEXT12_FONT;
        
        self.gridBottomNameLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        
        [self addSubview:self.gridBottomNameLabel];
        
        WS(ws);
        
        [self.gridTopValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.mas_left);
            make.right.equalTo(ws.mas_right);
            make.top.equalTo(ws.mas_top);
            make.height.equalTo(ws.mas_height).multipliedBy(0.6);
        }];
        
        [self.gridBottomNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.mas_left);
            make.right.equalTo(ws.mas_right);
            make.top.equalTo(ws.gridTopValueLabel.mas_bottom);
            make.height.equalTo(ws.mas_height).multipliedBy(0.4);
        }];
    }
    return self;
}

@end


@implementation ThreeGridView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.customGridView1 = [[CustomGridPointView alloc] init];
        
        [self addSubview:self.customGridView1];
        
        self.customGridView2 = [[CustomGridPointView alloc] init];
        
        [self addSubview:self.customGridView2];
        
        self.customGridView3 = [[CustomGridPointView alloc] init];
        
        [self addSubview:self.customGridView3];
        
        self.customLineView1 = [[UIView alloc] init];
        
        self.customLineView1.backgroundColor = CLEAR_COLOR;
        
        [self addSubview:self.customLineView1];
        
        self.customLineView2 = [[UIView alloc] init];
        
        self.customLineView2.backgroundColor = CLEAR_COLOR;
        
        [self addSubview:self.customLineView2];
        
        WS(ws);
        
        [self.customGridView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.mas_left);
            make.top.equalTo(ws.mas_top);
            make.bottom.equalTo(ws.mas_bottom);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
        }];
        
        [self.customGridView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.customGridView1.mas_right);
            make.top.equalTo(ws.customGridView1.mas_top);
            make.bottom.equalTo(ws.customGridView1.mas_bottom);
            make.width.equalTo(ws.customGridView1.mas_width);
        }];
        
        [self.customGridView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.customGridView2.mas_right);
            make.top.equalTo(ws.customGridView2.mas_top);
            make.bottom.equalTo(ws.customGridView2.mas_bottom);
            make.right.equalTo(ws.mas_right);
        }];
        
        [self.customLineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.mas_top);
            make.bottom.equalTo(ws.mas_bottom);
            make.width.mas_equalTo(PIXL1_AUTO);
            make.right.equalTo(ws.customGridView1.mas_right);
        }];
        
        [self.customLineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.customLineView1.mas_top);
            make.bottom.equalTo(ws.customLineView1.mas_bottom);
            make.width.equalTo(ws.customLineView1.mas_width);
            make.right.equalTo(ws.customGridView2.mas_right);
        }];
    }
    return self;
}

@end
