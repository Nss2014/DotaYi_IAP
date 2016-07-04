//
//  LeftAnchorDataObj.h
//  DotaYi_IAP
//
//  Created by 牛松松 on 16/7/1.
//  Copyright © 2016年 牛松松. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LeftAnchorDataObj : NSObject

@property (nonatomic,copy) NSString *TagName;//主播名称

@property (nonatomic,copy) NSString *AvatarUrl;//主播头像地址（不包含域名）

@property (nonatomic,copy) NSString *UploadTimeStamp;

@property (nonatomic,copy) NSNumber *TagId;//用于下一步链接中的relation

@property (nonatomic,copy) NSNumber *ScoreType;

@property (nonatomic,copy) NSNumber *SideIndex;

@property (nonatomic,copy) NSNumber *SideSort;

@property (nonatomic,copy) NSNumber *IsTop;

@property (nonatomic,copy) NSNumber *TopSort;

@property (nonatomic,copy) NSNumber *VideoQuantity;

@property (nonatomic,copy) NSNumber *UploadInterval;

@end
