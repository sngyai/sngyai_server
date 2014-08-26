//
//  MiidiAdViewDelegate.h
//  MiidiAd
//
//  Created by adpooh miidi on 12-2-20.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MiidiAdView;

@protocol MiidiAdViewDelegate <NSObject>
@optional

#pragma mark Ad Request Notification Methods

// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
// 补充：第一次返回成功数据后调用
- (void)didReceiveAd:(MiidiAdView *)adView;

// 请求广告条数据失败后调用
// 
// 详解:当接收服务器返回的广告数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)didFailReceiveAd:(MiidiAdView *)adView  error:(NSError *)error;

#pragma mark Ad Show Notification Methods



// 显示全屏广告成功后调用
//
// 详解:显示一次全屏广告内容后调用该函数
- (void)didShowAdWindow:(MiidiAdView *)adView;

// 成功关闭全屏广告后调用
//
// 详解:全屏广告显示完成，关闭全屏广告后调用该函数
- (void)didDismissAdWindow:(MiidiAdView *)adView;


@end
