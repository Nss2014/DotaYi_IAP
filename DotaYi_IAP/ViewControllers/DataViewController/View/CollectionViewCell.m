
//
//  CollectionViewCell.m
//  CollectionView-PureCode
//
//  Created by chenyufeng on 15/10/30.
//  Copyright © 2015年 chenyufengweb. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        
        [self.imageView setUserInteractionEnabled:true];
        
        [self.contentView addSubview:self.imageView];
        
        self.descLabel = [[UILabel alloc] init];
        
        self.descLabel.textAlignment = NSTextAlignmentCenter;
        
        self.descLabel.font = TEXT12_FONT;
        
        self.descLabel.textColor = COLOR_TITLE_BLACK;
        
        [self.contentView addSubview:self.descLabel];
        
        WS(ws);
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left);
            make.top.equalTo(ws.contentView.mas_top);
            make.right.equalTo(ws.contentView.mas_right);
            make.height.equalTo(ws.imageView.mas_width);
        }];
        
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left);
            make.top.equalTo(ws.imageView.mas_bottom);
            make.right.equalTo(ws.contentView.mas_right);
            make.height.mas_equalTo(20);
        }];
        
    }
    return self;
}

@end
