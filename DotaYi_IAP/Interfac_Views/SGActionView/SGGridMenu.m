//
//  SGGridMenu.m
//  SGActionView
//
//  Created by Sagi on 13-9-6.
//  Copyright (c) 2013年 AzureLab. All rights reserved.
//

#import "SGGridMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "cnvUILabel.h"

#define kMAX_CONTENT_SCROLLVIEW_HEIGHT   400

@interface SGGridItem : UIButton
@property (nonatomic, weak) SGGridMenu *menu;

@property (nonatomic,assign) CGFloat itemWidthScale;//宽比
@end

@implementation SGGridItem

- (id)initWithTitle:(NSString *)title image:(UIImage *)image
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.clipsToBounds = NO;
        
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:BaseMenuTextColor(self.menu.style) forState:UIControlStateNormal];
        [self setImage:image forState:UIControlStateNormal];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    
    if ([Tools IsHaveStringIn:[[UIDevice currentDevice] platformString] findString:@"iPad 3"]
        ||[Tools IsHaveStringIn:[[UIDevice currentDevice] platformString] findString:@"iPad 4"]
        ||[Tools IsHaveStringIn:[[UIDevice currentDevice] platformString] findString:@"iPad Air"]
        || [Tools IsHaveStringIn:[[UIDevice currentDevice] platformString] findString:@"iPad Mini"])
    {
        CGRect imageRect = CGRectMake(width * 0.3, width * 0.15, width * self.itemWidthScale, width * self.itemWidthScale);
        
        self.imageView.frame = imageRect;
        
        float labelHeight = height - (imageRect.origin.y + imageRect.size.height);
        CGRect labelRect = CGRectMake(width * 0.05, imageRect.origin.y + imageRect.size.height - 5 , width * 0.9, labelHeight);
        self.titleLabel.frame = labelRect;
    }
    else
    {
        CGRect imageRect = CGRectMake(width * 0.2, width * 0.15, width * self.itemWidthScale, width * self.itemWidthScale);
        
        self.imageView.frame = imageRect;
        
        float labelHeight = height - (imageRect.origin.y + imageRect.size.height);
        CGRect labelRect = CGRectMake(width * 0.05, imageRect.origin.y + imageRect.size.height + 5, width * 0.9, labelHeight);
        self.titleLabel.frame = labelRect;
    }
    
    self.titleLabel.center = CGPointMake(self.imageView.center.x, self.titleLabel.center.y);
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    
    self.titleLabel.numberOfLines = 2;
}

@end


@interface SGGridMenu ()
@property (nonatomic, strong) cnvUILabel *titleLabel;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) SGButton *cancelButton;
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSArray *itemImages;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) void (^actionHandle)(NSInteger);
@end

@implementation SGGridMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BaseMenuBackgroundColor(self.style);

        _itemTitles = [NSArray array];
        _itemImages = [NSArray array];
        _items = [NSArray array];
        
        _titleLabel = [[cnvUILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = COLOR_TITLE_LIGHTGRAY;
        [self addSubview:_titleLabel];
        
        _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        _contentScrollView.contentSize = _contentScrollView.bounds.size;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentScrollView];
        
        _cancelButton = [SGButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.clipsToBounds = YES;
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_cancelButton setTitleColor:BaseMenuTextColor(self.style) forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(tapAction:)
                forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取    消" forState:UIControlStateNormal];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (id)initWithTitle:(NSString *)title itemTitles:(NSArray *)itemTitles images:(NSArray *)images
{

    self = [self initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        NSInteger count = MIN(itemTitles.count, images.count);
        
        [_titleLabel cnv_setUILabelText:title andKeyWord:@"妖刀"];
        
        [_titleLabel cnv_setUIlabelTextColor:COLOR_TITLE_LIGHTGRAY  andKeyWordColor:XLS_COLOR_MAIN_GREEN];
        
//        _titleLabel.text = title;
        _itemTitles = [itemTitles subarrayWithRange:NSMakeRange(0, count)];
        _itemImages = [images subarrayWithRange:NSMakeRange(0, count)];
        [self setupWithItemTitles:_itemTitles images:_itemImages];
    }
    return self;
}

- (void)setupWithItemTitles:(NSArray *)titles images:(NSArray *)images
{
    NSMutableArray *items = [NSMutableArray array];
    for (int i=0; i<titles.count; i++) {
        SGGridItem *item = [[SGGridItem alloc] initWithTitle:titles[i] image:images[i]];
        item.menu = self;
        item.tag = i;
        [item addTarget:self
                 action:@selector(tapAction:)
       forControlEvents:UIControlEventTouchUpInside];
        [items addObject:item];
        [_contentScrollView addSubview:item];
    }
    _items = [NSArray arrayWithArray:items];
}

- (void)setStyle:(SGActionViewStyle)style{
    _style = style;
    
    self.backgroundColor = BaseMenuBackgroundColor(style);
    self.titleLabel.textColor = COLOR_TITLE_LIGHTGRAY;
    [self.cancelButton setTitleColor:BaseMenuTextColor(self.style) forState:UIControlStateNormal];
    for (SGGridItem *item in self.items) {
        [item setTitleColor:BaseMenuTextColor(style) forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.frame = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, 40)};

    [self layoutContentScrollView];
    self.contentScrollView.frame = (CGRect){CGPointMake(0, self.titleLabel.frame.size.height), self.contentScrollView.bounds.size};
    
    self.cancelButton.frame = CGRectMake(0, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height, self.bounds.size.width, 44);
    
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, self.titleLabel.bounds.size.height + self.contentScrollView.bounds.size.height + self.cancelButton.bounds.size.height)};
}

- (void)layoutContentScrollView
{
    NSInteger itemCount = self.items.count;
    
    NSInteger check_num = 4;

    UIEdgeInsets margin;
    
    if (itemCount == 4)
    {
        margin = UIEdgeInsetsMake(0, 10, 15, 10);
    }
    else if (itemCount == 5)
    {
        
        check_num = 5;
        
        margin = UIEdgeInsetsMake(0, 20, 15, 10);
    }
    else
    {
        check_num = 4;
        
        margin = UIEdgeInsetsMake(0, 10, 15, 10);
    }
    
    CGSize itemSize = CGSizeMake((self.bounds.size.width - margin.left - margin.right) / check_num, (self.bounds.size.width - margin.left - margin.right) / check_num);

    NSInteger rowCount = ((itemCount-1) / check_num) + 1;
    self.contentScrollView.contentSize = CGSizeMake(self.bounds.size.width, rowCount * itemSize.height + margin.top + margin.bottom);
    for (int i=0; i<itemCount; i++) {
        SGGridItem *item = self.items[i];
        int row = i / check_num;
        int column = i % check_num;
        CGPoint p = CGPointMake(margin.left + column * itemSize.width, margin.top + row * itemSize.height);
        item.frame = (CGRect){p, itemSize};
        
        if ([Tools IsHaveStringIn:[[UIDevice currentDevice] platformString] findString:@"iPad 3"]
            ||[Tools IsHaveStringIn:[[UIDevice currentDevice] platformString] findString:@"iPad 4"]
            ||[Tools IsHaveStringIn:[[UIDevice currentDevice] platformString] findString:@"iPad Air"]
            || [Tools IsHaveStringIn:[[UIDevice currentDevice] platformString] findString:@"iPad Mini"])
        {
            if (itemCount == 4)
            {
                item.itemWidthScale = 0.4;
            }
            else if (itemCount == 5)
            {
                item.itemWidthScale = 0.3;
            }
            else
            {
                item.itemWidthScale = 0.4;
            }
        }
        else
        {
            if (itemCount == 4)
            {
                item.itemWidthScale = 0.6;
            }
            else if (itemCount == 5)
            {
                item.itemWidthScale = 0.5;
            }
            else
            {
                item.itemWidthScale = 0.6;
            }
        }
        
        [item layoutIfNeeded];
    }
    
    if (self.contentScrollView.contentSize.height > kMAX_CONTENT_SCROLLVIEW_HEIGHT) {
        self.contentScrollView.bounds = (CGRect){CGPointZero, CGSizeMake(self.bounds.size.width, kMAX_CONTENT_SCROLLVIEW_HEIGHT)};
    }else{
        self.contentScrollView.bounds = (CGRect){CGPointZero, self.contentScrollView.contentSize};
    }
}

#pragma mark - 

- (void)triggerSelectedAction:(void (^)(NSInteger))actionHandle
{
    self.actionHandle = actionHandle;
}

#pragma mark -

- (void)tapAction:(UIButton *)sender
{
    if (self.actionHandle) {
        if ([sender isEqual:self.cancelButton]) {
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle(0);
            });
        }else{
            double delayInSeconds = 0.15;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                self.actionHandle([sender tag] + 1);
            });
        }
    }
}

@end
