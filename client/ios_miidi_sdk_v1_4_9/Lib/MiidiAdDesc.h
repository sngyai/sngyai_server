//
//  MiidiAdDesc.h
//  MiidiSDKApp
//
//  Created by xuyi on 14-1-26.
//  Copyright (c) 2014年 miidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiidiAdDesc : NSObject


#pragma - property
// 广告id
@property(nonatomic, retain, readonly)  NSString   *adId;

// 广告标题
@property(nonatomic, retain, readonly)  NSString   *title;

// 广告语文字
@property(nonatomic, retain, readonly)  NSString   *text;

// 广告图标Url
@property(nonatomic, retain, readonly)  NSString   *iconUrl;

// 积分值
@property(nonatomic, assign, readonly)  NSInteger   points;

// 应用描述
@property(nonatomic, retain, readonly)  NSString   *description;

// 程序版本
@property(nonatomic, retain, readonly)  NSString   *appVersion;

// 安装包大小
@property(nonatomic, assign, readonly)  NSInteger   appSize;

// 应用提供商
@property(nonatomic, retain, readonly)  NSString   *appProvider;

// 应用截图的URL
@property(nonatomic, retain, readonly)  NSString   *appImageUrls;

// 广告应用包名
@property(nonatomic, retain, readonly)  NSString   *appPackageName;

// 用于存储“安装”或“注册”的字段
@property(nonatomic, retain, readonly)  NSString   *appAction;

// 获取积分步骤提示（例如：首次下载，注册一个新帐号）
@property(nonatomic, retain, readonly)  NSString   *earnScoreStep;

// 广告过期时间
@property(nonatomic, retain, readonly)  NSDate      *expiredTime;

@end
