//
//  HeroDetailTableViewCell.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/5/20.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "HeroDetailTableViewCell.h"

@interface HeroDetailTableViewCell ()

@end

@implementation HeroDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.HD_horiScrollView = [[ASHorizontalScrollView alloc] init];
        
        [self.contentView addSubview:self.HD_horiScrollView];
    }
    
    return self;
}

-(void)updateConstraints
{
    WS(ws);
    
    [self.HD_horiScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.contentView.mas_left);
        make.top.equalTo(ws.contentView.mas_top);
        make.right.equalTo(ws.contentView.mas_right);
        make.bottom.equalTo(ws.contentView.mas_bottom).offset(-PADDING_WIDTH/2);
    }];

    [super updateConstraints];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    switch (self.HD_type)
    {
        case 0:
        {
            for (int i=0; i<self.HD_scrollViewDataArray.count; i++)
            {
                MatchOrDefenceHeroModel *matchOrDefenceModel = self.HD_scrollViewDataArray[i];
                
                UIImageView *hdImgView = [[UIImageView alloc] init];
                
                NSLog(@"mdHeroImgString %@",matchOrDefenceModel.mdHeroImgString);
                
                [hdImgView sd_setImageWithURL:[NSURL URLWithString:matchOrDefenceModel.mdHeroImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                
                [tempArray addObject:hdImgView];
            }
            
        }
            break;
        case 1:
        {
            for (int i=0; i<self.HD_scrollViewDataArray.count; i++)
            {
                MatchOrDefenceHeroModel *matchOrDefenceModel = self.HD_scrollViewDataArray[i];
                
                UIImageView *hdImgView = [[UIImageView alloc] init];
                
                NSLog(@"mdHeroImgString %@",matchOrDefenceModel.mdHeroImgString);
                
                [hdImgView sd_setImageWithURL:[NSURL URLWithString:matchOrDefenceModel.mdHeroImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                
                [tempArray addObject:hdImgView];
            }
        }
            break;
        case 2:
        {
            for (int i=0; i<self.HD_scrollViewDataArray.count; i++)
            {
                NSString *imgString = self.HD_scrollViewDataArray[i];
                
                UIImageView *hdImgView = [[UIImageView alloc] init];
                
                NSLog(@"imgString %@",imgString);
                
                [hdImgView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                
                [tempArray addObject:hdImgView];
            }
        }
            break;
        case 3:
        {
            for (int i=0; i<self.HD_scrollViewDataArray.count; i++)
            {
                RecommendEqumentsModel *recommendEqumentsModel = self.HD_scrollViewDataArray[i];
                
                UIImageView *hdImgView = [[UIImageView alloc] init];
                
                NSLog(@"recommendEqumentsModel.reImgString %@",recommendEqumentsModel.reImgString);
                
                [hdImgView sd_setImageWithURL:[NSURL URLWithString:recommendEqumentsModel.reImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                
                [tempArray addObject:hdImgView];
            }
        }
            break;
        case 4:
        {
            for (int i=0; i<self.HD_scrollViewDataArray.count; i++)
            {
                RecommendEqumentsModel *recommendEqumentsModel = self.HD_scrollViewDataArray[i];
                
                UIImageView *hdImgView = [[UIImageView alloc] init];
                
                NSLog(@"recommendEqumentsModel.reImgString %@",recommendEqumentsModel.reImgString);
                
                [hdImgView sd_setImageWithURL:[NSURL URLWithString:recommendEqumentsModel.reImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                
                [tempArray addObject:hdImgView];
            }
        }
            break;
        case 5:
        {
            for (int i=0; i<self.HD_scrollViewDataArray.count; i++)
            {
                RecommendEqumentsModel *recommendEqumentsModel = self.HD_scrollViewDataArray[i];
                
                UIImageView *hdImgView = [[UIImageView alloc] init];
                
                NSLog(@"recommendEqumentsModel.reImgString %@",recommendEqumentsModel.reImgString);
                
                [hdImgView sd_setImageWithURL:[NSURL URLWithString:recommendEqumentsModel.reImgString] placeholderImage:[UIImage imageNamed:DEFAULT_WEBPIC_PIC]];
                
                [tempArray addObject:hdImgView];
            }
        }
            break;
        case 6:
        {
            
        }
            break;
            
        default:
            break;
    }
    
    [self.HD_horiScrollView addItems:tempArray];
    
    
    self.HD_horiScrollView.miniAppearPxOfLastItem = 10;
    
    self.HD_horiScrollView.uniformItemSize = CGSizeMake(50, 50);
    
    [self.HD_horiScrollView setItemsMarginOnce];

}

@end
