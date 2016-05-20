//
//  Tools.m
//  WonHotYY
//
//  Created by yangyp on 2015-07-28.
//  Copyright (c) 2015年 __MyCompanyName__. All rights reserved.
//

#import "Tools.h"
#import "CommonHeader.h"
#include <notify.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include "sys/stat.h"
#import "HP_Application.h"
#import "sys/utsname.h"

NSString *const NewFeatureVersionKey = @"NewFeatureVersionKey";

@implementation Tools

+ (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}


+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark //当前网络
//检测网络连接是否正常
+ (BOOL)checkNetWorkConnect {
//    return ([self IsEnable3G]||[self IsEnableWIFI]);
    
//    // 1.检测wifi状态
//    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
//    
//    // 2.检测手机是否能上网络(WIFI\3G\2.5G)
//    Reachability *conn = [Reachability reachabilityForInternetConnection];
//    
//    // 3.判断网络状态
//    if ([wifi currentReachabilityStatus] != NotReachable) { // 有wifi
//        
//        return YES;
//        
//    } else if ([conn currentReachabilityStatus] != NotReachable) { // 没有使用wifi, 使用手机自带网络进行上网
//        NSLog(@"使用手机自带网络进行上网");
//        
//        return YES;
//        
//    } else { // 没有网络
//        
//        NSLog(@"没有网络");
//        
//        return NO;
//    }
    
    return NO;
}

+(NSString *)md5:(NSString *)str{//MD5加密
    
    if (str == nil)
    {
        return nil;
    }
    const char *ptr = [str UTF8String];
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

//Version在plist文件中的key是“CFBundleShortVersionString”，和AppStore上的版本号保持一致，Build在plist中的key是“CFBundleVersion”，代表build的版本号，该值每次build之后都应该增加1

+(NSString *) getCurrentVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

//获得build号：
+(NSString *) getCurrentBuild
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}


#pragma mark -  boundingRectWithSize 代替 sizeWithFont  Label自适应高度
+(CGSize) getAdaptionSizeWithText:(NSString *)sendText andFont:(UIFont *)sendFont andLabelWidth:(CGFloat)sendWidth
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:sendFont, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize abelSize = [sendText boundingRectWithSize:CGSizeMake(sendWidth, 999) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return abelSize;
}

//Label自适应宽度
+(CGSize) getAdaptionSizeWithText:(NSString *)sendText AndFont:(UIFont *)sendFont andLabelHeight:(CGFloat)sendHeight
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:sendFont, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize abelSize = [sendText boundingRectWithSize:CGSizeMake(999, sendHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    return abelSize;
}

+ (UIColor *) colorFromHexCode:(NSString *)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


+ (NSString*)getRandomNumber:(int)from to:(int)to
{
    return [NSString stringWithFormat:@"%u",(from + (arc4random() % (to  - from + 1)))];
    
}

#pragma mark - 从URL加载图像  url转换图片
+ (UIImage *) imageFromURLString:(NSString *) urlstring
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]]];
}

+(CGSize) GetSizeWithString:(NSString *) textStr textWidth:(CGFloat) textWidth textFont :(UIFont *) textFont
{
    if(textStr && ![textStr isEqualToString:@""])
    {
        NSAttributedString *attributedText =[[NSAttributedString alloc] initWithString:textStr attributes:@
                                             {
                                             NSFontAttributeName: textFont
                                             }];
        CGRect rect = [attributedText boundingRectWithSize:(CGSize){textWidth, 10000}
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                   context:nil];
        CGSize size = rect.size;
        return size;
    }
    
    return CGSizeZero;
}

//tableview隐藏多余分割线
+(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString* outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                       
                                                                                       NULL, /* allocator */
                                                                                       
                                                                                       (__bridge CFStringRef)input,
                                                                                       
                                                                                       NULL, /* charactersToLeaveUnescaped */
                                                                                       
                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                       
                                                                                       kCFStringEncodingUTF8);
    
    
    return outputStr;
}

//遍历文件夹获得文件夹大小，返回多少M

+ (float ) folderSizeAtPath:(NSString*) folderPath
{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    
    return folderSize/(1024.0*1024.0);
    
}

//单个文件的大小

+ (long long) fileSizeAtPath:(NSString*) filePath
{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}


//（null） 转空字符串
+(NSString *) exchangeNullToEmptyString:(NSString *)sendString
{
    if (sendString == nil || [sendString isKindOfClass:[NSNull class]])
    {
        sendString = @"";
    }
    
    return sendString;
}

//字符串数组转换为字符串＋｜
+(NSString *) getExchangedStringWithArray:(NSMutableArray *)sendArr
{
    __block NSString *multiString = @"";
    
    [sendArr enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
        
        NSString *strObj = (NSString *)obj;
        
        NSString *tempMultiString = [strObj stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSString *imageMoreURLStr = [NSString stringWithFormat:@"|%@",tempMultiString];
        
        if (idx > 0)
        {
            multiString = [multiString stringByAppendingString:imageMoreURLStr];
        }
        else
        {
            multiString = tempMultiString;
        }
    }];
    
    return multiString;
}

//判断链接是否以http://  或者以https://
+(BOOL) isJudgeHttpLinkOrNotWithLink:(NSString *)aLink
{
    if([aLink rangeOfString:@"http://"].location != NSNotFound)
    {
        return YES;
    }
    else if ([aLink rangeOfString:@"https://"].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

// 保存普通对象
+ (void)setStr:(NSString *)str key:(NSString *)key{
    
    // 获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 保存
    [defaults setObject:str forKey:key];
    
    // 立即同步
    [defaults synchronize];
    
}

//保存bool对象
+ (void)setBool:(BOOL) aBool key:(NSString *)key
{
    // 获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 保存
    [defaults setBool:aBool forKey:key];
    
    // 立即同步
    [defaults synchronize];
}

// 读取
+ (NSString *)strForKey:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSString *str=(NSString *)[defaults objectForKey:key];
    
    return str;
    
}

+ (BOOL) boolForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL getbool = [defaults boolForKey:key];
    
    return getbool;
}

// 是否应该显示版本新特性页面
+ (BOOL)canShowNewFeature
{
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow = [[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    //读取本地版本号
    NSString *versionLocal = [self strForKey:NewFeatureVersionKey];
    
    if(versionLocal!=nil && [versionValueStringForSystemNow isEqualToString:versionLocal]){//说明有本地版本记录，且和当前系统版本一致
        
        return NO;
        
    }else{ // 无本地版本记录或本地版本记录与当前系统版本不一致
        
        //保存
        [self setStr:versionValueStringForSystemNow key:NewFeatureVersionKey];
        
        return YES;
    }
}

//获取一个六位随机数
+(NSString *) getRandomSixthString
{
    NSString *randomSixthStr = [self getRandomNumber:100000 to:1000000];
    
    return randomSixthStr;
}

//获取当前时间戳
+(long long) getCurrentTimeStamp
{
    //时间戳 毫秒
    long long timeInterval = [[NSDate date] timeIntervalSince1970] *1000;
    
    return timeInterval;
}

//根据主xpath（TFHpple ＊）获取字符串数据
+(NSString *) getHtmlValueWithXPathParser:(id)xpathParser XPathQuery:(NSString *)xPathQuery DetailXPathQuery:(NSString *)detailXPathQuery  DetailKey:(NSString *) detailKey
{
    NSString *getValueString = @"";
    
    if (xPathQuery)
    {
        NSArray *firstElementsArr = [xpathParser searchWithXPathQuery:xPathQuery];
        
        for (TFHppleElement *firstElement in firstElementsArr)
        {
            //如果有第二层则取出 若没有直接取第一层的数据
            if (detailXPathQuery)
            {
                NSArray *IMGElementsArr = [firstElement searchWithXPathQuery:detailXPathQuery];
                
                for (TFHppleElement *tempAElement in IMGElementsArr)
                {
                    //如果传入key值则取key对应的值  若没有则取text值
                    if (detailKey)
                    {
                        NSString *valueStr = [tempAElement objectForKey:detailKey];
                        
                        getValueString = valueStr;

                    }
                    else
                    {
                        getValueString = tempAElement.text;
                    }
                }

            }
            else
            {
                if (detailKey)
                {
                    NSString *valueStr = [firstElement objectForKey:detailKey];
                    
                    getValueString = valueStr;

                }
                else
                {
                    getValueString = firstElement.text;
                }
            }
            
        }
    }
    
    return getValueString;
}

//根据次级xpath（TFHppleElement ＊）获取字符串数据
+(NSMutableArray *) getHtmlValueArrayWithXPathParser:(id)xpathParser XPathQuery:(NSString *)xPathQuery DetailXPathQuery:(NSString *)detailXPathQuery  DetailKey:(NSString *) detailKey
{
    NSMutableArray *getValueArray = [NSMutableArray array];
    
    if (xPathQuery)
    {
        NSArray *firstElementsArr = [xpathParser searchWithXPathQuery:xPathQuery];
        
        for (TFHppleElement *firstElement in firstElementsArr)
        {
            //如果有第二层则取出 若没有直接取第一层的数据
            if (detailXPathQuery)
            {
                NSArray *IMGElementsArr = [firstElement searchWithXPathQuery:detailXPathQuery];
                
                for (TFHppleElement *tempAElement in IMGElementsArr)
                {
                    //如果传入key值则取key对应的值  若没有则取text值
                    if (detailKey)
                    {
                        NSString *valueStr = [tempAElement objectForKey:detailKey];
                        
                        if (valueStr)
                        {
                            [getValueArray addObject:valueStr];
                        }
                        
                    }
                    else
                    {
                        [getValueArray addObject:tempAElement.content];
                    }
                }
                
            }
            else
            {
                if (detailKey)
                {
                    NSString *valueStr = [firstElement objectForKey:detailKey];
                    
                    [getValueArray addObject:valueStr];
                    
                }
                else
                {
                    [getValueArray addObject:firstElement.content];

                }
            }
            
        }
    }
    
    return getValueArray;
}

//11平台Post
+(void) platform11PostRequest:(NSString *) theLoginURL ParamsBody:(NSString *) theBody target:(id)target action:(SEL)action
{
    NSMutableURLRequest * backRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:theLoginURL]];
    
    [backRequest setTimeoutInterval:5.f];
    
    //将字符串转换成二进制数据
    NSData * postData = [theBody dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置http请求模式
    [backRequest setHTTPMethod:@"POST"];
    //设置POST正文的内容
    [backRequest setHTTPBody:postData];
    
    NSLog(@"LOGIN_COOKIE %@",[self strForKey:LOGIN_COOKIE]);
    
    [backRequest setValue:[self strForKey:LOGIN_COOKIE] forHTTPHeaderField:@"Cookie"];
    
    [NSURLConnection sendAsynchronousRequest:backRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"resultresultresult%@", result);
        
        if (result && ![result isEqualToString:@""])
        {
            APJSONParser *jsonParser = [[APJSONParser alloc] init];
            
            NSDictionary *responseDic = [jsonParser jsonStringToDictionary:result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([target respondsToSelector:action])
                {
                    [target performSelector:action withObject:responseDic afterDelay:0.0];
                }
                
            });
        }
        else
        {
            NSDictionary *responseDic = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([target respondsToSelector:action])
                {
                    [target performSelector:action withObject:responseDic afterDelay:0.0];
                }
                
            });
        }
        
    }];
}

//11平台登录Post  登录第一步
+(void) platform11LoginRequest:(NSString *) theLoginURL ParamsBody:(NSString *) theBody target:(id)target action:(SEL)action
{
    NSMutableURLRequest * backRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:theLoginURL]];
    
    [backRequest setTimeoutInterval:5.f];
    
    //将字符串转换成二进制数据
    NSData * postData = [theBody dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置http请求模式
    [backRequest setHTTPMethod:@"POST"];
    //设置POST正文的内容
    [backRequest setHTTPBody:postData];
    
    [backRequest setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    [backRequest setValue:@"Mozilla/5.0 (iPhone; CPU iPhone OS 8_0 like Mac OS X) AppleWebKit/600.1.3 (KHTML, like Gecko) Version/8.0 Mobile/12A4345d Safari/600.1.4" forHTTPHeaderField:@"User-Agent"];
    
    [backRequest setValue:@"register.5211game.com" forHTTPHeaderField:@"Host"];
    
    [backRequest setValue:@"http://register.5211game.com/11/login?returnurl=" forHTTPHeaderField:@"Referer"];
    
    [NSURLConnection sendAsynchronousRequest:backRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"resultresultresult%@", result);
        
        if (result && ![result isEqualToString:@""])
        {
            APJSONParser *jsonParser = [[APJSONParser alloc] init];
            
            NSDictionary *responseDic = [jsonParser jsonStringToDictionary:result];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([target respondsToSelector:action])
                {
                    [target performSelector:action withObject:responseDic afterDelay:0.0];
                }
                
            });
        }
        else
        {
            NSDictionary *responseDic = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([target respondsToSelector:action])
                {
                    [target performSelector:action withObject:responseDic afterDelay:0.0];
                }
                
            });
        }
        
    }];
}

//11登录请求  从第二个接口开始使用NSURLConnection请求
+(NSURLConnection *) addURLConnectionPostRequestWithURLString:(NSString *)urlString BodyData:(NSData *)bodyData AndDelegate:(id)delegate
{
    NSString *INFO_URL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:INFO_URL]];
    
    [request setTimeoutInterval:5.0f];
    
    //设置http请求模式
    [request setHTTPMethod:@"POST"];
    //将字符串转换成二进制数据
    //设置POST正文的内容
    
    if (bodyData)
    {
        [request setHTTPBody:bodyData];
    }
    
    //发送请求
    return [NSURLConnection connectionWithRequest:request delegate:delegate];
}


@end
