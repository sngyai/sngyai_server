//
//  CSMoreGame.h
//  CSADSDK
//
//  Created by CocoaChina_yangjh on 13-11-12.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CSADRequest.h"
#import "CSRequestError.h"

typedef NS_ENUM(unsigned int, CSMoreGameStatus) {
    CSMoreGameStatus_Hide,
    CSMoreGameStatus_Showing,
    CSMoreGameStatus_Show,
    CSMoreGameStatus_Hiding,
};

// 精品推荐加载完成
typedef void (^CSMoreGameDidLoadAD)();
// 精品推荐加载出错
typedef void (^CSMoreGameLoadFailure)(CSRequestError *error);
// 精品推荐打开完成
typedef void (^CSMoreGameDidPresent)();
// 精品推荐将要关闭
typedef void (^CSMoreGameWillDismiss)();
// 精品推荐关闭完成
typedef void (^CSMoreGameDidDismiss)();

@protocol CSMoreGameDelegate;

@interface CSMoreGame : NSObject

// 精品推荐当前状态
@property (nonatomic, readonly) CSMoreGameStatus status;
// CSMoreGame不再使用时，必须将delegate设置为nil。
@property (nonatomic, assign) id <CSMoreGameDelegate> delegate;

// 精品推荐加载完成的block
@property (nonatomic, copy) CSMoreGameDidLoadAD didLoadAD;
// 精品推荐加载出错的block
@property (nonatomic, copy) CSMoreGameLoadFailure loadADFailure;
// 精品推荐打开完成的block
@property (nonatomic, copy) CSMoreGameDidPresent didPresent;
// 精品推荐将要关闭的block
@property (nonatomic, copy) CSMoreGameWillDismiss willDismiss;
// 精品推荐关闭完成的block
@property (nonatomic, copy) CSMoreGameDidDismiss didDismiss;

// 精品推荐只有一个
+ (CSMoreGame *)sharedMoreGame;

/**
 *	@brief	加载精品推荐数据
 *
 *	@param 	csRequest 	请求精品推荐时的参数
 */
- (void)loadMoreGame:(CSADRequest *)csRequest;

/**
 *	@brief	显示精品推荐
 *
 *	@param 	scale 	显示比例
 */
- (void)showMoreGameWithScale:(CGFloat)scale;

/**
 *	@brief	显示精品推荐
 *
 *	@param 	rootView 	精品推荐的父视图
 *	@param 	scale 	显示比例
 */
- (void)showMoreGameOnRootView:(UIView *)rootView withScale:(CGFloat)scale;

/**
 *	@brief	将精品推荐填充到指定view中
 *
 *	@param 	view 	填充精品推荐的view
 */
- (void)fillMoreGameInto:(UIView *)view;

/**
 *	@brief	关闭精品推荐
 */
- (void)closeMoreGame;

@end


@protocol CSMoreGameDelegate <NSObject>

@optional

// 精品推荐加载完成
- (void)csMoreGameDidLoadAd:(CSMoreGame *)csMoreGame;

// 精品推荐加载错误
- (void)csMoreGame:(CSMoreGame *)csMoreGame
loadAdFailureWithError:(CSRequestError *)requestError;

// 精品推荐打开完成
- (void)csMoreGameDidPresentScreen:(CSMoreGame *)csMoreGame;

// 精品推荐将要关闭
- (void)csMoreGameWillDismissScreen:(CSMoreGame *)csMoreGame;

// 精品推荐关闭完成
- (void)csMoreGameDidDismissScreen:(CSMoreGame *)csMoreGame;

@end
