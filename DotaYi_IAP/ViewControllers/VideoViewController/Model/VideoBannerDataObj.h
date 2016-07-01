//
//  VideoBannerDataObj.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/7/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <Foundation/Foundation.h>

//视频banner滚动图
@interface VideoBannerDataObj : NSObject

@property (nonatomic,copy) NSNumber *TagId;

@property (nonatomic,copy) NSNumber *RelationId;

@property (nonatomic,copy) NSNumber *RelationType;

@property (nonatomic,copy) NSNumber *VideoId;

@property (nonatomic,copy) NSNumber *ScoreType;

@property (nonatomic,copy) NSNumber *WatchQuantity;

@property (nonatomic,copy) NSNumber *RealWatchQuantity;

@property (nonatomic,copy) NSNumber *DateRealWatchQuantity;

@property (nonatomic,copy) NSNumber *CommentQuantity;

@property (nonatomic,copy) NSNumber *IsTop;

@property (nonatomic,copy) NSNumber *UploadInterval;

@property (nonatomic,copy) NSString *TagName;

@property (nonatomic,copy) NSString *RelationName;

@property (nonatomic,copy) NSString *VideoName;//视频标题

@property (nonatomic,copy) NSString *TotalTime;//视频时长

@property (nonatomic,copy) NSString *VideoUrl;//视频链接

@property (nonatomic,copy) NSString *ImageUrl;//视频图片

@property (nonatomic,copy) NSString *CreateDate;//创建时间

@property (nonatomic,copy) NSString *CreateDateStringCode;

@property (nonatomic,copy) NSString *DateStringCode;//中文时间

@end


//选择某个主播得到视频列表
@interface AnchorVideoListData : NSObject

@property (nonatomic,copy) NSNumber *TagId;
@property (nonatomic,copy) NSNumber *RelationId;
@property (nonatomic,copy) NSNumber *RelationType;
@property (nonatomic,copy) NSNumber *VideoId;
@property (nonatomic,copy) NSNumber *ScoreType;
@property (nonatomic,copy) NSNumber *WatchQuantity;
@property (nonatomic,copy) NSNumber *RealWatchQuantity;
@property (nonatomic,copy) NSNumber *DateRealWatchQuantity;
@property (nonatomic,copy) NSNumber *CommentQuantity;
@property (nonatomic,copy) NSNumber *IsTop;
@property (nonatomic,copy) NSNumber *UploadInterval;

@property (nonatomic,copy) NSString *__type;
@property (nonatomic,copy) NSString *TagName;
@property (nonatomic,copy) NSString *RelationName;//主播名称
@property (nonatomic,copy) NSString *VideoName;//视频名称
@property (nonatomic,copy) NSString *TotalTime;//视频时长
@property (nonatomic,copy) NSString *VideoUrl;//视频链接
@property (nonatomic,copy) NSString *ImageUrl;//视频封面
@property (nonatomic,copy) NSString *CreateDate;
@property (nonatomic,copy) NSString *CreateDateStringCode;//创建时间
@property (nonatomic,copy) NSString *DateStringCode;//中文时间


@end
