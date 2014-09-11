//
//  JupengWall.h
//  JpSDK
//
//  Created by jupeng on 14-2-28.
//  Copyright (c) 2014年 Jupeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JupengAdOpenData.h"
#import "JupengWallDelegate.h"



/*---------------------- 巨朋积分墙接口 --------------------*/
//
@interface JupengWall : NSObject

/*! 显示积分墙
 * \param hostViewController 显示积分墙的ViewController
 * \param didShowBlock 成功显示积分墙时执行的block
 * \param didDismissBlock 关闭积分墙后执行的block
 * \returns 是否显示积分墙成功，积分墙显示不成功并不会调用didShowBlock和didDismissBlock
 */
+ (void)showOffers:(UIViewController*)hostViewController didShowBlock:(void (^)(void))didShowBlock didDismissBlock:(void (^)(void))didDismissBlock;

/*! 显示积分墙
 * \param hostViewController 显示积分墙的ViewController
 * \param delegate 显示或者关闭积分墙的delegate
 */
+ (void)showOffers:(UIViewController*)hostViewController withWallDelegate:(id<JupengWallDelegate>) delegate;

// 获取用户总积分
// \param didGetBlock NSError: 如果成功，返回空，如果失败，返回具体的错误值；NSInteger 返回用户账目上的总积分
+ (void)getScore:(void(^)(NSError*,NSInteger))didGetBlock;

/*
 * 减少积分
 * \param score 减少的积分数
 * \param didSpendBlock NSError: 如果成功，返回空，如果失败，返回具体的错误值； NSInteger 返回用户账目上剩余的总积分
 */
+ (void)spendScore:(NSUInteger)scores didSpendBlock:(void(^)(NSError*,NSInteger))didSpendBlock;

/*
 * 检查是否积分墙可以使用
 */
+(void) checkWallEnable:(void (^)(NSError*,BOOL))checkBlock;


// 用于服务器积分对接,开发者在客户端设置自定义参数,参数可以传递给对接服务器
// \param UserID	: 需要传递给对接服务器的自定义参数
+ (void) setServerUserID:(NSString*)UserID;

/*
 *\获取积分墙的广告数据源列表
 */
+ (void) requestAdOpenData:(void (^)(NSArray*, NSError *))receivedDataBlock;


/*  安装积分墙中的APP
 *  param ad: 通过requestAdOpenData获得的广告
 */
+ (void) installClickAd:(JupengAdOpenData *)ad;




@end


