//
//  CSBannerView.h
//  CSADSDK
//
//  Created by cassano on 13-10-14.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSADRequest.h"
#import "CSRequestError.h"

#define CSBannerSize_iPhone   CGSizeMake(ScreenSize.width, 50.0f)
#define CSBannerSize_iPad     CGSizeMake(728.0f, 90.0f)

// Banner加载完成
typedef void (^CSBannerDidReceiveAd)();
// Banner加载出错
typedef void (^CSBannerLoadFailure)(CSRequestError *error);
// Banner将要显示
typedef void (^CSBannerWillPresent)();
// Banner移除完成
typedef void (^CSBannerDidDismiss)();

@protocol CSBannerViewDelegate;

// iPhone 和 iPod Touch Banner广告大小。目前只有一种 320x50.
// iPad Banner广告大小。目前只有一种 728x90.
@interface CSBannerView : UIView

@property (nonatomic, assign) id <CSBannerViewDelegate> delegate;

// Banner加载完成的block
@property (nonatomic, copy) CSBannerDidReceiveAd didReceiveAd;
// Banner加载出错的block
@property (nonatomic, copy) CSBannerLoadFailure loadADFailure;
// Banner将要显示的block
@property (nonatomic, copy) CSBannerWillPresent willPresent;
// Banner移除完成的block
@property (nonatomic, copy) CSBannerDidDismiss didDismiss;

/**
 *	@brief	加载Banner广告
 *
 *	@param 	csRequest 	请求Banner广告时的参数
 */
- (void)loadRequest:(CSADRequest *)csRequest;


@end


@protocol CSBannerViewDelegate <NSObject>

@optional

// 收到Banner广告
- (void)csBannerViewDidReceiveAd:(CSBannerView *)csBannerView;

// Banner广告数据错误
- (void)csBannerView:(CSBannerView *)csBannerView
      receiveAdError:(CSRequestError *)requestError;

// 将要展示Banner广告
- (void)csBannerViewWillPresentScreen:(CSBannerView *)csBannerView;

// 移除Banner广告
- (void)csBannerViewDidDismissScreen:(CSBannerView *)csBannerView;

@end
