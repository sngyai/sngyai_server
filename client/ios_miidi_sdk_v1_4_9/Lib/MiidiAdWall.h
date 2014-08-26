//
//  MiidiAdWall.h
//  MiidiAd
//
//  Created by adpooh miidi on 12-2-15.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"
#import "MiidiAdDesc.h"


@interface MiidiAdWall : NSObject 

#pragma mark -
// 获取积分,通过委托,异步通知积分值,或者失败
// 
+ (BOOL)	  requestGetPoints:(id<MiidiAdWallGetPointsDelegate>) delegate;

// 减少积分, 通过委托,异步通知是否成功
+ (BOOL)	  requestSpendPoints:(NSInteger)points withDelegate:(id<MiidiAdWallSpendPointsDelegate>) delegate;

// 增加积分,通过委托,异步通知是否成功
+ (BOOL)	  requestAwardPoints:(NSInteger)points withDelegate:(id<MiidiAdWallAwardPointsDelegate>) delegate;

// 显示积分墙
// 参数 hostViewController		: 通过api [hostViewController presentModalViewController:nav animated:YES];
+ (BOOL)      showAppOffers:(UIViewController*)hostViewController withDelegate:(id<MiidiAdWallShowAppOffersDelegate>) delegate;


// 显示意见反馈
// 参数 hostViewController		: 通过api [hostViewController presentModalViewController:nav animated:YES];
+ (BOOL)	  showAppFeedback:(UIViewController*)hostViewController;

// 是否启动积分墙开关,应用启动,从服务器获取
+ (BOOL)	  requestToggleOfAdWall:(id<MiidiAdWallRequestToggleDelegate>) delegate;

// 用于服务器积分对接,设置自定义参数,参数可以传递给对接服务器
// 参数 paramText				: 需要传递给对接服务器的自定义参数  
+ (void)	  setUserParam:(NSString*)paramText;

/*
 *\获取积分墙的广告数据源列表
 */
+ (void)      requestAdSourcesWithBlock:(void (^)(NSArray*, NSError *))receivedBlock;


/*  安装积分墙中的APP
 *  param adItem 通过requestAdSource获得的广告
 */
+ (void)      requestClickAd:(MiidiAdDesc *)adItem;
@end
