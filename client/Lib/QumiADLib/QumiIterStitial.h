//
//  QumiIterStitial.h
//  qm
//
//  Created by qm on 13-10-28.
//  Copyright (c) 2013年 qm. All rights reserved.
//

//For iPhone
#define QUMI_INTERCUT_SIZE_260x250   CGSizeMake(260,250)

//For iPad
#define QUMI_INTERCUT_SIZE_500x500   CGSizeMake(500,500)

#import <UIKit/UIKit.h>
@protocol QumiInterStitialDelegate;

@interface QumiIterStitial : UIView
{
    id<QumiInterStitialDelegate>   _delegate;
    UIViewController               *_rootViewController;
    BOOL                           _isLoaded;    //广告是否已经加载完毕
}
@property (nonatomic,assign) id<QumiInterStitialDelegate>   delegate;
@property (nonatomic,retain) UIViewController              *rootViewController;
@property (nonatomic,assign) BOOL                           isLoaded;


//初始化插屏广告  插屏广告的尺寸，是否隐藏信号区，是否支持旋转
- (id)initWithQumiInterStitial:(CGSize)IntercutSize isRotate:(BOOL)rotate;

//请求插屏广告
- (void)loadIntercutAd;

//展示插屏广告
- (void)displayInterCutAd;

@end

@protocol QumiInterStitialDelegate <NSObject>

//加载广告成功后，回调该方法
- (void)qmInterCutAdSuccessToLoadAd:(QumiIterStitial *)qmAdView;
//加载广告失败后，回调该方法
- (void)qmInterCutAdFailToLoadAd:(QumiIterStitial *)qmAdView withError:(NSError *)error;
//显示插屏广告，回调该方法
- (void)qmInterCutAdPresent:(QumiIterStitial *)qmAdView;
//关闭插屏广告，回调该方法
- (void)qmInterCutAdDismiss:(QumiIterStitial *)qmAdView;
@end
