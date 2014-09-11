//
//  MobiSageJoy.h
//  MobiSageJoy
//
//  Created by fwang on 13-12-6.
//  Copyright (c) 2013年 adsage. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h> 

// 消费结果状态码
typedef enum {
    // 消费成功
    MobiSageJoyConsumeStatusCodeSuccess = 1,
    // 剩余积分不足
    MobiSageJoyConsumeStatusCodeInsufficient,
    // 订单重复/未知的错误
    MobiSageJoyConsumeStatusCodeDuplicateOrder
} MobiSageJoyConsumeStatusCode;

@class MobiSageJoyViewController;
@protocol MobiSageJoyDelegate <NSObject>
@optional
// 积分墙开始加载列表数据。
- (void)JoyDidStartLoad:(MobiSageJoyViewController *)owInterstitial;
// 积分墙加载完成。
- (void)JoyDidFinishLoad:(MobiSageJoyViewController *)owInterstitial;
// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
- (void)JoyDidFailLoadWithError:(MobiSageJoyViewController *)owInterstitial withError:(NSError *)error;
// 积分墙页面被关闭。
- (void)JoyDidClosed:(MobiSageJoyViewController *)owInterstitial;

// 积分查询成功之后，回调该接口，获取剩余积分和总已消费积分。
- (void)JoyDidFinishCheckPointWithBalancePoint:(MobiSageJoyViewController *)owInterstitial balance:(NSInteger)balance
                             andTotalConsumedPoint:(NSInteger)consumed;

// 积分查询失败之后，回调该接口，返回查询失败的错误原因。
- (void)JoyDidFailCheckPointWithError:(MobiSageJoyViewController *)owInterstitial withError:(NSError *)error;

// 消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及剩余积分和总已消费积分。
- (void)JoyDidFinishConsumePointWithStatusCode:(MobiSageJoyViewController *)owInterstitial code:(MobiSageJoyConsumeStatusCode)statusCode
                                          balancePoint:(NSInteger)balance
                                  totalConsumedPoint:(NSInteger)consumed;
// 消费请求异常应答后，回调该接口，并返回异常的错误原因。
- (void)JoyDidFailConsumePointWithError:(MobiSageJoyViewController *)owInterstitial withError:(NSError *)error;

@optional
// 当积分墙插屏广告被成功加载后，回调该方法
- (void)JoyInterstitialSuccessToLoadAd:(MobiSageJoyViewController *)owInterstitial;
// 当积分墙插屏广告加载失败后，回调该方法
- (void)JoyInterstitialFailToLoadAd:(MobiSageJoyViewController *)owInterstitial withError:(NSError *)err;
// 当积分墙插屏广告要被呈现出来前，回调该方法
- (void)JoyInterstitialWillPresentScreen:(MobiSageJoyViewController *)owInterstitial;
// 当积分墙插屏广告被关闭后，回调该方法
- (void)JoyInterstitialDidDismissScreen:(MobiSageJoyViewController *)owInterstitial;
@end

@interface MobiSageJoyViewController : UIViewController
{

}
@property (nonatomic, assign) NSObject<MobiSageJoyDelegate> *delegate;
@property (nonatomic, assign) UIViewController *rootViewController;

// 禁用StoreKit库提供的应用内打开store页面的功能，采用跳出应用打开OS内置AppStore。默认为NO，即使用StoreKit。
@property (nonatomic, assign) BOOL disableStoreKit;

//列表积分墙开关
-(BOOL)isJoyListEnable;
//插屏积分墙开关
-(BOOL)isJoyFlatEnable;

//自定义开关
-(BOOL)getSwitch:(NSString*) akey default:(BOOL) enable;

-(void)setURLScheme:(NSString*) scheme;


// 使用Publisher ID初始化积分墙ViewController
-(id)initWithPublisherID:(NSString *)publisherID;

// 使用Publisher ID和应用当前登陆用户的User ID（或其它的在应用中唯一标识用户的ID）初始化积分墙ViewController
-(id)initWithPublisherID:(NSString *)publisherID andUserID:(NSString *)userID;

//更改userID
-(void)setUserID:(NSString *)userID;

// 使用App的rootViewController来弹出并显示积分墙。
- (void)presentJoy;

// 使用开发者传入的UIViewController来弹出显示积分墙。
- (void)presentJoyWithViewController:(UIViewController *)controller;

// 查询积分.
- (void)requestOnlinePointCheck;
// 消费指定积分
- (void)requestOnlineConsumeWithPoint:(NSUInteger)pointToConsume;


// 请求加载插屏积分墙
- (void)loadJoyInterstitial;

// 询问积分墙插屏是否完成。
- (BOOL)isJoyInterstitialReady;

// 显示加载完成的积分墙插屏。若没有加载完成，不会展现。
- (void)presentJoyInterstitial;
@end
