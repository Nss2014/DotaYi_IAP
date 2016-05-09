//
// BaseViewController.h
//
//
//  Created by yangyp on 15－7-28.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

/*
 //获取异常代码 log  NSException  捕捉异常
 @try{
 
 //填写异常代码
 
 }
 @catch(NSException *exception) {
 NSLog(@"exception:%@", exception);
 }
 @finally {
 
 }
 */

#import <UIKit/UIKit.h>
#import "Tools.h"
#import "CommonHeader.h"
#import "HP_Application.h"
#import "AppDelegate.h"
#import "UIDevice-Hardware.h"

#import "NSString+SBJSON.h"

#import <AVFoundation/AVFoundation.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "CoreTFManagerVC.h"
#import "UIColor+Hexadecimal.h"
#import "UIScrollView+EmptyDataSet.h"
#import "UIScrollView+KS.h"
#import "ARSegmentView.h"
#import "ARSegmentControllerDelegate.h"
#import "ARSegmentPageControllerHeaderProtocol.h"
#import "ARSegmentControllerDelegate.h"

@interface BaseViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIWebViewDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
        //是否正在加载数据
    BOOL isloading;
        //数据显示列表
    UITableView *viwTable;
        //栏目title长度
    float segWidth;

    float height;
    UIScrollView *viwScrollView;
    UIButton     *titltBtn;
    
    NSMutableArray *items_;
    NSIndexPath *menuIndexPath;
    
}

@property (nonatomic, strong) UIButton     *titleBtn;
@property (nonatomic, strong) UIScrollView *viwScrollView;
@property (nonatomic, strong) UITableView  *viwTable;

@property(strong,nonatomic) UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger currentMainPage;

@property (nonatomic,assign) BOOL isFooterRefresh;

    //添加UITableView
-(void)addTableView:(UITableViewStyle)style separatorStyle:(UITableViewCellSeparatorStyle)sepStyle;

-(void) addScrollView;

-(void) addCollectionView;

//添加Tap手势
-(void) addTapGestureRecognizer;
-(void) viewTapedDismissKeyboard:(UITapGestureRecognizer *)sender;

//*******************************************
//根据字符串返回高度
- (CGFloat) heightForString:(NSString *)value fontSize:(CGFloat)fontSize andWidth:(NSInteger)width
;
//根据字符串返回宽度
- (CGFloat)lengthForString:(NSString *)value fontSize:(CGFloat)fontSize andHeight:(NSInteger)navHeight;
- (AppDelegate *)appDelegate;

//左侧按钮点击事件
- (void) setLeftSystemButton:(NSString *) leftTitle;
- (void) setLeftOnlyTextItem:(NSString *) leftTitle;
- (void)leftNavBtnCallBack;
-(void) leftNavTitleCallBack;

//设置导航右侧按钮
-(void) setRightNavigationTextBtn:(NSString *)titleName;
-(void) setWechatRightMoreBarButton;
-(void) rightNavBtnCallBack;
-(void) RightNavigationBtnPressed;
-(void) setRightNavBarButton:(NSString *) rightItemStr;
-(void) setLeftNavBarImageButton:(NSString *) leftImageName;
-(void) setRightNavBarImageButton:(NSString *) rightImageName;

-(void) turnToLoginVCWithLeftNavButton;

//add网页进度条
-(void) addNJKWebViewProgress:(UIWebView *) sendWebView;

-(void) addNJKScrollFullScreen:(UIWebView *)sendWebView;

-(void) addNJKToolBar;

-(void) setDZNEmptyDataWithTableView:(UITableView *)sendTableView  andEmptyTitle:(NSString *) aTitle titleColor:(UIColor *) aTitleColor titleFont:(UIFont *) aTitleFont andEmptyDetailTitle:(NSString *) aDetailTitle detailTitleColor:(UIColor *) aDetailTitleColor detailTitleFont:(UIFont *) aDetailTitleFont;

-(void) addEmptyTipsViewWithTitle:(NSString *)aTitle IsShowButton:(BOOL) showBtn ButtonTitle:(NSString *)theBtnTitle;

-(void) showEmptyTipView;

-(void) hideEmptyTipView;

//分割线左对齐
-(void) setTableViewLeftAlignment:(UITableViewCell *)sendTableViewCell;

-(void) addKSHeaderAndFooterRefresh;

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
