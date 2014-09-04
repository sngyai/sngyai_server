//
//  PBBannerView.h
//  PBADSDK
//
//  Created by cassano on 13-10-14.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBADRequest.h"
#import "PBRequestError.h"

#define PBBannerSize_iPhone   CGSizeMake(320.0f, 50.0f)
#define PBBannerSize_iPad     CGSizeMake(728.0f, 90.0f)

// Banner加载完成
typedef void (^PBBannerDidReceiveAd)();
// Banner加载出错
typedef void (^PBBannerLoadFailure)(PBRequestError *error);
// Banner将要显示
typedef void (^PBBannerWillPresent)();
// Banner移除完成
typedef void (^PBBannerDidDismiss)();

@protocol PBBannerViewDelegate;

// iPhone 和 iPod Touch Banner广告大小。目前只有一种 320x50.
// iPad Banner广告大小。目前只有一种 728x90.
@interface PBBannerView : UIView

@property (nonatomic, assign) id <PBBannerViewDelegate> delegate;

// Banner加载完成的block
@property (nonatomic, copy) PBBannerDidReceiveAd didReceiveAd;
// Banner加载出错的block
@property (nonatomic, copy) PBBannerLoadFailure loadADFailure;
// Banner将要显示的block
@property (nonatomic, copy) PBBannerWillPresent willPresent;
// Banner移除完成的block
@property (nonatomic, copy) PBBannerDidDismiss didDismiss;

/**
 *	@brief	加载Banner广告
 *
 *	@param 	pbRequest 	请求Banner广告时的参数
 */
- (void)loadRequest:(PBADRequest *)pbRequest;


@end


@protocol PBBannerViewDelegate <NSObject>

@optional

// 收到Banner广告
- (void)pbBannerViewDidReceiveAd:(PBBannerView *)pbBannerView;

// Banner广告数据错误
- (void)pbBannerView:(PBBannerView *)pbBannerView
      receiveAdError:(PBRequestError *)requestError;

// 将要展示Banner广告
- (void)pbBannerViewWillPresentScreen:(PBBannerView *)pbBannerView;

// 移除Banner广告
- (void)pbBannerViewDidDismissScreen:(PBBannerView *)pbBannerView;

@end
