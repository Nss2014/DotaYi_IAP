//
//  Tools.h
//  WonHotYY
//
//  Created by yangyp on 2015-07-28.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <CommonCrypto/CommonDigest.h>
#import "TFHpple.h"

@interface Tools : NSObject

+ (NSString*)deviceString;

+(CGSize) getAdaptionSizeWithText:(NSString *)sendText andFont:(UIFont *)sendFont andLabelWidth:(CGFloat)sendWidth;
//Label自适应宽度
+(CGSize) getAdaptionSizeWithText:(NSString *)sendText AndFont:(UIFont *)sendFont andLabelHeight:(CGFloat)sendHeight;

#pragma mark 加载十六进制颜色
+ (UIColor *) colorFromHexCode:(NSString *)hexString;

+(NSString *)md5:(NSString *)str;


//获取随机数
+ (NSString*)getRandomNumber:(int)from to:(int)to;

+ (UIImage *) imageFromURLString:(NSString *) urlstring;

+(void)setExtraCellLineHidden: (UITableView *)tableView;

+ (NSString *)encodeToPercentEscapeString: (NSString *) input;

//遍历文件夹获得文件夹大小，返回多少M
+ (float ) folderSizeAtPath:(NSString*) folderPath;
//单个文件的大小
+ (long long) fileSizeAtPath:(NSString*) filePath;

+(BOOL) isJudgeHttpLinkOrNotWithLink:(NSString *)aLink;

// 保存普通对象
+ (void)setStr:(NSString *)str key:(NSString *)key;

+ (void)setBool:(BOOL) aBool key:(NSString *)key;

+ (NSString *)strForKey:(NSString *)key;

+ (BOOL) boolForKey:(NSString *)key;

+ (BOOL)canShowNewFeature;

+(NSString *) getRandomSixthString;

+(long long) getCurrentTimeStamp;

+(NSString *) exchangeNullToEmptyString:(NSString *)sendString;

+(NSString *) getHtmlValueWithXPathParser:(id)xpathParser XPathQuery:(NSString *)xPathQuery DetailXPathQuery:(NSString *)detailXPathQuery  DetailKey:(NSString *) detailKey;

+(NSMutableArray *) getHtmlValueArrayWithXPathParser:(id)xpathParser XPathQuery:(NSString *)xPathQuery DetailXPathQuery:(NSString *)detailXPathQuery  DetailKey:(NSString *) detailKey;

+(void) platform11PostRequest:(NSString *) theLoginURL ParamsBody:(NSString *) theBody target:(id)target action:(SEL)action;

+(void) platform11LoginRequest:(NSString *) theLoginURL ParamsBody:(NSString *) theBody target:(id)target action:(SEL)action;

+(NSURLConnection *) addURLConnectionPostRequestWithURLString:(NSString *)urlString BodyData:(NSData *)bodyData AndDelegate:(id)delegate;

+(NSString *) getHeroIdFromLink:(NSString *) theLink;

+ (NSString *) getOddIdFromLink:(NSString *) theLink;


@end

