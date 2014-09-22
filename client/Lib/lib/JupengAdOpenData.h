//
//  JupengAd.h
//  JpSDK
//
//  Created by jupeng on 14-2-28.
//  Copyright (c) 2014年 Jupeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JupengAdOpenData : NSObject


// 该开放源应用的标示
@property(nonatomic, retain, readonly)    NSString    *storeID;

// 应用名称
@property(nonatomic, retain, readonly)    NSString    *name;

// 应用的详细描述
@property(nonatomic, retain, readonly)    NSString    *desc;

// 应用版权所有者
@property(nonatomic, retain, readonly)    NSString    *author;

// 应用的大小
@property(nonatomic, assign, readonly)    NSInteger   size;

// 应用的小图标
@property(nonatomic, retain, readonly)    NSString    *smallIconURL;

// 应用的大图标
@property(nonatomic, retain, readonly)    NSString    *largeIconURL;

// 简短广告词
@property(nonatomic, retain, readonly)    NSString    *adText;

// 提示语（例如：首次安装并创建新角色获取积分）
@property(nonatomic, retain, readonly)    NSString   *task_brief;

// 过期时间
@property(nonatomic, retain, readonly)    NSDate      *expiredDate;

// 积分值[该值对有积分应用有效，无积分应用默认为0]
@property(nonatomic, assign, readonly)    NSInteger   points;

// 获取的积分名称（例如：金币等），开发者在自己的后台自己设置,缺省名称（金币）
@property(nonatomic, retain, readonly)    NSString   *pointsName;

// 应用版本
@property(nonatomic, retain,readonly)     NSString    *appVersion;



@end
