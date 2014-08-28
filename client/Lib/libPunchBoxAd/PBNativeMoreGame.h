//
//  PBNativeMoreGame.h
//  PBADSDK
//
//  Created by CocoaChina_yangjh on 14-6-24.
//  Copyright (c) 2014年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


#ifndef PBNativeMoreGame_h
#define PBNativeMoreGame_h
@protocol PBNativeMoreGameDelegate;

@interface PBNativeMoreGame : NSObject

@property (nonatomic, copy) NSString *placementID;  // 广告位ID
// PBNativeMoreGame不再使用时，必须将delegate设置为nil。
@property (nonatomic, assign) id <PBNativeMoreGameDelegate> delegate;

// 原生精品推荐只有一个
+ (PBNativeMoreGame *)sharedMoreGame;

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


@protocol PBNativeMoreGameDelegate <NSObject>

@optional

// 原生精品推荐打开完成（只对IOS5以上的present方式有效）
- (void)pbNativeMoreGameDidPresentScreen:(PBNativeMoreGame *)pbNativeMoreGame;

// 原生精品推荐将要关闭
- (void)pbNativeMoreGameWillDismissScreen:(PBNativeMoreGame *)pbNativeMoreGame;

// 原生精品推荐关闭完成（只对IOS5以上的present方式有效）
- (void)pbNativeMoreGameDidDismissScreen:(PBNativeMoreGame *)pbNativeMoreGame;

@end
#endif
