//
//  SettingsViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/4/15.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"
#import "UMSocial.h"
#import "UMFeedbackViewController.h"
#import "SGActionView.h"
#import "QQGroupChatViewController.h"

static NSString *shareAppString = @"妖刀｜最全面的11平台dota1数据统计";

static NSString *shareAppTitleString = @"妖刀｜最全面的11平台dota1数据统计";

@interface SettingsViewController ()<LEActionSheetDelegate>

@property (nonatomic,strong) NSArray *sectionTwoTitlesArray;

@property (nonatomic,strong) NSMutableArray *listImagesNameArray;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
}

-(void) initData
{
    self.sectionTwoTitlesArray = [NSArray arrayWithObjects:@"清除缓存",@"加入QQ交流群",@"建议与反馈",@"App Store评分", nil];
    
    self.listImagesNameArray = [NSMutableArray array];
    
    for (int i=0; i<self.sectionTwoTitlesArray.count; i++)
    {
        [self.listImagesNameArray addObject:[NSString stringWithFormat:@"settings_left_icon%d.png",i+1]];
    }
}

-(void) initUI
{
    self.navigationItem.title = @"设置";
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.viwTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT - TABBAR_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    self.viwTable.sectionFooterHeight = 1.0;
}

#pragma mark 列表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return self.sectionTwoTitlesArray.count;
    }
    else if (section == 2)
    {
        return 1;
    }
    
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 140;
    }
    else if (indexPath.section == 1)
    {
        return ORIGINAL_TABLECELL_HEIGHT;
    }
    else if (indexPath.section == 2)
    {
        return ORIGINAL_TABLECELL_HEIGHT;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *identifier0 = @"cell0";
        
        SettingSection1Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier0];
        
        if (!cell)
        {
            cell = [[SettingSection1Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.SS_userImageView sd_setImageWithURL:[NSURL URLWithString:@"http://static.7fgame.com/11General/UserIcon/0.jpg"] placeholderImage:[UIImage imageNamed:DEFAULT_USERHEADER_PIC]];
        
        cell.SS_userNameLabel.text = [Tools strForKey:LOGIN_RESPONSE_USERNAME];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *identifier1 = @"cell1";
        
        SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        
        if (!cell)
        {
            cell = [[SettingsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.ST_iconImageView.image = [UIImage imageNamed:self.listImagesNameArray[indexPath.row]];
        
        cell.ST_nameLabel.text = self.sectionTwoTitlesArray[indexPath.row];
        
//        cell.ST_indicatorImageView.image = [UIImage imageNamed:@"arrow_point_icon"];
        
        if (indexPath.row == 0)
        {
            cell.ST_clearCacheLabel.hidden = NO;
            
            cell.ST_clearCacheLabel.text = [NSString stringWithFormat:@"%.1fM",[self obtainForfilePath]];
        }
        else
        {
            cell.ST_clearCacheLabel.hidden = YES;
        }
        
        return cell;
    }
    else if (indexPath.section == 2)
    {
        static NSString *identifier1 = @"cell2";
        
        SettingSection2Cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        
        if (!cell)
        {
            cell = [[SettingSection2Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.S2_logoutButton addTarget:self action:@selector(logoutBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

#pragma mark -  点击行响应
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
//            //登录&退出登录
//            BOOL isLogin = [Tools boolForKey:LOCAL_LOGINSTATUS];
//            
//            if (isLogin)
//            {
//                LEActionSheet *actionSheet = [[LEActionSheet alloc] initWithTitle:@"确定要退出登录吗？"
//                                                                         delegate:self
//                                                                cancelButtonTitle:@"取消"
//                                                           destructiveButtonTitle:@"退出登录"
//                                                                otherButtonTitles:nil];
//                actionSheet.tag = 1010;
//                
//                [actionSheet showInView:self.view.window];
//            }
//            else
//            {
//                
//            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            //清理缓存
            
            UIAlertView *clearCaheAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除本地缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            clearCaheAlert.tag = 2999;
            
            [clearCaheAlert show];
        }
        else if (indexPath.row == 1)
        {
            //加入QQ交流群
            QQGroupChatViewController *qqgroupVC = [[QQGroupChatViewController alloc] init];
            
            [self setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:qqgroupVC animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //推荐给好友  第一版未完成
//            [self introduceToFriend];
            
            
            //建议与反馈
            UMFeedbackViewController *umVC = [[UMFeedbackViewController alloc] init];
            
            [self setHidesBottomBarWhenPushed:YES];
            
            [self.navigationController pushViewController:umVC animated:YES];
        }
        else if (indexPath.row == 3)
        {
            //评分
            NSString *str = TURNTO_APPSTORE_LINK;
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

        }
        else if (indexPath.row == 4)
        {
            
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    
    backView.backgroundColor = CLEAR_COLOR;
    
    return backView;
}

//设置sectionHeader高度  对于第一个和第二个section之间的距离设置则不能使用heightForFooterInSection这个方法。需要使用myTableView.sectionFooterHeight = 1.0。 这个距离的计算是header的高度加上footer的高度。
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

//分割线左对齐
-(void)viewDidLayoutSubviews {
    if ([self.viwTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.viwTable setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.viwTable respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.viwTable setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark -  缓存计算 清理缓存
// 获取缓存大小
- (CGFloat)obtainForfilePath
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    return [self folderSizeAtpath:cachePath];
}

// 遍历文件夹返回文件大小（M）
- (float)folderSizeAtpath:(NSString *)folderPath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath])
    {
        return 0;
    }
    
    NSEnumerator * childfilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString * fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childfilesEnumerator nextObject]) != nil)
    {
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtpath:fileAbsolutePath];
    }
    
    return folderSize / (1024.0 * 1024.0);
}

// 计算返回单个文件大小
- (long long)fileSizeAtpath:(NSString *)filepath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filepath])
    {
        return [[manager attributesOfItemAtPath:filepath error:nil] fileSize];
    }
    
    return 0;
}


// 清理缓存
- (void)cleanrFilecache
{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSArray * files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    for (NSString * path  in files)
    {
        NSError * error = nil;
        
        NSString * absolutepath = [cachePath stringByAppendingPathComponent:path];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:absolutepath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:absolutepath error:&error];
        }
    }
    
    [self performSelectorOnMainThread:@selector(cleanrCacheSuccess) withObject:nil waitUntilDone:YES];
}


// 清除成功
- (void)cleanrCacheSuccess
{
    // 刷新缓存显示
    NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:1];
    
    [self.viwTable reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - clearCach end

-(void) logoutBtnPressed
{
    //退出登录
    UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    logoutAlert.tag = 1999;
    
    [logoutAlert show];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1999)
    {
        if (buttonIndex == 0)
        {
            //取消
        }
        else if (buttonIndex == 1)
        {
            //退出登录
            [Tools setBool:NO key:LOCAL_LOGINSTATUS];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AppDelegate *appDe = APPDELEGATE;
                
                [appDe enterLoginVC];
                
            });
        }
    }
    else if (alertView.tag == 2999)
    {
        if (buttonIndex == 0)
        {
            //取消
        }
        else if (buttonIndex == 1)
        {
            
            //清理缓存
            [self cleanrFilecache];
        }
    }
}

#pragma mark - LEActionSheetDelegate

-(void)actionSheet:(LEActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1010)
    {
        if (buttonIndex == 0)
        {
            //退出登录
            [Tools setBool:NO key:LOCAL_LOGINSTATUS];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                AppDelegate *appDe = APPDELEGATE;
                
                [appDe enterLoginVC];
                
            });
        }
        else if (buttonIndex == 1)
        {
            //取消
        }
    }
    else if (actionSheet.tag == 1011)
    {
        if (buttonIndex == 0)
        {
            //清理缓存
            [self cleanrFilecache];
        }
        else if (buttonIndex == 1)
        {
            //取消
        }
    }
}

-(void) introduceToFriend
{
    [UMSocialData defaultData].extConfig.qzoneData.title = shareAppTitleString;
    
    [UMSocialData defaultData].extConfig.qqData.title = shareAppTitleString;
    
    //设置微信好友title方法为
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = shareAppTitleString;
    
    //设置微信朋友圈title方法替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = shareAppTitleString;
    
    UIImage *shareImage = [UIImage imageNamed:@"login_logo_icon.png"];
    
    [UMSocialData defaultData].extConfig.wechatSessionData.url = TURNTO_APPSTORE_LINK;
    
    //如果是朋友圈，则替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = TURNTO_APPSTORE_LINK;
    
    [UMSocialData defaultData].extConfig.qqData.url = TURNTO_APPSTORE_LINK;
    
    //Qzone设置点击分享内容跳转链接替换平台参数名即可
    
    [UMSocialData defaultData].extConfig.qzoneData.url = TURNTO_APPSTORE_LINK;
    
    //QQ分享类型改为
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    
    //微信分享类型改为
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:TURNTO_APPSTORE_LINK];
    
    [SGActionView showGridMenuWithTitle:@"推荐妖刀"
                             itemTitles:@[@"微信好友", @"朋友圈", @"QQ", @"QQ空间"]
                                 images:@[[UIImage imageNamed:@"umshare_wechat_friend.png"],
                                          [UIImage imageNamed:@"umshare_wechat_session.png"],
                                          [UIImage imageNamed:@"umshare_qq.png"],
                                          [UIImage imageNamed:@"umshare_qzone.png"]]
                         selectedHandle:^(NSInteger index){
                             
                             switch (index)
                             {
                                 case 0:
                                 {
                                     
                                     //取消
                                 }
                                     break;
                                     
                                 case 1:
                                 {
                                     
                                     [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:shareAppString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                                         if (response.responseCode == UMSResponseCodeSuccess)
                                         {
                                             NSLog(@"微信好友 分享成功！");
                                         }
                                     }];
                                 }
                                     break;
                                 case 2:
                                 {
                                     
                                     [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareAppString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                                         
                                         if (response.responseCode == UMSResponseCodeSuccess)
                                         {
                                             
                                             NSLog(@"朋友圈 分享成功！");
                                         }
                                     }];
                                 }
                                     break;
                                 case 3:
                                 {
                                     
                                     [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:shareAppString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response)
                                      {
                                          
                                          NSLog(@"responseCode %d",response.responseCode);
                                          if (response.responseCode == UMSResponseCodeSuccess)
                                          {
                                              NSLog(@"QQ 分享成功！");
                                          }
                                      }];
                                     
                                 }
                                     break;
                                 case 4:
                                 {
                                     
                                     [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareAppString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response)
                                      {
                                          
                                          NSLog(@"responseCode %d",response.responseCode);
                                          
                                          if (response.responseCode == UMSResponseCodeSuccess)
                                          {
                                              NSLog(@"QQ空间 分享成功！");
                                          }
                                      }];
                                 }
                                     break;
                                     
                                 case 5:
                                 {
                                     
                                     [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",shareAppTitleString,TURNTO_APPSTORE_LINK] image:shareImage location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
                                         if (response.responseCode == UMSResponseCodeSuccess) {
                                             NSLog(@"分享成功！");
                                         }
                                     }];
                                     
                                 }
                                     break;
                                     
                                 default:
                                     break;
                             }
                             
                         }];
}


@end
