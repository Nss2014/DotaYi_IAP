//
//  SettingsViewController.m
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/4/15.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsTableViewCell.h"

@interface SettingsViewController ()<LEActionSheetDelegate>

@property (nonatomic,strong) NSArray *sectionTwoTitlesArray;

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
    self.sectionTwoTitlesArray = [NSArray arrayWithObjects:@"清除缓存",@"推荐给好友",@"建议与反馈",@"帅的点这儿评分", nil];
}

-(void) initUI
{
    self.navigationItem.title = @"设置";
    
    [self addTableView:UITableViewStylePlain separatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.viwTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - NAV_HEIGHT);
    
    [Tools setExtraCellLineHidden:self.viwTable];
    
    self.viwTable.sectionFooterHeight = 1.0;
}

#pragma mark 列表代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
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
        
        BOOL isLogin = [Tools boolForKey:LOCAL_LOGINSTATUS];
        
        if (isLogin)
        {
//            [cell.SS_userImageView sd_setImageWithURL:[NSURL URLWithString:[HP_Application sharedApplication].loginDataObj.login_headImgUrl] placeholderImage:[UIImage imageNamed:DEFAULT_HEAD_PLACEHOLDER]];
//            
//            cell.SS_userNameLabel.text = [HP_Application sharedApplication].loginDataObj.login_nickName;
        }
        else
        {
            cell.SS_userImageView.image = [UIImage imageNamed:@"login_logoImage"];
            
            cell.SS_userNameLabel.text = @"未登录";
        }
        
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
        
        cell.ST_iconImageView.image = [UIImage imageNamed:@"login_logoImage"];
        
        cell.ST_nameLabel.text = self.sectionTwoTitlesArray[indexPath.row];
        
        cell.ST_indicatorImageView.image = [UIImage imageNamed:@"arrow_point_icon"];
        
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
            //登录&退出登录
            BOOL isLogin = [Tools boolForKey:LOCAL_LOGINSTATUS];
            
            if (isLogin)
            {
                LEActionSheet *actionSheet = [[LEActionSheet alloc] initWithTitle:@"确定要退出登录吗？"
                                                                         delegate:self
                                                                cancelButtonTitle:@"取消"
                                                           destructiveButtonTitle:@"退出登录"
                                                                otherButtonTitles:nil];
                actionSheet.tag = 1010;
                
                [actionSheet showInView:self.view.window];
            }
            else
            {
                
            }
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            //清理缓存
            LEActionSheet *actionSheet = [[LEActionSheet alloc] initWithTitle:@"确认清除本地缓存？"
                                                                     delegate:self
                                                            cancelButtonTitle:@"取消"
                                                       destructiveButtonTitle:@"清除缓存"
                                                            otherButtonTitles:nil];
            actionSheet.tag = 1011;
            
            [actionSheet showInView:self.view.window];
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    
    backView.backgroundColor = WHITE_COLOR;
    
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

#pragma mark - LEActionSheetDelegate

-(void)actionSheet:(LEActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1010)
    {
        if (buttonIndex == 0)
        {
            //退出登录
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



@end
