//
//  SGGridMenu.h
//  SGActionView
//
//  Created by Sagi on 13-9-6.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGBaseMenu.h"

@interface SGGridMenu : SGBaseMenu

@property (nonatomic,assign) BOOL isChangeLabelColor;

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images;

- (void)triggerSelectedAction:(void(^)(NSInteger))actionHandle;

@end
