//
//  CSNativeMoreGame.h
//  CSADSDK
//
//  Created by CocoaChina_yangjh on 14-6-24.
//  Copyright (c) 2014年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#ifndef CSNativeMoreGame_h
#define CSNativeMoreGame_h
@protocol CSNativeMoreGameDelegate;

@interface CSNativeMoreGame : NSObject

@property (nonatomic, copy) NSString *placementID;  // 广告位ID
// CSNativeMoreGame不再使用时，必须将delegate设置为nil。
@property (nonatomic, assign) id <CSNativeMoreGameDelegate> delegate;

// 原生精品推荐只有一个
+ (CSNativeMoreGame *)sharedMoreGame;

/**
 *	@brief	present原生精品推荐
 */
- (void)presentNativeMoreGame;

/**
 *	@brief	将原生精品推荐push进入导航栏视图控制器
 *
 *	@param 	navigationController 	导航栏视图控制器
 */
- (void)pushNativeMoreGameInto:(UINavigationController *)navigationController;

/**
 *	@brief	关闭原生精品推荐
 */
- (void)closeNativeMoreGame;

@end


@protocol CSNativeMoreGameDelegate <NSObject>

@optional

// 原生精品推荐打开完成（只对IOS5以上的present方式有效）
- (void)csNativeMoreGameDidPresentScreen:(CSNativeMoreGame *)csNativeMoreGame;

// 原生精品推荐将要关闭
- (void)csNativeMoreGameWillDismissScreen:(CSNativeMoreGame *)csNativeMoreGame;

// 原生精品推荐关闭完成（只对IOS5以上的present方式有效）
- (void)csNativeMoreGameDidDismissScreen:(CSNativeMoreGame *)csNativeMoreGame;

@end
#endif
