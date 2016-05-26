
//
//  CollectionReusableView.m
//  CollectionView-PureCode
//
//  Created by chenyufeng on 15/10/30.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.title = [[UILabel alloc] init];
        
        self.title.textColor = COLOR_TITLE_BLACK;
        
        [self addSubview:self.title];
        
        self.signRoundView = [[UIView alloc] init];
        
        self.signRoundView.backgroundColor = XLS_COLOR_MAIN_GREEN;
        
        self.signRoundView.layer.cornerRadius = SECTION_ROUNDHEIGHT/2;
        
        self.signRoundView.clipsToBounds = YES;
        
        [self addSubview:self.signRoundView];
        
        WS(ws);
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.mas_left).offset(PADDING_WIDTH + SECTION_ROUNDHEIGHT + 8);
            make.top.equalTo(ws.mas_top).offset(PADDING_WIDTH);
            make.right.equalTo(ws.mas_right);
            make.height.mas_equalTo(2 * PADDING_WIDTH);
        }];
        
        [self.signRoundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(ws.title.mas_left).offset(-4);
            make.centerY.equalTo(ws.title.mas_centerY);
            make.width.mas_equalTo(SECTION_ROUNDHEIGHT);
            make.height.mas_equalTo(SECTION_ROUNDHEIGHT);
        }];
        
    }
    return self;
}

@end
