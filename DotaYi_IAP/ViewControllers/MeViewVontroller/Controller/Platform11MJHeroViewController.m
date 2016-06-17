//
//  Platform11MJHeroViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/6/2.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "Platform11MJHeroViewController.h"
#import "CustomGridPointView.h"

@interface Platform11MJHeroViewController ()

@property (nonatomic,strong) ThreeGridView *threeGridView1;

@property (nonatomic,strong) ThreeGridView *threeGridView2;

@property (nonatomic,strong) ThreeGridView *threeGridView3;

@property (nonatomic,strong) ThreeGridView *threeGridView4;

@end

@implementation Platform11MJHeroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

-(void) initData
{
    
}

-(void) initUI
{
    self.view.backgroundColor = WHITE_COLOR;
    
    self.navigationItem.title = self.sendHeroModel.heroname;
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.viwTable.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAV_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    [self addTableViewHeader];
}

-(void) addTableViewHeader
{
    //竞技场积分和走势图
    UIView *headerBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60 + HERODETAIL_IMGHEIGHT + 200)];
    
    //头像
    UIImageView *heroHeaderImgView = [[UIImageView alloc] init];
    
    heroHeaderImgView.layer.cornerRadius = HERODETAIL_IMGHEIGHT/2;
    
    heroHeaderImgView.clipsToBounds = YES;
    
    [heroHeaderImgView sd_setImageWithURL:[NSURL URLWithString:[Tools getPlatForm11HeroHeadImgWithHeroId:self.sendHeroModel.heroId]] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
    
    [headerBgView addSubview:heroHeaderImgView];
    
    self.threeGridView1 = [[ThreeGridView alloc] init];
    
    self.threeGridView1.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.cscore];
    
    self.threeGridView1.customGridView1.gridBottomNameLabel.text = @"名将积分";
    
    self.threeGridView1.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.total];
    
    self.threeGridView1.customGridView2.gridBottomNameLabel.text = @"对战局数";
    
    self.threeGridView1.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.win];
    
    self.threeGridView1.customGridView3.gridBottomNameLabel.text = @"胜利局数";
    
    [headerBgView addSubview:self.threeGridView1];
    
    self.threeGridView2 = [[ThreeGridView alloc] init];
    
    self.threeGridView2.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.lost];
    
    self.threeGridView2.customGridView1.gridBottomNameLabel.text = @"失败局数";
    
    self.threeGridView2.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.p_win];
    
    self.threeGridView2.customGridView2.gridBottomNameLabel.text = @"胜率";
    
    self.threeGridView2.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.mvp];
    
    self.threeGridView2.customGridView3.gridBottomNameLabel.text = @"MVP";
    
    [headerBgView addSubview:self.threeGridView2];
    
    
    self.threeGridView3 = [[ThreeGridView alloc] init];
    
    self.threeGridView3.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.resv6];
    
    self.threeGridView3.customGridView1.gridBottomNameLabel.text = @"破敌";
    
    self.threeGridView3.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.resv5];
    
    self.threeGridView3.customGridView2.gridBottomNameLabel.text = @"富豪";
    
    self.threeGridView3.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.resv7];
    
    self.threeGridView3.customGridView3.gridBottomNameLabel.text = @"破军";
    
    [headerBgView addSubview:self.threeGridView3];
    
    self.threeGridView4 = [[ThreeGridView alloc] init];
    
    self.threeGridView4.customGridView1.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.resv10];
    
    self.threeGridView4.customGridView1.gridBottomNameLabel.text = @"英魂";
    
    self.threeGridView4.customGridView2.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.herokill];
    
    self.threeGridView4.customGridView2.gridBottomNameLabel.text = @"击杀英雄";
    
    self.threeGridView4.customGridView3.gridTopValueLabel.text = [NSString stringWithFormat:@"%@",self.sendHeroModel.roshan];
    
    self.threeGridView4.customGridView3.gridBottomNameLabel.text = @"夺肉山盾";
    
    [headerBgView addSubview:self.threeGridView4];
    
    WS(ws);
    
    [heroHeaderImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerBgView.mas_centerX);
        make.top.equalTo(headerBgView.mas_top).offset(PADDING_WIDTH);
        make.height.mas_equalTo(HERODETAIL_IMGHEIGHT);
        make.width.equalTo(heroHeaderImgView.mas_height);
    }];
    
    [self.threeGridView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_left);
        make.right.equalTo(headerBgView.mas_right);
        make.top.equalTo(heroHeaderImgView.mas_bottom).offset(PADDING_WIDTH);
        make.height.mas_equalTo(50);
    }];
    
    [self.threeGridView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.threeGridView1.mas_left);
        make.right.equalTo(ws.threeGridView1.mas_right);
        make.top.equalTo(ws.threeGridView1.mas_bottom).offset(PADDING_WIDTH);
        make.height.equalTo(ws.threeGridView1.mas_height);
    }];
    
    [self.threeGridView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.threeGridView2.mas_left);
        make.right.equalTo(ws.threeGridView2.mas_right);
        make.top.equalTo(ws.threeGridView2.mas_bottom).offset(PADDING_WIDTH);
        make.height.equalTo(ws.threeGridView2.mas_height);
    }];
    
    [self.threeGridView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.threeGridView3.mas_left);
        make.right.equalTo(ws.threeGridView3.mas_right);
        make.top.equalTo(ws.threeGridView3.mas_bottom).offset(PADDING_WIDTH);
        make.height.equalTo(ws.threeGridView3.mas_height);
    }];
    
    self.viwTable.tableHeaderView = headerBgView;
}

@end
