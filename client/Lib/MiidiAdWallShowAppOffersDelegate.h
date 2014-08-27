//
//  MiidiAdWallShowAppOffersDelegate.h
//  MiidiAd
//
//  Created by adpooh miidi on 12-3-13.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MiidiAdWall;


@protocol MiidiAdWallShowAppOffersDelegate <NSObject>
@optional

// 请求应用列表成功
// 
// 详解:
//      广告墙请求成功后回调该方法
// 补充:
//
- (void)didReceiveOffers;

// 请求应用列表失败
// 
// 详解:
//      广告墙请求失败后回调该方法
// 补充:
//
- (void)didFailToReceiveOffers:(NSError *)error;

#pragma mark Screen View Notification Methods

// 显示全屏页面
// 
// 详解:
//      全屏页面显示完成后回调该方法
// 补充:
//
- (void)didShowWallView;

// 隐藏全屏页面
// 
// 详解:
//      全屏页面隐藏完成后回调该方法
// 补充:
//
- (void)didDismissWallView;

@end
