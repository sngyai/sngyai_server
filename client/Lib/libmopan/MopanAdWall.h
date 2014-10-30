//
//  MopanAdWall.h
//  MopanSdk
//
//  Created by mopan on 13-6-5.
//  Copyright (c) 2013年 mopan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MopanAdWall;

@protocol MopanAdWallDelegate <NSObject>
// 积分墙开始加载数据。
// Adall starts to work.
- (void)adwallDidShowAppsStartLoad;

// 关闭积分墙页面。
// Offer wall closed.
- (void)adwallDidShowAppsClosed;

// 积分墙加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
- (void)adwallDidFailShowAppsWithError:(NSError *)error;

#pragma mark Point Check Callbacks
// 请求积分值成功后调用
//
// 详解:当接收服务器返回的积分值成功后调用该函数
// 补充：totalMoney: 返回用户的总积分
//      moneyName  : 返回的积分名称
- (void)adwallSuccessGetMoney:(NSInteger)totalMoney forMoneyName:(NSString*)moneyName;

// 请求积分值数据失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)adwallFailGetMoney:(NSError *)error;

// 请求消耗积分成功后调用
//
// 详解:当接收服务器返回的消耗积分成功后调用该函数
// 补充：totalMoney: 返回用户的总积分

- (void)adwallSuccessSpendMoney:(NSInteger)totalMoney;


// 请求消耗积分数据失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)adwallFailSpendMoney:(NSError *)error;

// 请求奖励积分成功后调用
//
// 详解:当接收服务器返回的奖励积分成功后调用该函数
// 补充：totalMoney: 返回用户的总积分
- (void)adwallSuccessAddMoney:(NSInteger)totalMoney;

// 请求奖励积分数据失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：第一次和接下来每次如果请求失败都会调用该函数
- (void)adwallFailAddMoney:(NSError *)error;


// 成功请求积分墙是否可以正常使用
//
// 详解:当接收服务器返回积分墙开关成功后调用该函数
// 补充：adWallEnable: 返回积分墙是否开启
- (void)adwallSuccessAskEnable:(BOOL)adWallEnable;

// 请求积分墙开关失败后调用
//
// 详解:当接收服务器返回的数据失败后调用该函数
// 补充：
- (void)adwallFailAskEnable:(NSError *)error;
@end


/***
 *  MopanAdWall
 *
 ***/

@interface MopanAdWall : NSObject

@property (nonatomic, assign) NSObject<MopanAdWallDelegate> *delegate;
@property (nonatomic, assign) UIViewController *rootViewController;

// 设置开发者账号，账号获取来自网站www.imopan.com
-(id) initWithMopanWall:(NSString*) appID withMopanWallAppPassword:(NSString*)appPassword;

// 显示积分墙
- (void)      showMoneyOffers;

// 获取积分,通过委托,异步通知积分值,或者失败
//
- (void)	  getMoney;

// 减少积分, 通过委托,异步通知是否成功
- (void)	  spendMoney: (NSInteger)money;

// 增加积分,通过委托,异步通知是否成功
- (void)	  addMoney:(NSInteger)money;

// 是否启动积分墙是否可以正常,应用启动,从服务器获取 。设置的开关在开发者后台
- (void)	  queryWallEnable;

// 用于服务器积分对接,设置自定义参数,参数可以传递给对接服务器
// 参数 userID				: 需要传递给对接服务器的自定义参数
- (void)	  setCustomUserID:(NSString*)userID;


@end
