//
//  PBOfferWall.h
//  PBADSDK
//
//  Created by CocoaChina_yangjh on 13-11-12.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PBADRequest.h"
#import "PBRequestError.h"

typedef NS_ENUM(unsigned int, PBOfferWallStatus) {
    PBOfferWallStatus_Hide,
    PBOfferWallStatus_Showing,
    PBOfferWallStatus_Show,
    PBOfferWallStatus_Hiding,
};

// 积分墙加载完成
typedef void (^PBOfferWallDidLoadAD)();
// 积分墙加载出错
typedef void (^PBOfferWallLoadFailure)(PBRequestError *error);
// 积分墙打开完成
typedef void (^PBOfferWallDidPresent)();
// 积分墙将要关闭
typedef void (^PBOfferWallWillDismiss)();
// 积分墙关闭完成
typedef void (^PBOfferWallDidDismiss)();
// 查询积分时的block
//
//	@param 	taskCoins 	taskCoins中的元素为NSDictionary类型（taskCoins为空表示无积分返回，为nil表示查询出错）
//                            键值说明：taskContent  NSString   任务名称
//                                    coins        NSNumber    赚得金币数量
//	@param 	error 	taskCoins为nil时有效，查询失败原因
typedef void (^PBOfferWallQueryCoin)(NSArray *taskCoins, PBRequestError *error);

@protocol PBOfferWallDelegate;

@interface PBOfferWall : NSObject

// 积分墙当前状态
@property (nonatomic, readonly) PBOfferWallStatus status;
// PBOfferWall不再使用时，必须将delegate设置为nil。
@property (nonatomic, assign) id <PBOfferWallDelegate> delegate;

// 积分墙加载完成的block
@property (nonatomic, copy) PBOfferWallDidLoadAD didLoadAD;
// 积分墙加载出错的block
@property (nonatomic, copy) PBOfferWallLoadFailure loadADFailure;
// 积分墙打开完成的block
@property (nonatomic, copy) PBOfferWallDidPresent didPresent;
// 积分墙将要关闭的block
@property (nonatomic, copy) PBOfferWallWillDismiss willDismiss;
// 积分墙关闭完成的block
@property (nonatomic, copy) PBOfferWallDidDismiss didDismiss;

// 积分墙只有一个
+ (PBOfferWall *)sharedOfferWall;

/**
 *	@brief	查询是否有任务完成
 *
 *	@param 	queryResult 	查询积分时的block。queryResult为nil时，必须先设置delegate并实现相关协议方法
 */
- (void)queryRewardCoin:(PBOfferWallQueryCoin)queryResult;

/**
 *	@brief	加载积分墙数据
 *
 *	@param 	pbRequest 	请求积分墙时的参数
 */
- (void)loadOfferWall:(PBADRequest *)pbRequest;

/**
 *	@brief	显示积分墙
 *
 *	@param 	scale 	显示比例
 */
- (void)showOfferWallWithScale:(CGFloat)scale;

/**
 *	@brief	显示积分墙
 *
 *	@param 	rootView 	积分墙的父视图
 *	@param 	scale 	显示比例
 */
- (void)showOfferWallOnRootView:(UIView *)rootView withScale:(CGFloat)scale;

/**
 *	@brief	将积分墙填充到指定view中
 *
 *	@param 	view 	填充积分墙的view
 */
- (void)fillOfferWallInto:(UIView *)view;

/**
 *	@brief	关闭积分墙
 */
- (void)closeOfferWall;

@end


@protocol PBOfferWallDelegate <NSObject>

/**
 *	@brief	用户完成积分墙任务的回调
 *
 *	@param 	pbOfferWall 	pbOfferWall
 *	@param 	taskCoins 	taskCoins中的元素为NSDictionary类型（taskCoins为空表示无积分返回，为nil表示查询出错）
 *                            键值说明：taskContent  NSString   任务名称
 *                                    coins        NSNumber    赚得金币数量
 *	@param 	error 	taskCoins为nil时有效，查询失败原因
 */
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall queryResult:(NSArray *)taskCoins
          withError:(PBRequestError *)error;

@optional

// 积分墙加载完成
- (void)pbOfferWallDidLoadAd:(PBOfferWall *)pbOfferWall;

// 积分墙加载错误
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall
loadAdFailureWithError:(PBRequestError *)requestError;

// 积分墙打开完成
- (void)pbOfferWallDidPresentScreen:(PBOfferWall *)pbOfferWall;

// 积分墙将要关闭
- (void)pbOfferWallWillDismissScreen:(PBOfferWall *)pbOfferWall;

// 积分墙关闭完成
- (void)pbOfferWallDidDismissScreen:(PBOfferWall *)pbOfferWall;

@end
