
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
        
        WS(ws);
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.mas_left).offset(PADDING_WIDTH);
            make.top.equalTo(ws.mas_top).offset(PADDING_WIDTH);
            make.right.equalTo(ws.mas_right);
            make.height.mas_equalTo(2 * PADDING_WIDTH);
        }];
        
    }
    return self;
}

@end
