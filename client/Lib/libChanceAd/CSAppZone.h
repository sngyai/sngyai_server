//
//  CSAppZone.h
//  CSADSDK
//
//  Created by CocoaChina_yangjh on 13-11-12.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CSADRequest.h"
#import "CSRequestError.h"

typedef NS_ENUM(unsigned int, CSAppZoneStatus) {
    CSAppZoneStatus_Hide,
    CSAppZoneStatus_Showing,
    CSAppZoneStatus_Show,
    CSAppZoneStatus_Hiding,
};

// 积分墙加载完成
typedef void (^CSAppZoneDidLoadAD)();
// 积分墙加载出错
typedef void (^CSAppZoneLoadFailure)(CSRequestError *error);
// 积分墙打开完成
typedef void (^CSAppZoneDidPresent)();
// 积分墙将要关闭
typedef void (^CSAppZoneWillDismiss)();
// 积分墙关闭完成
typedef void (^CSAppZoneDidDismiss)();
// 查询积分时的block
//
//	@param 	taskCoins 	taskCoins中的元素为NSDictionary类型（taskCoins为空表示无积分返回，为nil表示查询出错）
//                            键值说明：taskContent  NSString   任务名称
//                                    coins        NSNumber    赚得金币数量
//	@param 	error 	taskCoins为nil时有效，查询失败原因
typedef void (^CSAppZoneQueryCoin)(NSArray *taskCoins, CSRequestError *error);

@protocol CSAppZoneDelegate;

@interface CSAppZone : NSObject

// 积分墙当前状态
@property (nonatomic, readonly) CSAppZoneStatus status;
// CSAppZone不再使用时，必须将delegate设置为nil。
@property (nonatomic, assign) id <CSAppZoneDelegate> delegate;

// 积分墙加载完成的block
@property (nonatomic, copy) CSAppZoneDidLoadAD didLoadAD;
// 积分墙加载出错的block
@property (nonatomic, copy) CSAppZoneLoadFailure loadADFailure;
// 积分墙打开完成的block
@property (nonatomic, copy) CSAppZoneDidPresent didPresent;
// 积分墙将要关闭的block
@property (nonatomic, copy) CSAppZoneWillDismiss willDismiss;
// 积分墙关闭完成的block
@property (nonatomic, copy) CSAppZoneDidDismiss didDismiss;

// 积分墙只有一个
+ (CSAppZone *)sharedAppZone;

/**
 *	@brief	查询是否有任务完成
 *
 *	@param 	queryResult 	查询积分时的block。queryResult为nil时，必须先设置delegate并实现相关协议方法
 */
- (void)queryRewardCoin:(CSAppZoneQueryCoin)queryResult;

/**
 *	@brief	加载积分墙数据
 *
 *	@param 	CSRequest 	请求积分墙时的参数
 */
- (void)loadAppZone:(CSADRequest *)CSRequest;

/**
 *	@brief	显示积分墙
 *
 *	@param 	scale 	显示比例
 */
- (void)showAppZoneWithScale:(CGFloat)scale;

/**
 *	@brief	显示积分墙
 *
 *	@param 	rootView 	积分墙的父视图
 *	@param 	scale 	显示比例
 */
- (void)showAppZoneOnRootView:(UIView *)rootView withScale:(CGFloat)scale;

/**
 *	@brief	将积分墙填充到指定view中
 *
 *	@param 	view 	填充积分墙的view
 */
- (void)fillAppZoneInto:(UIView *)view;

/**
 *	@brief	关闭积分墙
 */
- (void)closeAppZone;

@end


@protocol CSAppZoneDelegate <NSObject>

/**
 *	@brief	用户完成积分墙任务的回调
 *
 *	@param 	csAppZone 	csAppZone
 *	@param 	taskCoins 	taskCoins中的元素为NSDictionary类型（taskCoins为空表示无积分返回，为nil表示查询出错）
 *                            键值说明：taskContent  NSString   任务名称
 *                                    coins        NSNumber    赚得金币数量
 *	@param 	error 	taskCoins为nil时有效，查询失败原因
 */
- (void)csAppZone:(CSAppZone *)csAppZone queryResult:(NSArray *)taskCoins
        withError:(CSRequestError *)error;

@optional

// 积分墙加载完成
- (void)csAppZoneDidLoadAd:(CSAppZone *)csAppZone;

// 积分墙加载错误
- (void)csAppZone:(CSAppZone *)csAppZone
loadAdFailureWithError:(CSRequestError *)requestError;

// 积分墙打开完成
- (void)csAppZoneDidPresentScreen:(CSAppZone *)csAppZone;

// 积分墙将要关闭
- (void)csAppZoneWillDismissScreen:(CSAppZone *)csAppZone;

// 积分墙关闭完成
- (void)csAppZoneDidDismissScreen:(CSAppZone *)csAppZone;

@end
