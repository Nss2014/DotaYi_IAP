//
//  LEActionSheet.h
//  LEActionSheet
//
//  Created by LEA on 15/9/28.
//  Copyright © 2015年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LEActionSheetDelegate;
@interface LEActionSheet : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *_tableView;
    UIView          *_sheetView;
    UIView          *_alphaView;
}

@property (nonatomic, assign) id<LEActionSheetDelegate> delegate;
@property (nonatomic, assign) NSInteger cancelButtonIndex;
@property (nonatomic, assign) NSInteger destructiveButtonIndex;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *cancelButtonTitle;
@property (nonatomic, retain) NSString *destructiveButtonTitle;
@property (nonatomic, retain) NSMutableArray *otherButtonTitles;
@property (nonatomic, readonly) NSInteger numberOfButtons;

- (LEActionSheet *)initWithTitle:(NSString *)title delegate:(id<LEActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles;

- (void)showInView:(UIView *)view;

@end


@protocol LEActionSheetDelegate <NSObject>
@optional

- (void)actionSheet:(LEActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
