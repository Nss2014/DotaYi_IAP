//
//  BaseRoundradiusBackCell.m
//  Huaer_haokan_IAP
//
//  Created by 牛松松 on 16/3/3.
//  Copyright © 2016年 杨云鹏. All rights reserved.
//

#import "BaseRoundradiusBackCell.h"

@implementation BaseRoundradiusBackCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.base_backGroundView = [[FOXRadiusView alloc] init];
        
        self.base_bottomLineView = [[UIView alloc] init];
        
        [self.contentView addSubview:self.base_backGroundView];
        
        [self.contentView addSubview:self.base_bottomLineView];
        
        CGFloat padding = 10;
        
        WS(ws);
        
        [self.base_backGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.contentView.mas_left).offset(padding);
            make.right.equalTo(ws.contentView.mas_right).offset(-padding);
            make.top.equalTo(ws.contentView.mas_top);
            make.bottom.equalTo(ws.contentView.mas_bottom);
        }];
        
        [self.base_bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(ws.base_backGroundView.mas_left);
            make.right.equalTo(ws.base_backGroundView.mas_right);
            make.bottom.equalTo(ws.base_backGroundView.mas_bottom);
            make.height.mas_equalTo(PIXL1_AUTO);
        }];
    }
    return self;
}

-(void)updateConstraints
{
    
    
    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView setNeedsLayout];
    
    [self.contentView layoutIfNeeded];
    
    self.contentView.backgroundColor = BACKGROUND_GRAYCOLOR;
    
    self.base_backGroundView.backgroundColor = WHITE_COLOR;
    
    self.base_bottomLineView.backgroundColor = SEPRATELINE_GRAYCOLOR;
    
    [self.base_backGroundView setCornerRadius:ACCOUNT_CORNERRADIUS];
    
    switch (self.base_type)
    {
        case CR_typeTop:
        {
            self.base_backGroundView.topLeftRadius = YES;
            
            self.base_backGroundView.topRightRadius = YES;
            
            self.base_backGroundView.bottomLeftRadius = NO;
            
            self.base_backGroundView.bottomRightRadius = NO;
            
            self.base_bottomLineView.hidden = NO;
        }
            break;
        case CR_typeMiddle:
        {
            self.base_backGroundView.topLeftRadius = NO;
            
            self.base_backGroundView.topRightRadius = NO;
            
            self.base_backGroundView.bottomLeftRadius = NO;
            
            self.base_backGroundView.bottomRightRadius = NO;
            
            self.base_bottomLineView.hidden = NO;
        }
            break;
        case CR_typeBottom:
        {
            self.base_backGroundView.topLeftRadius = NO;
            
            self.base_backGroundView.topRightRadius = NO;
            
            self.base_backGroundView.bottomLeftRadius = YES;
            
            self.base_backGroundView.bottomRightRadius = YES;
            
            self.base_bottomLineView.hidden = YES;
        }
            break;
        case CR_typeAll:
        {
            self.base_backGroundView.topLeftRadius = YES;
            
            self.base_backGroundView.topRightRadius = YES;
            
            self.base_backGroundView.bottomLeftRadius = YES;
            
            self.base_backGroundView.bottomRightRadius = YES;
            
            self.base_bottomLineView.hidden = YES;
        }
            break;
        case CR_typeNone:
        {
            self.base_backGroundView.topLeftRadius = NO;
            
            self.base_backGroundView.topRightRadius = NO;
            
            self.base_backGroundView.bottomLeftRadius = NO;
            
            self.base_backGroundView.bottomRightRadius = NO;
            
            self.base_bottomLineView.hidden = YES;
        }
            break;
            
        default:
            break;
    }

}

@end
