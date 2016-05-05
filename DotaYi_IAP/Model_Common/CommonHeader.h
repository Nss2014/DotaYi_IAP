//
//  CommonHeader.h
//  
//
//  Created by yangyp on 15－7-28.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#ifdef __OBJC__
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//自定义的基类，可自定义导航条

#endif

#ifndef CommonHeader_h
#define CommonHeader_h
#import "Tools.h"
//userdefaults
#define DEFAULT [NSUserDefaults standardUserDefaults]
//app
#define APPDELEGATE (AppDelegate *)[[UIApplication sharedApplication]delegate]
#define RGB(A,B,C) [UIColor colorWithRed:A/255.0 green:B/255.0 blue:C/255.0 alpha:1.0] 


#pragma mark 设置


#define TABBAR_HEIGHT 49

/* -------------------花儿好看第三方平台Key--------------------*/

#define UMENG_APPKEY @"56f3935567e58e84a9001450"// 免费证书版本

#define kWeiJuJuMainURI @"http://www.weijuju.com"

#define kAPPMainURI @"http://app.mobile.weijuju.com/weshare/shareArticle"


#define kQQAppKey @"5JquYuRvBwDO2O5K"
#define kQQAppID @"1105107749"

#define kWechatAppID @"wxde4eaa8348dfa411"
#define kWechatAppSecret @"756ec80029625f24641e8bb0d9e4dacc"

#define kSinaAppKey @"3177785776"
#define kSinaAppSecret @"01c20069c06210bf3ce4eedc95d2d8a2"


#define CURRENT_VERSION  [HP_Application sharedApplication].currentVersion

#define IS_IPHONE4S (([[UIScreen mainScreen] bounds].size.height-480)?NO:YES)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)
#define IS_IPHONE6 (([[UIScreen mainScreen] bounds].size.height-667)?NO:YES)
#define IS_IPHONE6_PLUS (([[UIScreen mainScreen] bounds].size.height-736)?NO:YES)
#define IS_IPAD (([[UIScreen mainScreen] bounds].size.height-1024)?NO:YES)
#define IS_IOS6  ([[[UIDevice currentDevice] systemVersion] floatValue]<7)
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7)
#define IS_IOS8  ([[[UIDevice currentDevice] systemVersion] floatValue]>=8)
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height


//去除字符串两边的双引号
#define  TRemoveQuotation    stringByReplacingOccurrencesOfString:@"\"" withString:@""
//判断字符串是否为空
#define WStrIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length]<1 ? YES : NO )

// 生成GUID_ID（32位）
#define UUID_ID      [NSString stringWithFormat:@"%@",CFUUIDCreateString(NULL, CFUUIDCreate(NULL))]

//去除字符串两边的双引号
#define  TRemoveQuotation    stringByReplacingOccurrencesOfString:@"\"" withString:@""

//设备判断
#define __DEVICE_OS_VERSION_7_0 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
//判断是否 Retina屏、设备是否iphone 5
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//拍照宏
#define ACSHEET_CAMERA      0X128
#define ACSHEET_NOCAMERA    0X256
#define ACSHEET_SEX         0X512
#define ORIGINAL_MAX_WIDTH 640.0f


#define HTTPHEADER @""

//键盘高度
#define KEYBOARDHEIGHT 216

//导航高度
#define NAV_HEIGHT 64

//Tabbar高度
#define TABBAR_HEIGHT 49

//按钮边缘弧度
#define CORNERRADIUS_BUTTON 3.0

//列表View边缘弧度
#define ACCOUNT_CORNERRADIUS 5.0f

//普通列表Cell高度
#define ORIGINAL_TABLECELL_HEIGHT 55

//绘制1像素线的point  以6plus为准
#define PIXL1_AUTO_6PLUS ((1.0f / [UIScreen mainScreen].scale) / 2)

//自适应1像素的线
#define PIXL1_AUTO ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)

//登录页输入框距离左右屏幕值
#define INPUTVIEW_DISTANCE 40

//获取验证码倒计时
#define WAIT_NUMBER 60

//首页横向gridview数量
#define COUNTPERCELL 4

//黄金分割比例
#define GOLDENSEPARATE_SCALE 0.62

#pragma mark - 2.0 cell 高度
//cell heightForHeaderInSection
#define CELL_SECTIONHEADERHEIGHT 22.0f

//cell heightForRowAtIndexPath
#define CELL_INDEXTROWHEIGHT 54.5f

//间隔
#define PADDING_WIDTH 10


//捕获代码异常提交后台
#define HUR_CATCH_EXCEPTION [NSString stringWithFormat:@"%@/log/write",[HP_Application sharedApplication].hostIP]


//花儿好看官网
#define HUAER_OFFICIAL @"http://guanjia.weijuju.com/"

//生成随机浮点数
#define ARC4RANDOM_MAX      0x100000000

#define WIDTH_SCREEN        [UIScreen mainScreen].bounds.size.width
#define HEIGHT_SCREEN       [UIScreen mainScreen].bounds.size.height


//正文数组中所有正文的 proxy.weijuju.com 替换为 mmbiz.qpic.cn
#define WEIJUJU_PROXY_URL @"proxy.weijuju.com"

#define WEICHAT_EXCHANGE_URL @"mmbiz.qpic.cn"

//返回图标名

#define LEFTNAV_ICONNAME @"return_dafaut1_pressed@2x"

//默认热门列表封面图
#define DEFAULT_HOTLIST_PIC @"officialWebPic_default"

//默认banner加载图
#define DEFAULT_BANNER_PIC @"webPicture_default@2x"

//默认头像image
#define DEFAULT_HEAD_PLACEHOLDER @"header"

//默认公众号头像image
#define DEFAULT_OFFICIALHEAD_PLACEHOLDER @"official_header_icon"

//弹窗提示icon图标名
#define DEFAULT_ERRORMSG_ICON @"login_error_icon"


#define CELL_LINE_COLOR [UIColor colorWithRed:231/255.0 green:231/255.0 blue:231/255.0 alpha:1.0]

#define CELL_LINE_WIDTH 1.0

#define CELL_LINE_HEIGHT 0.5

//登录页button高度
#define sGapLength ((SCREEN_HEIGHT * 0.7 - SCREEN_WIDTH / 8)/10)

//登录页logo距离顶部长度
#define topGapLength (SCREEN_HEIGHT * 0.15 + SCREEN_WIDTH / 8)

//---------------------字体背景颜色-----------------------


//色值

//导航栏
#define NAVIGATION_COLOR [UIColor colorWithRed:0/255.0 green:0/255. blue:0/255. alpha:1.0]

//主体红
#define MAINRED_COLOR  [UIColor colorWithRed:233.0/255.0 green:30.0/255. blue:99.0/255. alpha:1.0]

//背景灰色
#define BACKGROUND_GRAYCOLOR  [UIColor colorWithRed:242/255.0 green:242/255. blue:242/255. alpha:0.9]
//分割线色
#define SEPRATELINE_GRAYCOLOR  [UIColor colorWithRed:219/255.0 green:219/255. blue:219/255. alpha:1.0]
//透明色
#define CLEAR_COLOR  [UIColor clearColor]
//白色
#define WHITE_COLOR  [UIColor whiteColor]
//黑色
#define BLACK_COLOR  [UIColor blackColor]
//红色
#define RED_COLOR  [UIColor redColor]
//蓝色
#define BLUE_COLOR  [UIColor blueColor]
//灰色
#define GRAY_COLOR  [UIColor grayColor]
//浅灰色
#define LIGHTGRAY_COLOR  [UIColor lightGrayColor]
//深灰色
#define DARKGRAY_COLOR [UIColor darkGrayColor]
//天蓝色
#define CYAN_COLOR  [UIColor cyanColor]
//棕色
#define BROWN_COLOR  [UIColor brownColor]
//橘色
#define ORANGE_COLOR  [UIColor orangeColor]
//黄色
#define YELLOW_COLOR  [UIColor yellowColor]
//绿色
#define GREEN_COLOR  [UIColor greenColor]
//紫色
#define PURPLE_COLOR  [UIColor purpleColor]

//groupTableViewBackgroundColor
#define GROUPTABLEVIEWBG_COLOR [UIColor groupTableViewBackgroundColor]
//viewFlipsideBackgroundColor
#define VIEWFLIPSBG_COLOR [UIColor viewFlipsideBackgroundColor]
//scrollViewTexturedBackgroundColor
#define SCROLLVIEWTEXTUREDBG_COLOR [UIColor scrollViewTexturedBackgroundColor]
//underPageBackgroundColor
#define UNDERPAGEBG_COLOR [UIColor underPageBackgroundColor]
#define HIGHLIGHTED_COLOR [UIColor colorWithRed:187/255.0 green:167/255.0 blue:150/255.0 alpha:1.0]



//文字深黑色
#define COLOR_TITLE_BLACK  [Tools colorFromHexCode:@"#1D1D1D"]
//文字浅灰色
#define COLOR_TITLE_LIGHTGRAY  [Tools colorFromHexCode:@"#6D6D72"]


//---------------------字体-----------------------
#pragma mark Font
//10号字体
#define TEXT10_FONT [UIFont fontWithName:@"Helvetica-light" size:10]
//11号字体
#define TEXT11_FONT [UIFont fontWithName:@"Helvetica-light" size:11]
//12号字体
#define TEXT12_FONT [UIFont fontWithName:@"Helvetica-light" size:12]
//13号字体
#define TEXT13_FONT [UIFont fontWithName:@"Helvetica-light" size:13]
//14号字体
#define TEXT14_FONT [UIFont fontWithName:@"Helvetica-light" size:14]
//15号字体
#define TEXT15_FONT [UIFont fontWithName:@"Helvetica-light" size:15]
//16号字体
#define TEXT16_FONT [UIFont fontWithName:@"Helvetica-light" size:16]
//17号字体
#define TEXT17_FONT [UIFont fontWithName:@"Helvetica-light" size:17]
//18号字体
#define TEXT18_FONT [UIFont fontWithName:@"Helvetica-light" size:18]
//20号字体
#define TEXT20_FONT [UIFont fontWithName:@"Helvetica-light" size:20]
//22号字体
#define TEXT22_FONT [UIFont fontWithName:@"Helvetica-light" size:22]
//24号字体
#define TEXT24_FONT [UIFont fontWithName:@"Helvetica-light" size:24]
//26号字体
#define TEXT26_FONT [UIFont fontWithName:@"Helvetica-light" size:26]
//28号字体
#define TEXT28_FONT [UIFont fontWithName:@"Helvetica-light" size:28]

#pragma mark - 花儿好看本地数据DEFAULT

//网络提示
#define NOINTERNET_CONNECT @"无网络连接"

//本地记录DeviceToken
#define LOCAL_DEVICETOKEN @"dvsToken"

//本地记录登录状态 0=未登陆 1=登陆
#define LOCAL_LOGINSTATUS @"loginStatus"


//DZN空列表默认提示
#define DZN_TITLE_EMPTYTABLE @"暂无数据"

//DZN空列表详细提示
#define DZN_DETAILTITLE_EMPTYTABLE @""

//DZN请求出错空列表
#define DZN_TITLE_REQUESTERROR @"请求出错"

//DZN请求出错空列表详细提示
#define DZN_DETAILTITLE_REQUESTERROR @"\n\n点击页面重新加载"

//DZN空列表字体大小
#define DZN_FONT_TITLE [UIFont fontWithName:@"Helvetica-light" size:22]

//DZN空列表详细字体大小
#define DZN_FONT_DETAIL_TITLE [UIFont fontWithName:@"Helvetica-light" size:14]

//快速的定义一个weakSelf
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;


//----------------------NJKFullScreen-------------------
#if __IPHONE_7_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >=  __IPHONE_7_0
#define NJK_IS_RUNNING_IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#else
#define NJK_IS_RUNNING_IOS7 NO
#endif

#if __IPHONE_8_0 && __IPHONE_OS_VERSION_MAX_ALLOWED >=  __IPHONE_8_0
#define NJK_IS_RUNNING_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#else
#define NJK_IS_RUNNING_IOS8 NO
#endif

#define kNearZero 0.000001f

//微信封面图宽高比例
#define WECHAT_COVERIMG_SCALE 306.f/524

//iPad微信封面图宽高比例
#define IPAD_WECHAT_COVERIMG_SCALE 186.f/524

#pragma mark - 秀丽媤色值--------------------------------------
//页面背景色
#define HRBACKVIEW_COLOR [Tools colorFromHexCode:@"#f2f2f2"]

//主题红
#define XLS_COLOR_MAIN_RED [UIColor colorWithRed:160.0/255 green:20.0/255  blue:65.0/255 alpha:1.0f]

//系统背景颜色
#define COLOR_VIEW_BG [Tools colorFromHexCode:@"#F5F5F5"]

#pragma mark - 花儿好看返回状态码---------------------------------
//正常
#define HK_STATUS_SUCCESS 0

//服务器异常
#define HK_STATUS_SERVEREXCEPTION 5000

//用户不存在
#define HK_STATUS_USERNOTEXIST 5001

//密码错误
#define HK_STATUS_WRONGPASSWORD 5002

//用户帐户被冻结
#define HK_STATUS_USERLOCKED 5003

//数据不存在
#define HK_STATUS_DATANOTEXIST 5004

//用户名已经存在
#define HK_STATUS_USERALREADYEXIST 5005

//用户名不合法
#define HK_STATUS_ILLEGALUSERNAME 5006

//验证码错误
#define HK_STATUS_WRONGVERIFYCODE 5007

//验证码发送过于频繁
#define HK_STATUS_RANDCODEBUSY 5008

//用户已经收藏过该文章
#define HK_STATUS_ARTICLEHASCOLLECTED 5009

//用户尚未收藏该文章
#define HK_STATUS_ARTICLEHASNOTCOLLECTE 5010

//非法参数
#define HK_STATUS_ILLEGALARGUMENT 4000

//上传失败
#define HK_STATUS_UPLOADFAIL 6001

//跳转花儿微管家下载地址
#define TURNTO_WGJ_APPSTORE_URL @"https://itunes.apple.com/cn/app/hua-er-wei-guan-jia/id1018732887?l=zh&ls=1&mt=8"

//花儿好看跳转Appstore接口
#define TURNTO_APPSTORE_URL @"https://itunes.apple.com/cn/app/hua-er-hao-kan/id1087677202?l=zh&ls=1&mt=8"

#pragma mark - 花儿好看后台接口-------------------------------------------

//版本号
#define APPLICATION_VERSIN @"1.0"

#define APP_HKBG_PLATFORM @"haokanbg"

#define APP_HKBG_DEV @"ios"


#pragma mark - 太平洋游戏网英雄&物品数据

/**
 *  英雄数据
 */
#define DT_HEROLISTDATA_URL @"http://fight.pcgames.com.cn/warcraft/dota/heros/"



//----------------------AES128加密--------------------
#pragma mark - AES128
#define AES_KEY @"5d41402abc4b2a76"


#pragma mark - Plist
#define PL_LQR_PLIST @"lqr_data_plist"

//----------------------数据库---------------------
#pragma mark - FMDB

//用户当前登录账号数据
#define DB_USERACCOUNTSDATA @"user_accounts_db"

//程序异常数据
#define DB_ERROREXCEPTION_DATA @"error_exception_db"

//本地频道数据
#define DB_CHANNELLIST_DATA @"channel_list_db"


#endif
