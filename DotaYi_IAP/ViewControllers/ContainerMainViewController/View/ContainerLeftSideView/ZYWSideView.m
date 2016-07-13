//
//  ZYWSideView.m
//  ZYWQQ
//
//  Created by Devil on 16/2/23.
//  Copyright © 2016年 Devil. All rights reserved.
//

#import "ZYWSideView.h"
#import "ZYWSideTableView.h"


@interface ZYWSideView()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,weak)UIView *blackView;

@property(nonatomic,strong)UIImageView *headImage;
@property(nonatomic,copy)NSString *name;
@end



@implementation ZYWSideView

-(NSString *)name{
    if (_name==nil) {
        _name=@"跳转1";
    }
    
    return _name;
}

-(UIImageView *)headImage{
    if (_headImage==nil) {
        _headImage=[[UIImageView alloc]init];
    }
    return _headImage;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        //    按钮的frame
        CGFloat bX=30;
        CGFloat bY=100;
        CGFloat bW=270;
        CGFloat bH=60;
        //    在背景图上添加按钮
        UIButton *headBtn=[[UIButton alloc]initWithFrame:CGRectMake(bX,bY,bW,bH)];
        
        
        //    头像的frame
        CGFloat iX=0;
        CGFloat iY=0;
        CGFloat iW=headBtn.bounds.size.height;
        CGFloat iH=headBtn.bounds.size.height;
        //    在按钮上添加头像
        
        
        
        
        UIImageView *headImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"123"]];
      
        headImage.frame=CGRectMake(iX,iY,iW,iH);
        headImage.layer.cornerRadius =headBtn.bounds.size.height * 0.5;
        headImage.layer.masksToBounds = YES;
        
        
        
        
        //    名称的frame
        CGFloat lX=iW+10;
        CGFloat lY=iY;
        CGFloat lW=iW;
        CGFloat lH=iW*0.5;
        //    在按钮上显示名称
        UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(lX,lY,lW,lH)];
        headLabel.text=@"Devil";
        
        //     二维码的frame
        CGFloat qW=headBtn.bounds.size.height;
        CGFloat qH=headBtn.bounds.size.height;
        CGFloat qX=headBtn.bounds.size.width-qW;
        CGFloat qY=0;
        UIButton *qrCode=[[UIButton alloc]initWithFrame:CGRectMake(qX,qY,qW,qH)];
        [qrCode setImage:[UIImage imageNamed:@"sidebar_ QRcode_normal"] forState:UIControlStateNormal];
        
        //        创建透明view上的tableview
        ZYWSideTableView *sbv=[[ZYWSideTableView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height*0.4,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height*0.6-48)];
//
        sbv.backgroundColor=[UIColor clearColor];
        
        sbv.dataSource = self;
        
        sbv.delegate = self;
        
        //  =======================
        //       创建底部view的按钮
        UIButton *setBtn=[[UIButton alloc]initWithFrame:CGRectMake(0,0,48*2,48)];
        [setBtn setTitle:@"设置" forState:UIControlStateNormal];
        [setBtn setImage:[UIImage imageNamed:@"sidebar_setting"] forState:UIControlStateNormal];
        
//        [setBtn addTarget:self action:@selector(didSetBtn) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *dayBtn=[[UIButton alloc]initWithFrame:CGRectMake(48*2,0,48*2,48)];
        [dayBtn setTitle:@"夜间" forState:UIControlStateNormal];
        [dayBtn setImage:[UIImage imageNamed:@"sidebar_nightmode_on"] forState:UIControlStateNormal];
        
        //        创建透明view上的底部view
        UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-48,[UIScreen mainScreen].bounds.size.width, 48)];
        footView.backgroundColor=[UIColor clearColor];
        
        [footView addSubview:setBtn];
        [footView addSubview:dayBtn];
        // =====================================
        
        [headBtn addSubview:qrCode];
        [headBtn addSubview:headLabel];
        [headBtn addSubview:headImage];
        
        //  =========================
        //    为按钮添加单击事件（更换头像）
        [headBtn addTarget:self action:@selector(changeHeaderImage) forControlEvents:UIControlEventTouchUpInside];
        
        // ===========================
        [self addSubview:headBtn];
        
        [self addSubview:sbv];
        [self addSubview:footView];
        
    }
    return  self ;
    
}
-(void)dealloc
{
    
    NSLog(@"移除主传左通知对象");
}

//点击了头像按钮（更换头像）
-(void)changeHeaderImage{
    
}

//实现数据源方法
-(NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (indexPath.row==0) {
        cell.imageView.image=[UIImage imageNamed:@"sidebar_business"];
        cell.textLabel.text=@"我的商城";
    }else if (indexPath.row==1){
        cell.imageView.image=[UIImage imageNamed:@"sidebar_purse"];
        cell.textLabel.text=@"QQ钱包";
    }else if (indexPath.row==2){
        cell.imageView.image=[UIImage imageNamed:@"sidebar_decoration"];
        cell.textLabel.text=@"个性装扮";
    }else if (indexPath.row==3){
        cell.imageView.image=[UIImage imageNamed:@"sidebar_favorit"];
        cell.textLabel.text=@"我的收藏";
    }else if (indexPath.row==4){
        cell.imageView.image=[UIImage imageNamed:@"sidebar_album"];
        cell.textLabel.text=@"我的相册";
    }else{
        cell.imageView.image=[UIImage imageNamed:@"sidebar_file"];
        cell.textLabel.text=@"我的文件";
    }
    
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.textColor=[UIColor whiteColor];
    //    点击cell时没有点击效果
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRowAtIndex:)])
    {
        [self.delegate didSelectRowAtIndex:indexPath.row];
    }
}


@end
