//
//  MainGridTableViewCell.h
//  XLS_IAP
//
//  Created by 牛松松 on 16/4/13.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridDetailItemView : UIView

@property (nonatomic,strong) UIImageView *grid_ImageView;

@property (nonatomic,strong) UILabel *grid_nameLabel;

@end

@interface MainGridTableViewCell : UITableViewCell

@property (nonatomic,strong) GridDetailItemView *MG_firstItemView;

@property (nonatomic,strong) GridDetailItemView *MG_secondItemView;

@property (nonatomic,strong) GridDetailItemView *MG_thirdItemView;

@property (nonatomic,strong) UIView *firstLineView;

@property (nonatomic,strong) UIView *secondLineView;

@end
